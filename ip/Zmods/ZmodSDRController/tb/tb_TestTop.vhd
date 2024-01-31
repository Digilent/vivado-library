
-------------------------------------------------------------------------------
--
-- File: tb_TestTop.vhd
-- Author: Tudor Gherman, Robert Bocos
-- Original Project: ZmodScopeController
-- Date: January 2024
--
-------------------------------------------------------------------------------
-- (c) 2020 Copyright Digilent Incorporated
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
-- Top level test bench. This test bench does not extensively test all modules
-- of the ZmodScopeController. Such tests are carried out at component level. 
-- A simulation model is provided for the ADC SPI interface to test  
-- configuration registers read/write commands. 
-- A command queue is loaded into an external FIFO to exercise the IP's SPI 
-- indirect access port. 
-- A ramp signal is used as stimulus for the data bus. The calibrated samples
-- output by the IP are compared against the expected values in order to test
-- the calibration functionality.
--  
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.PkgZmodDigitizer.all;
library UNISIM;
use UNISIM.VComponents.all;

entity tb_TestTop is
   Generic (
      -- Parameter identifying the Zmod:       
      -- 6 -> Zmod Scope 1410 - 125 (AD9648)
      kZmodID : integer range 6 to 6 := 6;
      -- Sampling Clock Period of type "time" in ns 
      kADC_SamplingClkPeriod : time := 8.138ns;
      -- ADC Clock divider ratio (Register 0x0B of AD96xx and AD92xx)
      kADC_ClkDiv : integer range 1 to 1 := 1;
      -- Enable/Disable SPI Inirect Access Port
      kExtCmdInterfaceEn : boolean := true;
      -- Clock Generator I2C config address (0x67, 0x68(Default), 0x69)
      kCDCEI2C_Addr : std_logic_vector(7 downto 0) := x"CE";
	  --Parameter to shorten the Clock generator configuration time over I2C
      kCDCE_SimulationConfig : boolean := true;
      -- Clock Generator I2C shortened configuration number of commands to send over I2C for simulation
      kCDCE_SimulationCmdTotal : integer range 0 to kCDCE_RegNrZeroBased := 2;
      -- Parameter identifying the CDCE output frequency with SECREF(XTAL) as reference frequency:
      -- 0 -> 122.88MHz       
      -- 1 -> 30MHz       
      -- 2 -> 40MHz    
      -- 3 -> 50MHz       
      -- 4 -> 60MHz       
      -- 5 -> 80MHz       
      -- 6 -> 100MHz
      -- 7 -> 120MHz
      kCDCEFreqSel : integer range 0 to CDCE_I2C_Cmds'length := 0
   );
end tb_TestTop;

architecture Behavioral of tb_TestTop is
 
constant kNumClockCycles : integer := 5000000; 
-- ADC number of bits.
constant kADC_Width : integer := SelADC_Width(kZmodID);

