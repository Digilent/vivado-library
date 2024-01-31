
-------------------------------------------------------------------------------
--
-- File: ZmodSDRController.vhd
-- Author: Tudor Gherman, Robert Bocos
-- Original Project: ZmodDigitizerController
-- Date: January 2024
--
-------------------------------------------------------------------------------
-- (c) 2023 Copyright Digilent Incorporated
-- All Rights Reserved
-- 
-- This program is free software; distributed under the terms of BSD 3-clause 
-- license ("Revised BSD License", "New BSD License", or "Modified BSD License")
--
-- Redistribution and use in source and binary forms, with or without modification,
-- are permitted provided that the following conditions are met:
--
-- 1. Redistributions of source code must retain the above copyright notice, this
--    list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above copyright notice,
--    this list of conditions and the following disclaimer in the documentation
--    and/or other materials provided with the distribution.
-- 3. Neither the name(s) of the above-listed copyright holder(s) nor the names
--    of its contributors may be used to endorse or promote products derived
--    from this software without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
-- FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
-- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
-- SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
-- CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
-- OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
-- OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-------------------------------------------------------------------------------
--
-- This module interfaces directly with the Zmod SDR 1450-122.
-- It configures the clock generator over I2C, writes an initial 
-- configuration to the AD96xx/AD92xx on the Zmod via the SPI interface, 
-- demultiplexes the data received over the ADC's parallel interface and 
-- forwards it to the upper levels. 
--  
-------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.VComponents.all;
library work;
use work.PkgZmodDigitizer.all;

