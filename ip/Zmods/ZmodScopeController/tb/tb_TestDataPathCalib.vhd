
-------------------------------------------------------------------------------
--
-- File: tb_TestDataPathCalib.vhd
-- Author: Tudor Gherman
-- Original Project: ZmodScopeController
-- Date: 11 Dec. 2020
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
-- This test bench instantiates the DataPath and ADC_Calibration modules of the
-- ZmodScopeController. A ramp signal is used to simulate the ADC data
-- and a data checker compares the output of the DataPath module against the 
-- expected data (generated by CalibDataReference) and generates an error 
-- message if a mismatch occurs.
--  
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.PkgZmodADC.all;

entity tb_TestDataPathCalib is
   Generic (
      -- ADC number of bits
      kADC_Width : integer range 10 to 16 := 14;
      -- Sampling Clock Period in ps; 
      kSamplingPeriod : real range 8.0 to 100.0:= 10.0;
      -- kSimTestMode generic allows the test bench to instantiate the
      -- ADC_Calibration modules to be instantiated either in test mode
      -- or in normal operation.
      kSimTestMode : std_logic := '0';
      -- ADC dynamic/static calibration 
      kExtCalibEn : boolean := false;
      -- Channel1 low gain multiplicative (gain) compensation coefficient parameter
      kCh1LgMultCoefStatic : std_logic_vector (17 downto 0) := "010001101010110010";
      -- Channel1 low gain additive (offset) compensation coefficient parameter 
      kCh1LgAddCoefStatic : std_logic_vector (17 downto 0) := "111111101111010101";
      -- Channel1 high gain multiplicative (gain) compensation coefficient parameter
      kCh1HgMultCoefStatic : std_logic_vector (17 downto 0) := "010001101010110010"; 
      -- Channel1 high gain additive (offset) compensation coefficient parameter 
      kCh1HgAddCoefStatic : std_logic_vector (17 downto 0) := "111111101111010101"; 
      -- Channel2 low gain multiplicative (gain) compensation coefficient parameter
      kCh2LgMultCoefStatic : std_logic_vector (17 downto 0) := "010001101010110010";
      -- Channel2 low gain additive (offset) compensation coefficient parameter  
      kCh2LgAddCoefStatic : std_logic_vector (17 downto 0) := "111111101111010101"; 
      -- Channel2 high gain multiplicative (gain) compensation coefficient parameter
      kCh2HgMultCoefStatic : std_logic_vector (17 downto 0) := "010000000000000000"; 
      -- Channel2 high gain additive (offset) compensation coefficient parameter 
      kCh2HgAddCoefStatic : std_logic_vector (17 downto 0) := "111111101111010101" 
   );
end tb_TestDataPathCalib;

architecture Behavioral of tb_TestDataPathCalib is
 
constant kNumClockCycles : integer := 3*(2**14); 

signal ADC_SamplingClk : std_logic := '0';
signal acRst_n : std_logic := '0';
signal ZmodDcoClk, ZmodDcoClkDly : std_logic := '0';
signal dZmodADC_Data, dZmodADC_DataDly : std_logic_vector(kADC_Width-1 downto 0) := (others => '0');
signal ZmodDataSel : std_logic_vector (2 downto 0);
signal dZmodADC_DataCnt : unsigned (kADC_Width-1 downto 0);
signal cDataValid, cDataCalibValid : std_logic;
signal cChannelA, cChannelB : std_logic_vector(kADC_Width-1 downto 0);
signal cChannel1_Test, cChannel2_Test : std_logic_vector(kADC_Width-1 downto 0);
signal cChA_TestDly, cChB_TestDly : std_logic_vector(kADC_Width-1 downto 0);
signal cDataOverflow : std_logic;
signal cTestMode : std_logic;
signal cCh1Calib, cCh2Calib : std_logic_vector(15 downto 0);
signal cCh1OutInt, cCh2OutInt : integer;
signal cCh1TestInt, cCh2TestInt : integer;
signal cCh1Diff, cCh2Diff : integer;

signal cExtCh1LgMultCoef : std_logic_vector(17 downto 0);
signal cExtCh1LgAddCoef : std_logic_vector(17 downto 0);
signal cExtCh1HgMultCoef : std_logic_vector(17 downto 0);
signal cExtCh1HgAddCoef : std_logic_vector(17 downto 0);
signal cExtCh2LgMultCoef : std_logic_vector(17 downto 0);
signal cExtCh2LgAddCoef : std_logic_vector(17 downto 0);
signal cExtCh2HgMultCoef : std_logic_vector(17 downto 0);
signal cExtCh2HgAddCoef : std_logic_vector(17 downto 0);
signal cCh1GainState : std_logic;
signal cCh2GainState : std_logic;
signal cInitDone, dInitDone : std_logic := '0';