signal SysClk100: std_logic := '1';   
signal ADC_SamplingClk: std_logic := '1';    
signal CDCE_InClk: std_logic := '1';
signal DcoClkOut : std_logic := '1';    
signal aRst_n, aRst: std_logic; 
signal sInitDoneADC: std_logic;  
signal sConfigError: std_logic;  
signal doDataAxisTvalid: STD_LOGIC;
signal doDataAxisTready: STD_LOGIC;
signal doDataAxisTdata: STD_LOGIC_VECTOR(31 DOWNTO 0);                 
signal doSyncIn: std_logic_vector(kADC_ClkDiv-1 downto 0);             
signal sCmdTxAxisTvalid: STD_LOGIC;
signal sCmdTxAxisTready: STD_LOGIC;
signal sCmdTxAxisTdata: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal sCmdRxAxisTvalid: STD_LOGIC;
signal sCmdRxAxisTready: STD_LOGIC;
signal sCmdRxAxisTdata: STD_LOGIC_VECTOR(31 DOWNTO 0);  
signal ZmodAdcClkIn_p: std_logic;
signal ZmodAdcClkIn_n: std_logic;
signal aZmodSync: std_logic;
signal ZmodDcoClk, ZmodDcoClkDly: std_logic := '1';
signal diZmodADC_Data: std_logic_vector(kADC_Width-1 downto 0);
signal sZmodADC_SDIO: std_logic;
signal sZmodADC_CS: std_logic;
signal sZmodADC_Sclk: std_logic;
signal s_scl_i : std_logic;
signal s_scl_o : std_logic;
signal s_scl_t : std_logic;
signal s_sda_i : std_logic;
signal s_sda_o : std_logic;
signal s_sda_t : std_logic;
signal t_scl_io : std_logic;
signal t_sda_io : std_logic;
signal e_scl_i : std_logic;
signal e_scl_o : std_logic;
signal e_scl_t : std_logic;
signal e_sda_i : std_logic;
signal e_sda_o : std_logic;
signal e_sda_t : std_logic;
signal sZmodDcoPLL_Lock : std_logic;
signal aCG_PLL_Lock : std_logic := '1';
signal sInitDoneClockGen : std_logic;
signal sPLL_LockClockGen : std_logic;
signal REFSEL : std_logic;
signal HW_SW_CTRL : std_logic;
signal PDN : std_logic;

signal diZmodADC_DataCnt : unsigned(kADC_Width-1 downto 0);
signal diDataGenCntEn, diDataGenRst_n : std_logic;
signal doChA_DataPathTest, doChB_DataPathTest : std_logic_vector (kADC_Width-1 downto 0);
signal doChannel1_Test, doChannel2_Test : std_logic_vector(kADC_Width-1 downto 0);
signal doCh1OutInt, doCh2OutInt : integer;
signal doCh1TestInt, doCh2TestInt : integer;
signal doCh1Diff, doCh2Diff : integer;
signal aEnOverflowTest : std_logic;
signal sEnableAcquisition : std_logic; 

constant kSysClkPeriod : time := 10ns; -- System Clock Period
--constant kADC_SamplingClkPeriod : time := 8.138ns;
constant kInitDoneLatency : time := kSysClkPeriod;
-- 2 stages SyncAsync module latency for crossings in SysClk100 domain
constant kSyncAsyncSysLatency: time := kSysClkPeriod*2; 
-- Handshake data module latency when crossing from SysClk100 to ADC_samplingClk domain.
constant kHandshakeSys2ADC_Latency: time := kSysClkPeriod+4*kADC_SamplingClkPeriod; 
-- The latency with which cDataAxisTvalid is de-asserted after a relay state modification
-- is requested.
-- The sInitDoneRelay signal is pushed through a HandshakeData 
-- synchronization module and it will take 1 extra ADC_samplingClk cycle for the
-- FIFO reset to be generated.
-- The ADC_Calibration module adds a latency of extra 3 ADC_SamplingClk cycles
-- The valid signal should be de-asserted in HandshakeDataLatency + 
-- + 3 ADC_SamplingClk cycles + 1 ADC_SamplingClk cycle (wait for valid de-assert after FIFO reset).
constant kAxisValidLatency : time := kHandshakeSys2ADC_Latency + 4*kADC_SamplingClkPeriod;
-- Synchronization FIFO depth
constant kSyncFIFO_Depth : integer := 16;
-- Time required for sDataOverflow to assert after cDataAxisTready is de-asserted: 
-- If the FIFO is empty and rd_en is de-asserted it will take kSyncFIFO_Depth write clock cycles 
-- to fill the FIFO. 1 extra clock cycle will be required by the FIFO to assert the overflow
-- signal, 1 clock cycle will be added by the ProcDataOverflow synchronous process and a maximum 
-- time interval equal to kSyncAsyncSysClkLatency is added to pass the dDataOverflow into the 
-- SysClk100 domain. This assessment is based on the presumption that the FIFO wr_en signal is
-- asserted for longer that the FIFO latency before the rd_en signal is de-asserted.      
constant kOverflowLatency: time := kSyncAsyncSysLatency + kSyncFIFO_Depth * kADC_SamplingClkPeriod + 2 * kADC_SamplingClkPeriod;