entity ZmodSDRController is
    Generic (
        -- Parameter identifying the Zmod:   
        -- 6 -> Zmod SDR 1450 - 122 (AD9648)
        kZmodID : integer range 6 to 6 := 6;
        -- ADC Clock divider ratio (Register 0x0B).
        kADC_ClkDiv : integer range 1 to 1 := 1;
        -- ADC number of bits.
        kADC_Width : integer range 14 to 14 := 14;
        -- Enable/Disable SPI Indirect Access Port.
        kExtCmdInterfaceEn : boolean := false;
        -- Clock Generator I2C shortened config for simulation
        kCG_SimulationConfig : boolean := false;
        -- Clock Generator I2C shortened configuration number of commands to send over I2C for simulation (zero based), range should have been
        --0 to kCDCE_RegNrZeroBased := kCDCE_RegNrZeroBased, however Vivado IP GUI does not accept expressions
        kCG_SimulationCmdTotal : integer range 0 to 85 := 85; 
        -- Clock Generator I2C 8 bit config address (0xCE(Fall-Back Mode), 0xD0(Default Mode), 0xD2)
        kCGI2C_Addr : std_logic_vector(7 downto 0) := x"CE";
        -- Clock Generator input reference clock selection parameter ('0' selects SECREF(XTAL) and '1' selects PRIREF(FPGA))
        kRefSel : std_logic := '0';
        -- Clock Generator EEPROM Page selection parameter ('0' selects Page 0 and '1' selects Page 1)
        kHwSwCtrlSel : std_logic := '1';
        -- Parameter identifying the CDCE output frequency with SECREF(XTAL) as reference frequency, range should have been
        --0 to CDCE_I2C_Cmds'length, however Vivado IP GUI does not accept expressions:
        -- 0 -> 122.88MHz       
        -- 1 -> 50MHz       
        -- 2 -> 80MHz    
        -- 3 -> 100MHz       
        -- 4 -> 110MHz       
        -- 5 -> 120MHz       
        -- 6 -> 125MHz
        kCDCEFreqSel : integer range 0 to 6 := 0
    );
    Port (
        -- 100MHZ clock input.
        SysClk100 : in  std_logic;
        -- Primary Reference Clock for the Clock Generator present on the Zmod Pod. 
        -- Due to the fact that there is also an XTAL connected to the SECREF port
        -- of the Clock Generator and that it is the one used by default, another
        -- source of clock signals, namely ClockGenPriRefClk, is entirely optional.
        -- This reference clock is only used if kRefSel(REFSEL) is HIGH or if PRIREF is set in the R2 register (Address 0x02) of the CDCE6214-Q1
        ClockGenPriRefClk : in  std_logic;
        -- Clock Generator config done succesful signal
        sInitDoneClockGen : out std_logic;
        -- Clock Generator PLL lock signal sent via the GPIO1 or GPIO4 port and synchronized in the SysClock100 domain
        sPLL_LockClockGen : out std_logic;
        -- MMCM output clock buffered by a BUFG
        ZmodDcoClkOut : out std_logic;
        sZmodDcoPLL_Lock : out std_logic;
        -- Asynchronous reset signal (negative polarity).   
        aRst_n : in std_logic;
        -- ADC initialization complete signaling.
        sInitDoneADC : out std_logic;
        -- ADC initialization error signaling.  
        sConfigError : out std_logic;
        -- When logic '1', this signal enables data acquisition from the ADC. This signal
	    -- should be kept in logic '0' until the downstream IP (e.g. DMA controller) is
	    -- ready to receive the ADC data.
	    sEnableAcquisition : in std_logic;

        --AXI Stream (master) data interface
        doDataAxisTvalid: OUT STD_LOGIC;
        doDataAxisTready: IN STD_LOGIC;
        doDataAxisTdata: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        -- SPI Indirect access port; it provides the means to indirectly access
        -- the ADC registers. It is designed to interface with 2 AXI StreamFIFOs, 
        -- one that stores commands to be transmitted and one to store the received data.

        -- TX command AXI stream interface
        sCmdTxAxisTvalid: IN STD_LOGIC;
        sCmdTxAxisTready: OUT STD_LOGIC;
        sCmdTxAxisTdata: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        -- RX command AXI stream interface
        sCmdRxAxisTvalid: OUT STD_LOGIC;
        sCmdRxAxisTready: IN STD_LOGIC;
        sCmdRxAxisTdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);

        --- ADC signals (see AD96xx data sheet) ---
        
        -- ADC Sync signal.
        aZmodSync : out std_logic;
        -- ADC DCO.
        DcoClkIn : in std_logic;
        -- ADC Data.
        diZmodSDR_Data : in std_logic_vector(kADC_Width-1 downto 0);
        -- ADC SPI interface.
        sZmodSDR_SDIO : inout std_logic;
        sZmodSDR_CS   : out std_logic;
        sZmodSDR_Sclk : out std_logic;

        --- ClockGen Signals (see CDCE6214-Q1 datasheet)---
        
        -- ClockGen differential input reference clock (PRIREF), only matters if REFSEL is set to '1' or if PRIREF is set in the R2 register (Address 0x02) of the CDCE6214-Q1
        CG_InputClk_p : out std_logic;
        CG_InputClk_n : out std_logic;
        
        -- Clock Generator PLL lock signal sent via the GPIO1 or GPIO4 port
        aCG_PLL_Lock : in std_logic;
        -- Clock Generator reference selection signal ('0' selects SECREF(XTAL) and '1' selects PRIREF(FPGA))
        aREFSEL : out std_logic;
        -- Clock Generator EEPROM Page selection signal
        aHW_SW_CTRL : out std_logic;
        -- Clock Generator power down signal, passthrough output
        sPDNout_n : out std_logic;
        ----------------------------------------------------------------------------------
        -- IIC bus signals
        ----------------------------------------------------------------------------------
        s_scl_i : in std_logic; -- IIC Serial Clock Input from 3-state buffer (required)
        s_scl_o : out std_logic; -- IIC Serial Clock Output to 3-state buffer (required)
        s_scl_t : out std_logic; -- IIC Serial Clock Output Enable to 3-state buffer (required)
        s_sda_i : in std_logic; -- IIC Serial Data Input from 3-state buffer (required)
        s_sda_o : out std_logic; -- IIC Serial Data Output to 3-state buffer (required)
        s_sda_t : out std_logic -- IIC Serial Data Output Enable to 3-state buffer (required)


    );
end ZmodSDRController;