signal dDataGenCntEn, dDataGenRst_n : std_logic;
signal dEnableAcquisition : std_logic;

constant kADC_SamplingClkPeriod : time := 10ns;
constant kVal1 : std_logic_vector (15 downto 0) := x"AAAA";
constant kVal2 : std_logic_vector (15 downto 0) := x"5555";
constant kValMin : std_logic_vector (15 downto 0) := x"8000"; 
constant kValMax : std_logic_vector (15 downto 0) := x"7FFF";
-- Calibration constants used to test the dynamic calibration behavior
constant kCh1LgMultCoefDynamic : std_logic_vector (17 downto 0) := "010000110101100101";
constant kCh1LgAddCoefDynamic : std_logic_vector (17 downto 0) := "111111101111011011";
constant kCh1HgMultCoefDynamic : std_logic_vector (17 downto 0) := "010001101000010001";  
constant kCh1HgAddCoefDynamic : std_logic_vector (17 downto 0) := "111111101110111000";  
constant kCh2LgMultCoefDynamic : std_logic_vector (17 downto 0) := "010000101001111010";  
constant kCh2LgAddCoefDynamic : std_logic_vector (17 downto 0) := "000000000000010000"; 
constant kCh2HgMultCoefDynamic : std_logic_vector (17 downto 0) := "010001011010101111"; 
constant kCh2HgAddCoefDynamic : std_logic_vector (17 downto 0) := "000000001000000111";   
         
begin
                 
InstDataPath : entity work.DataPath
Generic Map(
   kSamplingPeriod => kSamplingPeriod,
   kADC_Width => kADC_Width
)  
Port Map( 
    ADC_SamplingClk => ADC_SamplingClk,
    acRst_n => acRst_n,
    DcoClkIn => ZmodDcoClk,
    DcoClkOut => open,
	dEnableAcquisition => dEnableAcquisition,
    dADC_Data => dZmodADC_DataDly,
    cChannelA => cChannelA,
    cChannelB => cChannelB,
    cDataOutValid => cDataValid,
    cFIFO_RdEn => '1',
    dFIFO_WrRstBusy => open,
    dDataOverflow => cDataOverflow,
    cInitDone => cInitDone,
    dInitDone => dInitDone
);

InstDataPathDlyCh1 : entity work.DataPathLatency
    Generic Map (
        kNumFIFO_Stages => 2, 
        kDataWidth => kADC_Width
    )
    Port Map(
        ADC_SamplingClk => ADC_SamplingClk,
        ZmodDcoClk => ZmodDcoClkDly,
        dDataIn => dZmodADC_DataDly,
        cChA_DataOut => cChA_TestDly, 		
        cChB_DataOut => cChB_TestDly);
                
InstCalibDataRefCh1 : entity work.CalibDataReference 
    Generic Map (
        kWidth => kADC_Width,
        kExtCalibEn => kExtCalibEn, 
        kLgMultCoefStatic => kCh1LgMultCoefStatic,
        kLgAddCoefStatic  => kCh1LgAddCoefStatic,
        kHgMultCoefStatic => kCh1HgMultCoefStatic,
        kHgAddCoefStatic  => kCh1HgAddCoefStatic,
        kInvert => true,
        kLatency => 2,
        kTestLatency => 1 
    )
    Port Map(
        SamplingClk => ADC_SamplingClk,
        cTestMode => cTestMode, 
        cChIn => cChannelA,
        cChOut => cChannel1_Test,
        cExtLgMultCoef => cExtCh1LgMultCoef,
        cExtLgAddCoef  => cExtCh1LgAddCoef,
        cExtHgMultCoef => cExtCh1HgMultCoef,
        cExtHgAddCoef  => cExtCh1HgAddCoef,
        cGainState => cCh1GainState);  

