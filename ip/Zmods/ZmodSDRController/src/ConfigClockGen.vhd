----------------------------------------------------------------------------------
-- Company: digilent.com
-- Engineer: Robert Bocos
-- 
-- Create Date: 2021
-- Design Name: 
-- Module Name: ConfigClockGen - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 2021.1
-- Description: 
-- 
-- Dependencies: PkgZmodDigitizer.vhd, TWI_Ctl.vhd, ResetBridge.vhd, SyncAsync.vhd
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
-------------------------------------------------------------------------------
--
-- This module configures the CDCE6214-Q1 clock generator over I2C.
--  
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

use work.PkgTWI_Utils.ALL;
use work.PkgZmodDigitizer.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity ConfigClockGen is
    Generic(
        -- Clock Generator I2C shortened config for simulation
        kCDCE_SimulationConfig : boolean := false;
        -- Clock Generator I2C shortened configuration number of commands to send over I2C for simulation (zero based)
        kCDCE_SimulationCmdTotal : integer range 0 to kCDCE_RegNrZeroBased := kCDCE_RegNrZeroBased;
        -- Clock Generator I2C 8 bit config address (0xCE(Fall-Back Mode), 0xD0(Default Mode), 0xD2)
        kCDCEI2C_Addr : std_logic_vector(7 downto 0) := x"CE";
        -- Clock Generator input reference clock selection parameter ('0' selects SECREF(XTAL) and '1' selects PRIREF(FPGA))
        kRefSel : std_logic := '0';
        -- Clock Generator EEPROM Page selection parameter ('0' selects Page 0 and '1' selects Page 1)
        kHwSwCtrlSel : std_logic := '1';
        -- Parameter identifying the CDCE output frequency with SECREF(XTAL) as reference frequency:
        -- 0 -> 122.88MHz       
        -- 1 -> 50MHz       
        -- 2 -> 80MHz    
        -- 3 -> 100MHz       
        -- 4 -> 110MHz       
        -- 5 -> 120MHz       
        -- 6 -> 125MHz
        kFreqSel : integer range 0 to CDCE_I2C_Cmds'length := 0
    );
    Port (
        -- 100MHZ clock input. 
        RefClk : in STD_LOGIC;
        -- Reset signal asynchronously asserted and synchronously 
        -- de-asserted (in RefClk domain).
        arRst : in std_logic;
        -- Clock Generator configuration done succesful signal
        rInitConfigDoneClockGen : out std_logic;
        -- Clock Generator PLL lock signal sent via the GPIO1 or GPIO4 port
        aCG_PLL_Lock : in std_logic;
        -- Clock Generator PLL lock signal sent via the GPIO1 or GPIO4 port and synchronized in the RefClk domain
        rPLL_LockClockGen : out std_logic;
        -- rConfigADCEnable is used to hold the ConfigADC module in reset until the Clock Generator is configured and locked
        rConfigADCEnable : out std_logic;
        -- Clock Generator reference selection signal ('0' selects SECREF(XTAL) and '1' selects PRIREF(FPGA))
        aREFSEL : out std_logic;
        -- Clock Generator EEPROM Page selection signal
        aHW_SW_CTRL : out std_logic;
        -- Clock Generator power down signal, passthrough output
        rPDNout_n : out std_logic;
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
end ConfigClockGen;

architecture Behavioral of ConfigClockGen is

    ATTRIBUTE X_INTERFACE_INFO : STRING;
    ATTRIBUTE X_INTERFACE_INFO of s_scl_i: SIGNAL is "xilinx.com:interface:iic:1.0 CDCE_IIC SCL_I";
    ATTRIBUTE X_INTERFACE_INFO of s_scl_o: SIGNAL is "xilinx.com:interface:iic:1.0 CDCE_IIC SCL_O";
    ATTRIBUTE X_INTERFACE_INFO of s_scl_t: SIGNAL is "xilinx.com:interface:iic:1.0 CDCE_IIC SCL_T";
    ATTRIBUTE X_INTERFACE_INFO of s_sda_i: SIGNAL is "xilinx.com:interface:iic:1.0 CDCE_IIC SDA_I";
    ATTRIBUTE X_INTERFACE_INFO of s_sda_o: SIGNAL is "xilinx.com:interface:iic:1.0 CDCE_IIC SDA_O";
    ATTRIBUTE X_INTERFACE_INFO of s_sda_t: SIGNAL is "xilinx.com:interface:iic:1.0 CDCE_IIC SDA_T";
    
    signal rRst : std_logic;
    signal rI2C_ErrorType : error_type;
    signal rCmdCnt : unsigned(6 downto 0) := (others => '0');
    signal rIncCmdCnt, rConfigDone, rReadBackDone : std_logic := '0'; 
    signal rRstCmdCnt : std_logic := '0';
    signal rPLL_LockClockGen_Loc : std_logic := '0';
    signal rConfigADCEnable_Loc : std_logic := '0';
    signal rReadBackErr : std_logic := '0';
    
    constant kCmdTotal : integer range 0 to ((CDCE_I2C_Cmds(kFreqSel)'length)-1) := ((CDCE_I2C_Cmds(kFreqSel)'length)-1);
    constant kReadBackInt : integer range 0 to ((CDCE_I2C_Cmds(kFreqSel)'length)-1) := 83;
    
    signal rState : FsmStatesI2C_t := stIdle;
    signal rNState : FsmStatesI2C_t;

    signal rI2C_DataIn, rI2C_DataOut, rI2C_Address : std_logic_vector(7 downto 0);
    signal rI2C_Stb, rI2C_Done, rI2C_Error, rI2C_Msg, rI2C_Stp : std_logic;
    signal aREFSEL_TriStateCtl : std_logic;
    signal aHW_SW_CTRL_TriStateCtl : std_logic;
    
    attribute DONT_TOUCH : string;
    attribute DONT_TOUCH of rCmdCnt, rIncCmdCnt, rConfigDone, rReadBackDone, rConfigADCEnable_Loc, rRstCmdCnt, rReadBackErr, rState, rNState, rI2C_DataIn, rI2C_DataOut, rI2C_Address, rI2C_Stb, rI2C_Stp, rI2C_Done, rI2C_Error, rI2C_Msg : signal is "TRUE";

begin
    
   OBUFT_REFSEL_inst : OBUFT
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (
      O => aREFSEL,     -- Buffer output (connect directly to top-level port)
      I => kRefSel,     -- Buffer input
      T => aREFSEL_TriStateCtl      -- 3-state enable input 
   );
   
   OBUFT_HWSWCTRL_inst : OBUFT
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (
      O => aHW_SW_CTRL,     -- Buffer output (connect directly to top-level port)
      I => kHwSwCtrlSel,     -- Buffer input
      T => aHW_SW_CTRL_TriStateCtl      -- 3-state enable input 
   );

    -- Instantiate the I2C Master Transmitter
    TWI_Inst: entity work.TWI_Ctl
    Generic Map(
        CLOCKFREQ => 100
    )
    Port Map(
        MSG_I => rI2C_Msg,
        STB_I => rI2C_Stb,
        STP_I => rI2C_Stp,
        A_I => rI2C_Address,
        D_I => rI2C_DataIn,
        D_O => rI2C_DataOut,
        DONE_O => rI2C_Done,
        ERR_O => rI2C_Error,
        ERRTYPE_O => rI2C_ErrorType,
        CLK => RefClk,
        SRST => rRst,
        ----------------------------------------------------------------------------------
        -- TWI bus signals
        ----------------------------------------------------------------------------------
        s_scl_i => s_scl_i,
        s_scl_o => s_scl_o,
        s_scl_t => s_scl_t,
        s_sda_i => s_sda_i,
        s_sda_o => s_sda_o,
        s_sda_t => s_sda_t
        );
        
    TWI_Ctl_Reset_Synchro: entity work.ResetBridge
    Generic map(
        kPolarity => '1')
    Port map(
        aRst => arRst,
        OutClk => RefClk,
        aoRst => rRst);

    Synchro_CDCE_PLL: entity work.SyncAsync
    generic map (
      kResetTo => '0',
      kStages => 2)
    port map (
      aoReset => arRst,
      aIn => aCG_PLL_Lock,
      OutClk => RefClk,
      oOut => rPLL_LockClockGen_Loc);
      
      rPLL_LockClockGen <= rPLL_LockClockGen_Loc;
      rConfigADCEnable <= rConfigADCEnable_Loc;
    
    --Configuration of the ADC over SPI should be done after rConfigADCEnable is asserted which only happens after the CDCE clock generator is configured
    --and the PLL inside the CDCE is locked, otherwise the ADC should be reset and reconfigured
    ConfigADC_Enable: process (RefClk, arRst, rConfigDone, rReadBackDone, rPLL_LockClockGen_Loc)  
    begin
       if (arRst = '1') then
           rConfigADCEnable_Loc <= '0';
       elsif (rising_edge(RefClk)) then
           if (rPLL_LockClockGen_Loc = '1' and rConfigDone = '1' and kCDCE_SimulationConfig = true) then
               rConfigADCEnable_Loc <= '1';
           elsif (rPLL_LockClockGen_Loc = '1' and rConfigDone = '1' and rReadBackDone = '1') then
               rConfigADCEnable_Loc <= '1';
           else
               rConfigADCEnable_Loc <= '0';
           end if;
       end if;
    end process ConfigADC_Enable;
    
    --Registered Clock Generator configuration done succesfully signal output
    ConfigClockGenDone: process (RefClk, arRst, rConfigDone, rReadBackDone)  
    begin
       if (arRst = '1') then
           rInitConfigDoneClockGen <= '0';
       elsif (rising_edge(RefClk)) then
           if (rConfigDone = '1' and kCDCE_SimulationConfig = true) then
               rInitConfigDoneClockGen <= '1';
           elsif (rConfigDone = '1' and rReadBackDone = '1') then
               rInitConfigDoneClockGen <= '1';
           else
               rInitConfigDoneClockGen <= '0';
           end if;
       end if;
    end process ConfigClockGenDone;

    -- ROM/RAM sync output
    RegisteredOutput: process (RefClk, arRst)
    begin
        if (arRst = '1') then
            rI2C_DataIn <= (others => '0');
            rConfigDone <= '0';
            rRstCmdCnt <= '0';
            rReadBackErr <= '0';
            rReadBackDone <= '0';
            rPDNout_n <= '0';
        elsif Rising_Edge(RefClk) then
            if(rState = stRegAddress_H) then
                rI2C_DataIn <= CDCE_I2C_Cmds(kFreqSel)(to_integer(rCmdCnt))(31 downto 24);--Register Address High
                rRstCmdCnt <= '1';
            elsif (rState = stRegAddress_L) then
                rI2C_DataIn <= CDCE_I2C_Cmds(kFreqSel)(to_integer(rCmdCnt))(23 downto 16);--Register Address Low
                rRstCmdCnt <= '1';
            elsif (rState = stRegData_H) then
                rI2C_DataIn <= CDCE_I2C_Cmds(kFreqSel)(to_integer(rCmdCnt))(15 downto 8);--Register Data High
                rRstCmdCnt <= '1';
            elsif (rState = stRegData_L) then
                rI2C_DataIn <= CDCE_I2C_Cmds(kFreqSel)(to_integer(rCmdCnt))(7 downto 0);--Register Data Low
                rRstCmdCnt <= '1';
            elsif (rState = StCheckCmdCnt) then
                rRstCmdCnt <= '1';
                if (kCDCE_SimulationConfig = true) then
                    if (rCmdCnt = kCDCE_SimulationCmdTotal) then
                        rConfigDone <= '1';
                        rRstCmdCnt <= '0';
                    end if;
                elsif (rCmdCnt = kCmdTotal) then
                    rConfigDone <= '1';
                    rRstCmdCnt <= '0';
                else
                    rRstCmdCnt <= '1';
                    rConfigDone <= '0';
                end if;
            elsif (rState = stIdle) then
                rReadBackErr <= '0';
                rRstCmdCnt <= '0';
                rPDNout_n <= '1';
            elsif (rState = stReadBackAddress_H) then
                rI2C_DataIn <= CDCE_I2C_Cmds(kFreqSel)(kReadBackInt)(31 downto 24);--Register Address High
            elsif (rState = stReadBackAddress_L) then
                rI2C_DataIn <= CDCE_I2C_Cmds(kFreqSel)(kReadBackInt)(23 downto 16);--Register Address Low
            elsif (rState = stReadBackData_H) then
                if (rI2C_Done = '1' and rI2C_Error = '0') then
                    if CDCE_I2C_Cmds(kFreqSel)(kReadBackInt)(15 downto 8) /= (rI2C_DataOut and CDCE_I2C_Masks(kReadBackInt)(15 downto 8)) then
                        rReadBackErr <= '1';
                    end if;
                end if;
            elsif (rState = stReadBackData_L) then
                if (rI2C_Done = '1' and rI2C_Error = '0') then
                    if CDCE_I2C_Cmds(kFreqSel)(kReadBackInt)(7 downto 0) /= (rI2C_DataOut and CDCE_I2C_Masks(kReadBackInt)(7 downto 0)) then
                        rReadBackErr <= '1';
                    end if;
                end if;
            elsif (rState = stCheckReadBackError) then
                if (rReadBackErr = '1') then
                    rConfigDone <= '0';
                    rReadBackDone <= '0';
                else
                    rReadBackDone <= '1';
                end if;
            end if;
        end if;
    end process RegisteredOutput;
    
    -- Counter used to track the number of successfully sent commands.    
    ProcCmdCounter: process (RefClk, arRst)
    begin
        if (arRst = '1') then
            rCmdCnt <= (others => '0');
        elsif (rising_edge(RefClk)) then
            if (rRstCmdCnt = '0') then
                rCmdCnt <= (others => '0');
            elsif (rIncCmdCnt = '1') then
                rCmdCnt <= rCmdCnt + 1;
            end if;
        end if;
    end process;

    -- State machine synchronous process.
    ProcSyncFsm: process (RefClk, arRst)
    begin
       if (arRst = '1') then
          rState <= stIdle;
       elsif (rising_edge(RefClk)) then
          rState <= rNState; 
       end if;
    end process;

    --MOORE State-Machine - Outputs based on state only
    rI2C_Stb <= '1' when (rState = stRegAddress_H or rState = stRegAddress_L or rState = stRegData_H or rState = stRegData_L) else 
                '1' when (rState = stReadBackAddress_H or rState = stReadBackAddress_L or rState = stReadBackData_H or rState = stReadBackData_L) else
                '0';
    rI2C_Msg <= '1' when (rState = stRegAddress_H or rState = stReadBackAddress_H) else 
                '1' when (rState = stReadBackData_H) else
                '0';
    rI2C_Stp <= '1' when (rState = stRegAddress_H or rState = stReadBackAddress_H) else
                '0';
    rI2C_Address <= (kCDCEI2C_Addr(7 downto 1) & '1') when (rState = stReadBackData_H or rState = stReadBackData_L) else kCDCEI2C_Addr;
    --MEALY State-Machine
    rIncCmdCnt <= '1' when (rState = stCheckConfigDone and rConfigDone = '0') else
                  '0';
    aREFSEL_TriStateCtl <= '1' when (kCDCEI2C_Addr = x"CE") else '0';
    aHW_SW_CTRL_TriStateCtl <= '1' when (kCDCEI2C_Addr = x"CE") else '0';

    NextStateDecode: process (rState, rI2C_Done, rI2C_Error, rConfigDone, rReadBackDone, rReadBackErr)
    begin
        --declare default state for next_state to avoid latches
        rNState <= rState;
        case (rState) is
            when stIdle =>
                if (rConfigDone = '0') then
                    rNState <= stRegAddress_H;
                elsif (kCDCE_SimulationConfig = false) then
                    if (rReadBackDone = '0') then
                        rNState <= stReadBackAddress_H;
                    end if;
                end if;    

            when stRegAddress_H =>
                if (rI2C_Done = '1' and rI2C_Error = '0') then
                    rNState <= stRegAddress_L;
                elsif (rI2C_Error = '1') then
                    rNState <= stIdle;
                end if;

            when stRegAddress_L =>
                if (rI2C_Done = '1' and rI2C_Error = '0') then
                    rNState <= stRegData_H;
                elsif (rI2C_Error = '1') then
                    rNState <= stIdle;
                end if;

            when stRegData_H =>
                if (rI2C_Done = '1' and rI2C_Error = '0') then
                    rNState <= stRegData_L;
                elsif (rI2C_Error = '1') then
                    rNState <= stIdle;
                end if;

            when stRegData_L =>
                if (rI2C_Done = '1' and rI2C_Error = '0') then
                    rNState <= stCheckCmdCnt;
                elsif (rI2C_Error = '1') then
                    rNState <= stIdle;
                end if;

            when stCheckCmdCnt =>
                rNState <= stCheckConfigDone;
                
            when stCheckConfigDone =>
                if (rConfigDone = '1') then
                    rNState <= stIdle;
                else
                    rNState <= stRegAddress_H;
                end if;
                
            when stReadBackAddress_H =>
                if (rI2C_Done = '1' and rI2C_Error = '0') then
                    rNState <= stReadBackAddress_L;
                elsif (rI2C_Error = '1') then
                    rNState <= stIdle;
                end if;
                
            when stReadBackAddress_L =>
                if (rI2C_Done = '1' and rI2C_Error = '0') then
                    rNState <= stReadBackData_H;
                elsif (rI2C_Error = '1') then
                    rNState <= stIdle;
                end if;
                
            when stReadBackData_H =>
                if (rI2C_Done = '1' and rI2C_Error = '0') then
                    rNState <= stReadBackData_L;
                elsif (rI2C_Error = '1') then
                    rNState <= stIdle;
                end if;
                
            when stReadBackData_L =>
                if (rI2C_Done = '1' and rI2C_Error = '0') then
                    rNState <= stCheckReadBackError;
                elsif (rI2C_Error = '1') then
                    rNState <= stIdle;
                end if;
            
            when stCheckReadBackError =>
                if (rReadBackErr = '1') then
                    rNState <= stIdle;
                else     
                    rNState <= stCheckReadBackDone;
                end if;
                
            when stCheckReadBackDone =>
                if (rReadBackDone = '1') then
                    rNState <= stIdle;
                else     
                    rNState <= stReadBackAddress_H;
                end if;   
                    
            when others =>
                rNState <= stIdle;
        end case;
    end process NextStateDecode;

end Behavioral;