constant kSamplingPeriod : integer := integer(DCO_ClockPeriod(kCDCEFreqSel));
constant kSamplingPeriodReal : real := (real(kSamplingPeriod)*0.001);
  
begin

------------------------------------------------------------------------------------------
--Top level component instantiation
------------------------------------------------------------------------------------------ 

InstZmodDigitizer_Cotroller: entity work.ZmodSDRController
   Generic Map(
      kZmodID => kZmodID,
      kADC_ClkDiv => kADC_ClkDiv,
      kADC_Width => kADC_Width,
      kExtCmdInterfaceEn => kExtCmdInterfaceEn,
      kCGI2C_Addr => kCDCEI2C_Addr,
      kCG_SimulationConfig => kCDCE_SimulationConfig,
      kCG_SimulationCmdTotal => kCDCE_SimulationCmdTotal,
      kCDCEFreqSel => kCDCEFreqSel
   )
   Port Map(
      SysClk100 => SysClk100,
      ClockGenPriRefClk => CDCE_InClk,
      aRst_n => aRst_n,
      sInitDoneADC => sInitDoneADC,
      sConfigError => sConfigError,
      sEnableAcquisition => sEnableAcquisition,
      doDataAxisTvalid => doDataAxisTvalid,
      doDataAxisTready => doDataAxisTready,
      doDataAxisTdata => doDataAxisTdata,                                    
      sCmdTxAxisTvalid => sCmdTxAxisTvalid,
      sCmdTxAxisTready => sCmdTxAxisTready,
      sCmdTxAxisTdata =>  sCmdTxAxisTdata,
      sCmdRxAxisTvalid => sCmdRxAxisTvalid,
      sCmdRxAxisTready => sCmdRxAxisTready,
      sCmdRxAxisTdata  => sCmdRxAxisTdata, 
   
      CG_InputClk_p => ZmodAdcClkIn_p,
      CG_InputClk_n => ZmodAdcClkIn_n,
      aZmodSync => aZmodSync,
      DcoClkIn => ZmodDcoClk,
      ZmodDcoClkOut => DcoClkOut,
      sZmodDcoPLL_Lock => sZmodDcoPLL_Lock,
      diZmodSDR_Data => diZmodADC_Data,
   
      sZmodSDR_SDIO => sZmodADC_SDIO,
      sZmodSDR_CS => sZmodADC_CS,
      sZmodSDR_Sclk => sZmodADC_Sclk,

      aCG_PLL_Lock => aCG_PLL_Lock,
      sInitDoneClockGen => sInitDoneClockGen,
      sPLL_LockClockGen => sPLL_LockClockGen,
      aREFSEL => REFSEL,
      aHW_SW_CTRL => HW_SW_CTRL,
      sPDNout_n => PDN,
      ----------------------------------------------------------------------------------
      -- IIC bus signals
      ----------------------------------------------------------------------------------
      s_scl_i => s_scl_i, -- IIC Serial Clock Input from 3-state buffer (required)
      s_scl_o => s_scl_o, -- IIC Serial Clock Output to 3-state buffer (required)
      s_scl_t => s_scl_t, -- IIC Serial Clock Output Enable to 3-state buffer (required)
      s_sda_i => s_sda_i, -- IIC Serial Data Input from 3-state buffer (required)
      s_sda_o => s_sda_o, -- IIC Serial Data Output to 3-state buffer (required)
      s_sda_t => s_sda_t  -- IIC Serial Data Output Enable to 3-state buffer (required)
   );
   