architecture Behavioral of ZmodSDRController is

    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO of sCmdTxAxisTdata:  SIGNAL is "xilinx.com:interface:axis:1.0 SPI_IAP_TX TDATA";
    ATTRIBUTE X_INTERFACE_INFO of sCmdTxAxisTvalid: SIGNAL is "xilinx.com:interface:axis:1.0 SPI_IAP_TX TVALID";
    ATTRIBUTE X_INTERFACE_INFO of sCmdTxAxisTready: SIGNAL is "xilinx.com:interface:axis:1.0 SPI_IAP_TX TREADY";
    ATTRIBUTE X_INTERFACE_INFO of sCmdRxAxisTdata:  SIGNAL is "xilinx.com:interface:axis:1.0 SPI_IAP_RX TDATA";
    ATTRIBUTE X_INTERFACE_INFO of sCmdRxAxisTvalid: SIGNAL is "xilinx.com:interface:axis:1.0 SPI_IAP_RX TVALID";
    ATTRIBUTE X_INTERFACE_INFO of sCmdRxAxisTready: SIGNAL is "xilinx.com:interface:axis:1.0 SPI_IAP_RX TREADY";

    ATTRIBUTE X_INTERFACE_INFO of doDataAxisTdata:  SIGNAL is "xilinx.com:interface:axis:1.0 DataStream TDATA";
    ATTRIBUTE X_INTERFACE_INFO of doDataAxisTvalid: SIGNAL is "xilinx.com:interface:axis:1.0 DataStream TVALID";
    ATTRIBUTE X_INTERFACE_INFO of doDataAxisTready: SIGNAL is "xilinx.com:interface:axis:1.0 DataStream TREADY";

    ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
    ATTRIBUTE X_INTERFACE_PARAMETER of sCmdTxAxisTdata:  SIGNAL is "CLK_DOMAIN SysClk100";
    ATTRIBUTE X_INTERFACE_PARAMETER of sCmdTxAxisTvalid: SIGNAL is "CLK_DOMAIN SysClk100";
    ATTRIBUTE X_INTERFACE_PARAMETER of sCmdTxAxisTready: SIGNAL is "CLK_DOMAIN SysClk100";
    ATTRIBUTE X_INTERFACE_PARAMETER of sCmdRxAxisTdata:  SIGNAL is "CLK_DOMAIN SysClk100";
    ATTRIBUTE X_INTERFACE_PARAMETER of sCmdRxAxisTvalid: SIGNAL is "CLK_DOMAIN SysClk100";
    ATTRIBUTE X_INTERFACE_PARAMETER of sCmdRxAxisTready: SIGNAL is "CLK_DOMAIN SysClk100";
    ATTRIBUTE X_INTERFACE_PARAMETER of doDataAxisTdata:  SIGNAL is "CLK_DOMAIN DcoClkOut";
    ATTRIBUTE X_INTERFACE_PARAMETER of doDataAxisTvalid: SIGNAL is "CLK_DOMAIN DcoClkOut";
    ATTRIBUTE X_INTERFACE_PARAMETER of doDataAxisTready: SIGNAL is "CLK_DOMAIN DcoClkOut";

    ATTRIBUTE X_INTERFACE_INFO of s_scl_i: SIGNAL is "xilinx.com:interface:iic:1.0 CDCE_IIC SCL_I";
    ATTRIBUTE X_INTERFACE_INFO of s_scl_o: SIGNAL is "xilinx.com:interface:iic:1.0 CDCE_IIC SCL_O";
    ATTRIBUTE X_INTERFACE_INFO of s_scl_t: SIGNAL is "xilinx.com:interface:iic:1.0 CDCE_IIC SCL_T";
    ATTRIBUTE X_INTERFACE_INFO of s_sda_i: SIGNAL is "xilinx.com:interface:iic:1.0 CDCE_IIC SDA_I";
    ATTRIBUTE X_INTERFACE_INFO of s_sda_o: SIGNAL is "xilinx.com:interface:iic:1.0 CDCE_IIC SDA_O";
    ATTRIBUTE X_INTERFACE_INFO of s_sda_t: SIGNAL is "xilinx.com:interface:iic:1.0 CDCE_IIC SDA_T";

    --Reset signals
    signal adoRst_n, asRst_n, adoRst, asRst, aRst, aiRst : std_logic;
    --PLL&Clock signals
    signal DcoClkOut : std_logic;
    signal ZmodDcoPostBufg, ZmodDcoPostBufio : std_logic;
    signal ZmodDcoPLL_LockState : std_logic;
    --Initialization complete flags
    signal cInitDone, sInitDone, dInitDone : std_logic := '0';
    signal sInitDoneADC_Loc : std_logic := '0';

    --Data Path
    signal OddrClk : std_logic;
    signal doDataValid, doDataCalibValid : std_logic;
    signal dFIFO_WrRstBusy, sFIFO_WrRstBusy, sFIFO_WrRstBusyDly: std_logic;
    signal cFIFO_RdEn: std_logic;
    signal dDataOverflow: std_logic;
    signal sInitDoneClockGen_Loc : std_logic;
    signal sConfigADCEnable : std_logic;
    signal doEnableAcquisition: std_logic := '0';
    --Calibration
    signal doChannelA, doChannelB : std_logic_vector(kADC_Width-1 downto 0);
    signal doCh1Calib, doCh2Calib : std_logic_vector(15 downto 0);
    signal doTestMode : std_logic;
    --Sync OSERDES input
    signal doADC_SyncOserdes : std_logic_vector(7 downto 0);
    constant kDummy : std_logic_vector(8 downto 0) := (others => '0');
    constant kSamplingPeriod : integer := integer(DCO_ClockPeriod(kCDCEFreqSel));
    constant kSamplingPeriodReal : real := (real(kSamplingPeriod)*0.001);