InstCalibDataRefCh2 : entity work.CalibDataReference 
    Generic Map (
        kWidth => kADC_Width,
        kExtCalibEn => kExtCalibEn, 
        kLgMultCoefStatic => kCh2LgMultCoefStatic,
        kLgAddCoefStatic  => kCh2LgAddCoefStatic,
        kHgMultCoefStatic => kCh2HgMultCoefStatic,
        kHgAddCoefStatic  => kCh2HgAddCoefStatic,
        kInvert => false,
        kLatency => 2,
        kTestLatency => 1  
    )
    Port Map(
        SamplingClk => ADC_SamplingClk,
        cTestMode => cTestMode,
        cChIn => cChannelB,
        cChOut => cChannel2_Test,
        cExtLgMultCoef => cExtCh2LgMultCoef,
        cExtLgAddCoef  => cExtCh2LgAddCoef,
        cExtHgMultCoef => cExtCh2HgMultCoef,
        cExtHgAddCoef  => cExtCh2HgAddCoef,
        cGainState => cCh2GainState);
                 
InstCh1ADC_Calibration : entity work.GainOffsetCalib 
    Generic Map(
        kWidth => kADC_Width,
        kExtCalibEn => kExtCalibEn,
        kInvert => true,
        kLgMultCoefStatic => kCh1LgMultCoefStatic,
        kLgAddCoefStatic  => kCh1LgAddCoefStatic,
        kHgMultCoefStatic => kCh1HgMultCoefStatic,
        kHgAddCoefStatic  => kCh1HgAddCoefStatic
    )
    Port Map
    (
        SamplingClk => ADC_SamplingClk,
        acRst_n => acRst_n,
        cTestMode => cTestMode,
        cExtLgMultCoef => cExtCh1LgMultCoef,
        cExtLgAddCoef  => cExtCh1LgAddCoef,
        cExtHgMultCoef => cExtCh1HgMultCoef,
        cExtHgAddCoef  => cExtCh1HgAddCoef,
        cGainState => cCh1GainState,
        cDataRaw => cChannelA,
        cDataInValid => cDataValid,
        cCalibDataOut => cCh1Calib,
        cDataCalibValid => cDataCalibValid
    );

InstCh2ADC_Calibration : entity work.GainOffsetCalib
    Generic Map(
        kWidth => kADC_Width,
        kExtCalibEn => kExtCalibEn,
        kInvert => false,
        kLgMultCoefStatic => kCh2LgMultCoefStatic,
        kLgAddCoefStatic  => kCh2LgAddCoefStatic,
        kHgMultCoefStatic => kCh2HgMultCoefStatic,
        kHgAddCoefStatic  => kCh2HgAddCoefStatic
    )
    Port Map
    (
        SamplingClk => ADC_SamplingClk,
        acRst_n => acRst_n,
        cTestMode => cTestMode,
        cExtLgMultCoef => cExtCh2LgMultCoef,
        cExtLgAddCoef  => cExtCh2LgAddCoef,
        cExtHgMultCoef => cExtCh2HgMultCoef,
        cExtHgAddCoef  => cExtCh2HgAddCoef,
        cGainState => cCh2GainState,
        cDataRaw => cChannelB,
        cDataInValid => '0', 
        cCalibDataOut => cCh2Calib,
        cDataCalibValid => open --both channels share the same valid signal
    );

cCh1OutInt <= to_integer(signed(cCh1Calib(15 downto 16-kADC_Width)));               
cCh2OutInt <= to_integer(signed(cCh2Calib(15 downto 16-kADC_Width))); 
cCh1TestInt <= to_integer(signed(cChannel1_Test));               
cCh2TestInt <= to_integer(signed(cChannel2_Test));
cCh1Diff <= cCh1OutInt - cCh1TestInt;
cCh2Diff <= cCh2OutInt - cCh2TestInt; 

-- Generate ADC Sampling Clock
Clock: process
begin
    for i in 0 to kNumClockCycles loop
        wait for kADC_SamplingClkPeriod/2;
        ADC_SamplingClk <= not ADC_SamplingClk;
        wait for kADC_SamplingClkPeriod/2;
        ADC_SamplingClk <= not ADC_SamplingClk;
    end loop;
    wait;
  end process; 

-- Generate ZmodDcoClk.
DcoClkProc: process
begin
    wait for kTdcoMax;
    for i in 0 to kNumClockCycles/2 loop
        wait for kADC_SamplingClkPeriod/2;
        ZmodDcoClk <= not ZmodDcoClk;
        wait for kADC_SamplingClkPeriod/2;
        ZmodDcoClk <= not ZmodDcoClk;
    end loop;
    
    -- Simulate DcoClk loss for 100 samples.
    -- 100 is a random choice, it has no particular meaning.
    wait for kADC_SamplingClkPeriod * 100;
    
        for i in 0 to (kNumClockCycles/2 - 100) loop
        wait for kADC_SamplingClkPeriod/2;
        ZmodDcoClk <= not ZmodDcoClk;
        wait for kADC_SamplingClkPeriod/2;
        ZmodDcoClk <= not ZmodDcoClk;
    end loop;
    wait;
  end process; 