CDCE_IIC_scl_iobuf: component IOBUF
        port map (
            I => s_scl_o,
            IO => t_scl_io,
            O => s_scl_i,
            T => s_scl_t
        );
CDCE_IIC_sda_iobuf: component IOBUF
        port map (
            I => s_sda_o,
            IO => t_sda_io,
            O => s_sda_i,
            T => s_sda_t
        );
        
TWISlave_IIC_scl_iobuf: component IOBUF
        port map (
            I => e_scl_o,
            IO => t_scl_io,
            O => e_scl_i,
            T => e_scl_t
        );
TWISlave_IIC_sda_iobuf: component IOBUF
        port map (
            I => e_sda_o,
            IO => t_sda_io,
            O => e_sda_i,
            T => e_sda_t
        );
        
SlaveController: entity work.ClockGen_I2C_DataCheck
        generic map (
           kSampleClkFreqInMHz => 100,
           kSlaveAddress => kCDCEI2C_Addr(7 downto 1),
           kFreqSel => kCDCEFreqSel
        )
        port map (
           SampleClk => SysClk100,
           SRST => aRst,
            -- two-wire interface
           aSDA_I => e_sda_i,
           aSDA_O => e_sda_o,
           aSDA_T => e_sda_t,
           aSCL_I => e_scl_i,
           aSCL_O => e_scl_o,
           aSCL_T => e_scl_t
        );
      
      --Emulate Pull-Up in Simulation
      t_scl_io <= 'H';
      t_sda_io <= 'H';
------------------------------------------------------------------------------------------
-- SPI test related modules instantiation
------------------------------------------------------------------------------------------ 

InstAD96xx_92xx: entity work.AD96xx_92xxSPI_Model
   Generic Map(
      kZmodID => kZmodID,
      kDataWidth => kSPI_DataWidth,
      kCommandWidth => kSPI_CommandWidth
   )
Port Map(
    SysClk100 => SysClk100,
    asRst_n => aRst_n,
    InsertError => '0', 
    sSPI_Clk => sZmodADC_Sclk,
    sSDIO => sZmodADC_SDIO,
    sCS => sZmodADC_CS
    );     

TestCmdFIFO: entity work.SPI_IAP_TestModule
   Generic Map(
      kZmodID => kZmodID
   )
   Port Map( 
      SysClk100 => SysClk100,
      asRst_n => aRst_n,
      sInitDoneADC => sInitDoneADC,
      sCmdTxAxisTvalid => sCmdTxAxisTvalid,
      sCmdTxAxisTready => sCmdTxAxisTready,
      sCmdTxAxisTdata => sCmdTxAxisTdata,
      sCmdRxAxisTvalid => sCmdRxAxisTvalid,
      sCmdRxAxisTready => sCmdRxAxisTready,
      sCmdRxAxisTdata => sCmdRxAxisTdata
   );

------------------------------------------------------------------------------------------
-- Data path & calibration test related modules instantiation
------------------------------------------------------------------------------------------ 
InstDataPathDlyCh1 : entity work.DataPathLatency
    Generic Map (
        kNumFIFO_Stages => 0,
        kDataWidth => kADC_Width
    )
    Port Map(
        ZmodDcoClk => DcoClkOut,
        ZmodDcoClkDly => ZmodDcoClkDly,
        doDataIn => diZmodADC_Data, 
        doChA_DataOut => doChA_DataPathTest,
		doChB_DataOut => doChB_DataPathTest);
        
InstCalibDataRefCh1 : entity work.CalibDataReference 
    Generic Map (
        kWidth => kADC_Width,
        kExtCalibEn => false,
        kInvert => true,
        kLatency => 2,
        kTestLatency => 1 
    )
    Port Map(
        SamplingClk => DcoClkOut,
        cTestMode => '1', -- sTestMode is constant in the current test bench
        cChIn => doChA_DataPathTest,
        cChOut => doChannel1_Test,
        cExtLgMultCoef => (others => '0'),
        cExtLgAddCoef  => (others => '0'),
        cExtHgMultCoef => (others => '0'),
        cExtHgAddCoef  => (others => '0'),
        cGainState => '1' --Force High Gain
        );