begin

    ------------------------------------------------------------------------------------------
    -- Reset tree
    ------------------------------------------------------------------------------------------ 

    -- The asynchronous reset input is converted to an RSD (reset with synchronous
    -- de-assertion) in the SysClk100 domain, in the DcoClkOut domain and in
    -- the ClockGenPriRefClk domain.

    InstSDR_SysReset : entity work.ResetBridge
        Generic map(
            kPolarity => '0')
        Port map(
            aRst => aRst_n,
            OutClk => SysClk100,
            aoRst => asRst_n);

    asRst <= not asRst_n;

    InstSDR_SamplingReset : entity work.ResetBridge
        Generic map(
            kPolarity => '0')
        Port map(
            aRst => aRst_n,
            OutClk => DcoClkOut,
            aoRst => adoRst_n);

    adoRst <= not adoRst_n;

    aRst <= not aRst_n;

    InstClockGenPriRefClkReset : entity work.ResetBridge
        Generic map(
            kPolarity => '1')
        Port map(
            aRst => aRst,
            OutClk => ClockGenPriRefClk,
            aoRst => aiRst);
            
    ------------------------------------------------------------------------------------------
    -- Clock Generator I2C configuration
    ------------------------------------------------------------------------------------------    

    InstConfigCDCE: entity work.ConfigClockGen
        Generic Map(
            kCDCE_SimulationConfig => kCG_SimulationConfig,
            kCDCE_SimulationCmdTotal => kCG_SimulationCmdTotal,
            kCDCEI2C_Addr => kCGI2C_Addr,
            kRefSel => kRefSel,
            kHwSwCtrlSel => kHwSwCtrlSel,
            kFreqSel => kCDCEFreqSel
        )
        Port Map(
            RefClk => SysClk100,
            -- Reset signal asynchronously asserted and synchronously 
            -- de-asserted (in SysClk100 domain).
            arRst => asRst,
            rInitConfigDoneClockGen =>  sInitDoneClockGen_Loc,
            aCG_PLL_Lock => aCG_PLL_Lock,
            rPLL_LockClockGen => sPLL_LockClockGen,
            rConfigADCEnable => sConfigADCEnable,
            aREFSEL => aREFSEL,
            aHW_SW_CTRL => aHW_SW_CTRL,
            rPDNout_n => sPDNout_n,
            ----------------------------------------------------------------------------------
            -- I2C bus signals
            ----------------------------------------------------------------------------------
            s_scl_i => s_scl_i,
            s_scl_o => s_scl_o,
            s_scl_t => s_scl_t,
            s_sda_i => s_sda_i,
            s_sda_o => s_sda_o,
            s_sda_t => s_sda_t
        );
        
       sInitDoneClockGen <= sInitDoneClockGen_Loc;

    ------------------------------------------------------------------------------------------
    -- ADC SPI configuration
    ------------------------------------------------------------------------------------------ 

    InstConfigADC: entity work.ConfigADC
        Generic Map(
            kZmodID => kZmodID,
            kADC_ClkDiv => kADC_ClkDiv,
            kDataWidth => kSPI_DataWidth,
            kCommandWidth => kSPI_CommandWidth,
            kSimulation => kCG_SimulationConfig
        )
        Port Map(
            --
            SysClk100 => SysClk100,
            asRst_n => asRst_n,
            sInitDoneADC => sInitDoneADC_Loc,
            sConfigError => sConfigError,
            sConfigADCEnable => sConfigADCEnable,
            --ADC SPI interface signals
            sADC_Sclk => sZmodSDR_Sclk,
            sADC_SDIO => sZmodSDR_SDIO,
            sADC_CS => sZmodSDR_CS,
            sCmdTxAxisTvalid => sCmdTxAxisTvalid,
            sCmdTxAxisTready => sCmdTxAxisTready,
            sCmdTxAxisTdata => sCmdTxAxisTdata,
            sCmdRxAxisTvalid => sCmdRxAxisTvalid,
            sCmdRxAxisTready => sCmdRxAxisTready,
            sCmdRxAxisTdata =>  sCmdRxAxisTdata
        );

    sInitDoneADC <= sInitDoneADC_Loc;

    ------------------------------------------------------------------------------------------
    -- DATA PATH
    ------------------------------------------------------------------------------------------   
    -- Since the reset value of the InstSyncAsyncEnableAcquisitionDco module is known,
    -- the reset can be safely left permanently de-asserted
    InstSyncAsyncEnableAcquisitionDco: entity work.SyncAsync
    generic map (
      kResetTo => '0',
      kStages => 2)
    port map (
      aoReset => '0',
      aIn => sEnableAcquisition,
      OutClk => DcoClkOut,
      oOut => doEnableAcquisition);
    
    InstDataPath : entity work.DataPath
        Generic Map(
            kSamplingPeriod => kSamplingPeriodReal,
            kADC_Width => kADC_Width
        )
        Port Map(
            RefClk => SysClk100,
            arRst => asRst,
            adoRst => adoRst,
            DcoClkIn => DcoClkIn,
            DcoClkOut => DcoClkOut,
            rDcoMMCM_LockState => sZmodDcoPLL_Lock,
            doEnableAcquisition => doEnableAcquisition,
            diADC_Data => diZmodSDR_Data,
            doChannelA => doChannelA,
            doChannelB => doChannelB,
            doDataOutValid => doDataValid
        );
        
        ZmodDcoClkOut <= DcoClkOut;

    ------------------------------------------------------------------------------------------
    -- Clock Generator CLKIN (PRIREF)
    ------------------------------------------------------------------------------------------ 

    InstCG_ClkODDR : ODDR
        generic map(
            DDR_CLK_EDGE => "OPPOSITE_EDGE", -- "OPPOSITE_EDGE" or "SAME_EDGE" 
            INIT => '0',   -- Initial value for Q port ('1' or '0')
            SRTYPE => "ASYNC") -- Reset Type ("ASYNC" or "SYNC")
        port map (
            Q => OddrClk,   -- 1-bit DDR output
            C => ClockGenPriRefClk,    -- 1-bit clock input
            CE => '1',  -- 1-bit clock enable input
            D1 => '1',  -- 1-bit data input (positive edge)
            D2 => '0',  -- 1-bit data input (negative edge)
            R => aiRst,    -- 1-bit reset input
            S => '0'     -- 1-bit set input
        );

    InstCG_ClkOBUFDS : OBUFDS
        generic map (
            IOSTANDARD => "DEFAULT", -- Specify the output I/O standard
            SLEW => "SLOW")          -- Specify the output slew rate
        port map (
            O => CG_InputClk_p,     -- Diff_p output (connect directly to top-level port)
            OB => CG_InputClk_n,   -- Diff_n output (connect directly to top-level port)
            I => OddrClk      -- Buffer input 
        );

    ------------------------------------------------------------------------------------------
    -- Calibration - (as the ZmodSDR does not require calibration the GainOffsetCalib modules will just output raw data)
    ------------------------------------------------------------------------------------------  

    -- Instantiate the calibration modules for both channels.

    InstCh1ADC_Calibration : entity work.GainOffsetCalib
        Generic Map(
            kWidth => kADC_Width,
            kExtCalibEn => false,--Force No Calibration
            kInvert => true
        )
        Port Map
        (
            SamplingClk => DcoClkOut,
            acRst_n => adoRst_n,
            cTestMode => '1',--Force No Calibration
            cDataAcceptanceReady => doDataAxisTready,
            cExtLgMultCoef => (others => '0'),
            cExtLgAddCoef => (others => '0'),
            cExtHgMultCoef => (others => '0'),
            cExtHgAddCoef => (others => '0'),
            cGainState => '1', --Force High Gain
            cDataRaw => doChannelA,
            cDataInValid => doDataValid,
            cCalibDataOut => doCh1Calib,
            cDataCalibValid => doDataCalibValid
        );

    InstCh2ADC_Calibration : entity work.GainOffsetCalib
        Generic Map(
            kWidth => kADC_Width,
            kExtCalibEn => false,--Force No Calibration
            kInvert => false
        )
        Port Map
(
            SamplingClk => DcoClkOut,
            acRst_n => adoRst_n,
            cTestMode => '1',--Force No Calibration
            cDataAcceptanceReady => doDataAxisTready,
            cExtLgMultCoef => (others => '0'),
            cExtLgAddCoef => (others => '0'),
            cExtHgMultCoef => (others => '0'),
            cExtHgAddCoef => (others => '0'),
            cGainState => '1', --Force High Gain
            cDataRaw => doChannelB,
            cDataInValid => doDataValid,
            cCalibDataOut => doCh2Calib,
            cDataCalibValid => open --both channels share the same valid signal
        );

    doDataAxisTdata <= doCh1Calib & doCh2Calib;
    doDataAxisTvalid <= doDataCalibValid;

    SDR_SyncGenerate: if(kADC_ClkDiv = 1) generate
        aZmodSync <= '1';
    end generate;

end Behavioral;