ZmodDcoClkDly <= ZmodDcoClk after (kIDDR_ClockPhase/360.0)*kADC_SamplingClkPeriod;

-- Ramp signal generator
ProcDataGen: process (ZmodDcoClk)  
begin
   if ((acRst_n = '0') or (dDataGenRst_n = '0')) then
      dZmodADC_DataCnt <= (others => '0');
   elsif (falling_edge(ZmodDcoClk) or rising_edge(ZmodDcoClk)) then
      if (dDataGenCntEn = '1') then
         dZmodADC_DataCnt <= dZmodADC_DataCnt + 1;
      end if;     
   end if;
end process;

-- Mux that allows selecting (simulating )different patters 
-- on the ADC data interface.
ProcZmodDataMux: process (dZmodADC_DataCnt, ZmodDataSel)
begin
   case (ZmodDataSel) is
   when ("000") =>
      dZmodADC_Data <= kVal1(kADC_Width-1 downto 0);
   when ("001") =>
      dZmodADC_Data <= kVal2(kADC_Width-1 downto 0);
   when ("010") =>   
      dZmodADC_Data <= std_logic_vector(dZmodADC_DataCnt);
   when ("011") =>
      dZmodADC_Data <= kValMin(15 downto 16-kADC_Width);
   when ("100") =>
      dZmodADC_Data <= kValMax(15 downto 16-kADC_Width);
   when others =>
      dZmodADC_Data <= std_logic_vector(dZmodADC_DataCnt);
   end case;
end process;
-- Delay the simulated ADC data (dZmodADC_Data) by kADC_SamplingClkPeriod/4
-- so that the waveforms are easier to follow in simulation.
dZmodADC_DataDly <= dZmodADC_Data after (kADC_SamplingClkPeriod/4);
    
ProcSamplingDomainStimuli: process
begin
   acRst_n <= '0';
   cTestMode <= kSimTestMode;
   cCh1GainState <= '1';
   cCh2GainState <= '1';
   cInitDone <= '0';
   cExtCh1LgMultCoef <= kCh1LgMultCoefDynamic;
   cExtCh1LgAddCoef <= kCh1LgAddCoefDynamic;
   cExtCh1HgMultCoef <= kCh1HgMultCoefDynamic; 
   cExtCh1HgAddCoef <= kCh1HgAddCoefDynamic;
   cExtCh2LgMultCoef <= kCh2LgMultCoefDynamic;
   cExtCh2LgAddCoef <= kCh2LgAddCoefDynamic;
   cExtCh2HgMultCoef <= kCh2HgMultCoefDynamic; 
   cExtCh2HgAddCoef <= kCh2HgAddCoefDynamic;
   dEnableAcquisition <= '0';
   
   -- Keep the acRst_n reset asserted for 10 clock cycles.
   wait for 10 * kADC_SamplingClkPeriod;
   -- Modify signals on the falling edge of ADC_SamplingClk.
   wait until falling_edge(ADC_SamplingClk);
   
   acRst_n <= '1';
   cInitDone <= '1';
   
   -- Wait for 100 clock cycles before enabling actual sample acquisition from the ADC
   -- (this number has no specific relevance).
   wait for 100 * kADC_SamplingClkPeriod;
   dEnableAcquisition <= '1';
   
   -- Optionally the cInitDone signal can be disabled to observe the system behavior.
   -- No sort of automatic testing is carried out for this optional test.
   -- The effect of ADC or relay initialization on the valid signal is tested 
   -- at the top level test bench (tb_TestTop) level. 
   wait until dInitDone = '0';
   wait until falling_edge(ADC_SamplingClk);
   cInitDone <= '0';
   -- Keep dInitDone low for 500 clock cycles (this number has no specific relevance).
   wait for (500) * kADC_SamplingClkPeriod;
   cInitDone <= '1';
    
   wait;
end process;