InstCalibDataRefCh2 : entity work.CalibDataReference 
    Generic Map (
        kWidth => kADC_Width,
        kExtCalibEn => false,
        kInvert => false,
        kLatency => 2,
        kTestLatency => 1  
    )
    Port Map(
        SamplingClk => DcoClkOut,
        cTestMode => '1', -- sTestMode is constant in the current test bench
        cChIn => doChB_DataPathTest,
        cChOut => doChannel2_Test,
        cExtLgMultCoef => (others => '0'), 
        cExtLgAddCoef  => (others => '0'),
        cExtHgMultCoef => (others => '0'),
        cExtHgAddCoef  => (others => '0'),
        cGainState => '1' --Force High Gain
        );

doCh1OutInt <= to_integer(signed(doDataAxisTdata(31 downto 32-kADC_Width)));               
doCh2OutInt <= to_integer(signed(doDataAxisTdata(15 downto 16-kADC_Width))); 
doCh1TestInt <= to_integer(signed(doChannel1_Test));               
doCh2TestInt <= to_integer(signed(doChannel2_Test));
doCh1Diff <= doCh1OutInt - doCh1TestInt;
doCh2Diff <= doCh2OutInt - doCh2TestInt; 

------------------------------------------------------------------------------------------
-- Clock generation
------------------------------------------------------------------------------------------
 
ProcSystmClock: process
begin
   for i in 0 to kNumClockCycles loop
      wait for kSysClkPeriod/2;
      SysClk100 <= not SysClk100;
      wait for kSysClkPeriod/2;
      SysClk100 <= not SysClk100;
   end loop;
   wait;
end process;

ProcSamplingClk: process
begin
   for i in 0 to kNumClockCycles loop
      wait for kADC_SamplingClkPeriod/2;
      ADC_SamplingClk <= not ADC_SamplingClk;
      wait for kADC_SamplingClkPeriod/2;
      ADC_SamplingClk <= not ADC_SamplingClk;
   end loop;
   wait;
end process; 

ProcCDCE_InClk: process
begin
   for i in 0 to (kNumClockCycles*kADC_ClkDiv) loop
      wait for kADC_SamplingClkPeriod/(2*kADC_ClkDiv);
      CDCE_InClk <= not CDCE_InClk;
      wait for kADC_SamplingClkPeriod/(2*kADC_ClkDiv);
      CDCE_InClk <= not CDCE_InClk;
   end loop;
   wait;
end process; 

ProcDcoClk: process
begin
   wait for kTdcoMax;
   for i in 0 to kNumClockCycles loop
      wait for kADC_SamplingClkPeriod/2;
      ZmodDcoClk <= not ZmodDcoClk;
      wait for kADC_SamplingClkPeriod/2;
      ZmodDcoClk <= not ZmodDcoClk;
   end loop;
   wait;
end process;  

ZmodDcoClkDly <= ZmodDcoClk after
  (IDDR_ClockPhase(kSamplingPeriodReal)/360.0)*kADC_SamplingClkPeriod;

 ------------------------------------------------------------------------------------------
-- Stimuli generation
------------------------------------------------------------------------------------------ 

-- A ramp signal is used as stimuli for the ADC data bus
ProcDataGen: process (ZmodDcoClk)  
begin
   if ((aRst_n = '0') or (diDataGenRst_n = '0')) then
      diZmodADC_DataCnt <= (others => '0');
   elsif (rising_edge(ZmodDcoClk) or falling_edge(ZmodDcoClk)) then
      if (diDataGenCntEn = '1') then
         diZmodADC_DataCnt <= diZmodADC_DataCnt + 1;
      end if;     
   end if;
end process;

diZmodADC_Data <= std_logic_vector(diZmodADC_DataCnt);