ProcDcoDomainStimuli: process
begin
   dInitDone <= '0';
   dDataGenRst_n <= '0';
   dDataGenCntEn <= '0';
   ZmodDataSel <= "000"; 
   -- Keep the acRst_n reset asserted for 10 clock cycles.
   wait for 10 * kADC_SamplingClkPeriod;
   -- Modify signals on the falling edge of ZmodDcoClk.
   wait until falling_edge(ZmodDcoClk);
   dInitDone <= '1';
   dDataGenRst_n <= '1';
   dDataGenCntEn <= '1';
   ZmodDataSel <= "000";
   -- A counter will be used to generate the input test data for the DataPath module.
   -- However, since a 1LSB error is tolerated so that the CalibDataReference can work 
   -- with real (floating point) values, synchronization problems may not be detected.
   -- For this reason, at the beginning of the test 2 values that differ by more than
   -- 1 LSB will be generated. By this means, the test assures that the DataPath and
   -- ADC_Calibration outputs are correctly synchronized with CalibDataReference.
   
   -- To make sure that the synchronization FIFO comes out of reset when the various 
   -- patterns are applied to the input, the process will wait for the data valid 
   -- signal to be asserted.
   
   wait until cDataValid = '1';
   wait until rising_edge(ZmodDcoClk);
   ZmodDataSel <= "000";
   wait until rising_edge(ZmodDcoClk);
   ZmodDataSel <= "001";
   wait until rising_edge(ZmodDcoClk);
   -- Test IP response for minimum negative and maximum positive input
   -- The value will be hold for 100 clock cycles (no specific relevance
   -- for the time this value is held constant).
   ZmodDataSel <= "011";
   wait for  kADC_SamplingClkPeriod*100;  
   wait until rising_edge(ZmodDcoClk);
   ZmodDataSel <= "100";
   wait for  kADC_SamplingClkPeriod*100;   
   wait until rising_edge(ZmodDcoClk);
   ZmodDataSel <= "010";
   
   -- Optionally the dInitDone signal can be disabled to observe the system behavior.
   -- No sort of automatic testing is carried out for this optional test.
   -- The effect of ADC or relay initialization on the valid signal is tested 
   -- at the top level test bench (tb_TestTop) level.
   
   -- Modify signals on the falling edge of ZmodDcoClk.
   wait until falling_edge(ZmodDcoClk);  
   dInitDone <= '0';
   -- Keep dInitDone low for 500 clock cycles (this number has no specific relevance).
   wait for (500) * kADC_SamplingClkPeriod;
   dInitDone <= '1';
 
   wait;
end process;

-- Check the calibration module (ADC_Calbration) outputs against the expected values.

ProcCh1CheckCalibData: process
begin
   wait until cCh1TestInt'event or cCh1OutInt'event;
   -- cCh1Diff is generated on the rising edge of ADC_SamplingClk
   -- and checked on the negative edge of ADC_SamplingClk.
   wait until falling_edge(ADC_SamplingClk);
   if (cDataCalibValid = '1') then
      assert (abs(cCh1Diff) < 2)
      report "Calibration error: mismatch between expected data and actual data" & LF & HT & HT &
             "Expected: " & integer'image(to_integer(signed(cChannel1_Test))) & LF & HT & HT &
             "Actual: " & integer'image(cCh1OutInt) & LF & HT & HT &
             "Difference: " & integer'image(cCh1Diff)
      severity ERROR;
   end if;
end process;

ProcCh2CheckCalibData: process
begin
   wait until cCh2TestInt'event or cCh2OutInt'event;
   -- cCh2Diff is generated on the rising edge of ADC_SamplingClk
   -- and checked on the negative edge of ADC_SamplingClk.
   wait until falling_edge(ADC_SamplingClk);
   if (cDataCalibValid = '1') then
      assert (abs(cCh2Diff) < 2)
      report "Calibration error: mismatch between expected data and actual data" & LF & HT & HT &
             "Expected: " & integer'image(to_integer(signed(cChannel2_Test))) & LF & HT & HT &
             "Actual: " & integer'image(cCh2OutInt) & LF & HT & HT &
             "Difference: " & integer'image(cCh2Diff)
      severity ERROR;
   end if;
end process;

-- Test DataPathLatency module. The data generated by the DataPath module
-- is expected to be identical to the data generated by the DataPathLatency
-- module. This test is used to validate the DataPathLatency used in the top 
-- level test bench.

ProcDataPathDlyTest: process
begin
   wait until cChannelA'event or cChannelB'event or cChB_TestDly'event or cChA_TestDly'event;
   if (cDataValid = '1') then
      wait until falling_edge(ADC_SamplingClk);
      assert ((cChannelA = cChA_TestDly) and (cChannelB = cChB_TestDly))
      report "DataPathLatency synchronization error" & LF & HT & HT
      severity ERROR;
   end if; 
end process;

end Behavioral;