aRst <= not aRst_n;

-- Stimuli generated in the SysClk100 domain
ProcSysClkDomainStimuli: process
begin
   -- Assert reset for 10 clock cycles (this covers the minimum 
   -- hold time for the reset signal) 
   aRst_n <= '0';
   aEnOverflowTest <= '0';
   sEnableAcquisition <= '0';
                  
   wait for 10 * kSysClkPeriod;
   wait until falling_edge(SysClk100);
   
   aRst_n <= '1';
   sEnableAcquisition <= '1';
   -- Process 2 * 2^14 samples to make sure all possible inputs are tested after calibration.
   wait for (2**kADC_Width) * kADC_SamplingClkPeriod;
   
   wait until doDataAxisTvalid = '1'; 
   wait;
   
end process;

-- ZmodDcoClk domain stimuli. The counter used to generate the
-- ADC data bus stimuli is free running for this test bench.
ProcDcoDomainStimuli: process
begin

   diDataGenRst_n <= '1';
   diDataGenCntEn <= '1';

   wait; 
end process;

-- DcoClkOut domain stimuli.
ProcDcoClkOutDomainStimuli: process
begin
   doSyncIn(0) <= '1';
   if (kADC_ClkDiv > 1) then
      doSyncIn(kADC_ClkDiv-1 downto 1) <= (others => '0');
   end if;
   
   wait until sInitDoneADC = '1';
   doDataAxisTready <= '1';
   wait; 
end process;

-- Compare the calibrated data samples against the expected values.

ProcCh1CheckCalibData: process
begin
   wait until sInitDoneADC = '1';
   wait until doCh1TestInt'event or doCh1OutInt'event;
   -- doCh1Diff is generated on the rising edge of DcoClkOut
   -- and checked on the negative edge of DcoClkOut.
   wait until falling_edge(DcoClkOut);
   if ((doDataAxisTvalid = '1') and (aEnOverflowTest = '0')) then
      assert (abs(doCh1Diff) < 2)
      report "Calibration error: mismatch between expected data and actual data" & LF & HT & HT &
             "Expected: " & integer'image(to_integer(signed(doChannel1_Test))) & LF & HT & HT &
             "Actual: " & integer'image(doCh1OutInt) & LF & HT & HT &
             "Difference: " & integer'image(doCh1Diff)
      severity ERROR;
   end if;
end process;

ProcCh2CheckCalibData: process
begin
   wait until sInitDoneADC = '1';
   wait until doCh2TestInt'event or doCh2OutInt'event;
   -- doCh2Diff is generated on the rising edge of DcoClkOut
   -- and checked on the negative edge of DcoClkOut.
   wait until falling_edge(DcoClkOut);
   if ((doDataAxisTvalid = '1') and (aEnOverflowTest = '0')) then
      assert (abs(doCh2Diff) < 2)
      report "Calibration error: mismatch between expected data and actual data" & LF & HT & HT &
             "Expected: " & integer'image(to_integer(signed(doChannel2_Test))) & LF & HT & HT &
             "Actual: " & integer'image(doCh2OutInt) & LF & HT & HT &
             "Difference: " & integer'image(doCh2Diff)
      severity ERROR;
   end if;
end process;

ProcCheckADC_Init: process
begin
   wait until sInitDoneClockGen = '1';
   -- Wait for the reset signal to be de-asserted   
   wait until rising_edge(aRst_n);
   -- Check if the sInitDoneADC signal is asserted and sConfigError is de-asserted 
   -- after the configuration timeout period (determined empirically)
   wait for kCount5ms * kSysClkPeriod;
   assert (sInitDoneADC = '1')
      report "sInitDoneADC signal not asserted when expected" & LF & HT & HT 
      severity ERROR;
   assert (sConfigError = '0')
      report "sConfigError signal not de-asserted when expected" & LF & HT & HT 
      severity ERROR;
end process;

	  
end Behavioral;