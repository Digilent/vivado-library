
-------------------------------------------------------------------------------
--
-- File: tb_TestTop_AllZmods.vhd
-- Author: Tudor Gherman, Robert Bocos
-- Original Project: Zmod ADC 1410 Low Level Controller
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
-- This test bench is used to instantiate the tb_TestTop test bench for all
-- supported ZmodADC variants.
--  
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.PkgZmodDigitizer.all;

entity tb_TestTop_AllZmods is

end tb_TestTop_AllZmods;

architecture Behavioral of tb_TestTop_AllZmods is

constant kADC_SamplingClkPeriod_122_88 : time := 8.138ns;
constant kADC_SamplingClkPeriod_50 : time := 20ns;
constant kADC_SamplingClkPeriod_80 : time := 12.500ns;
constant kADC_SamplingClkPeriod_100 : time := 10ns;
constant kADC_SamplingClkPeriod_110 : time := 9.090ns;
constant kADC_SamplingClkPeriod_120 : time := 8.333ns;
constant kADC_SamplingClkPeriod_125 : time := 8ns; 
constant kExtCmdInterfaceEn : boolean := true;
constant kCDCE_SimulationConfig : boolean := true;
constant kCDCE_SimulationCmdTotal : integer range 0 to kCDCE_RegNrZeroBased := 4;
constant kCDCEFreqSel_122_88 : integer range 0 to (kCDCE_FreqCfgsNr - 1) := 0;
constant kCDCEFreqSel_50 : integer range 0 to (kCDCE_FreqCfgsNr - 1) := 1;
constant kCDCEFreqSel_80 : integer range 0 to (kCDCE_FreqCfgsNr - 1) := 2;
constant kCDCEFreqSel_100 : integer range 0 to (kCDCE_FreqCfgsNr - 1) := 3;
constant kCDCEFreqSel_110 : integer range 0 to (kCDCE_FreqCfgsNr - 1) := 4;
constant kCDCEFreqSel_120 : integer range 0 to (kCDCE_FreqCfgsNr - 1) := 5;
constant kCDCEFreqSel_125 : integer range 0 to (kCDCE_FreqCfgsNr - 1) := 6;
constant kCDCEI2C_Addr : std_logic_vector(7 downto 0) := x"CE";   
     
begin

------------------------------------------------------------------------------------------
-- Top level test bench instantiated for all supported Zmod ADC variants
------------------------------------------------------------------------------------------ 

InstTbTestTop_ZmodSDR_122_88: entity work.tb_TestTop
   Generic Map(
      kZmodID => kZmodDigitizer1430_125,
      kADC_SamplingClkPeriod => kADC_SamplingClkPeriod_122_88,
      kADC_ClkDiv => 1, 
      kExtCmdInterfaceEn => kExtCmdInterfaceEn,
      kCDCEI2C_Addr => kCDCEI2C_Addr,
      kCDCE_SimulationConfig => kCDCE_SimulationConfig,
      kCDCE_SimulationCmdTotal => kCDCE_SimulationCmdTotal,
      kCDCEFreqSel => kCDCEFreqSel_122_88
   );
   
InstTbTestTop_ZmodSDR_50: entity work.tb_TestTop
   Generic Map(
      kZmodID => kZmodDigitizer1430_125,
      kADC_SamplingClkPeriod => kADC_SamplingClkPeriod_50,
      kADC_ClkDiv => 1, 
      kExtCmdInterfaceEn => kExtCmdInterfaceEn,
      kCDCEI2C_Addr => kCDCEI2C_Addr,
      kCDCE_SimulationConfig => kCDCE_SimulationConfig,
      kCDCE_SimulationCmdTotal => kCDCE_SimulationCmdTotal,
      kCDCEFreqSel => kCDCEFreqSel_50 
   );
   
InstTbTestTop_ZmodSDR_80: entity work.tb_TestTop
   Generic Map(
      kZmodID => kZmodDigitizer1430_125,
      kADC_SamplingClkPeriod => kADC_SamplingClkPeriod_80,
      kADC_ClkDiv => 1, 
      kExtCmdInterfaceEn => kExtCmdInterfaceEn,
      kCDCEI2C_Addr => kCDCEI2C_Addr,
      kCDCE_SimulationConfig => kCDCE_SimulationConfig,
      kCDCE_SimulationCmdTotal => kCDCE_SimulationCmdTotal,
      kCDCEFreqSel => kCDCEFreqSel_80 
   );         
   
InstTbTestTop_ZmodSDR_100: entity work.tb_TestTop
   Generic Map(
      kZmodID => kZmodDigitizer1430_125,
      kADC_SamplingClkPeriod => kADC_SamplingClkPeriod_100,
      kADC_ClkDiv => 1, 
      kExtCmdInterfaceEn => kExtCmdInterfaceEn,
      kCDCEI2C_Addr => kCDCEI2C_Addr,
      kCDCE_SimulationConfig => kCDCE_SimulationConfig,
      kCDCE_SimulationCmdTotal => kCDCE_SimulationCmdTotal,
      kCDCEFreqSel => kCDCEFreqSel_100 
   );
   
InstTbTestTop_ZmodSDR_110: entity work.tb_TestTop
   Generic Map(
      kZmodID => kZmodDigitizer1430_125,
      kADC_SamplingClkPeriod => kADC_SamplingClkPeriod_110,
      kADC_ClkDiv => 1,
      kExtCmdInterfaceEn => kExtCmdInterfaceEn,
      kCDCEI2C_Addr => kCDCEI2C_Addr,
      kCDCE_SimulationConfig => kCDCE_SimulationConfig,
      kCDCE_SimulationCmdTotal => kCDCE_SimulationCmdTotal,
      kCDCEFreqSel => kCDCEFreqSel_110 
   );
   
InstTbTestTop_ZmodSDR_120: entity work.tb_TestTop
   Generic Map(
      kZmodID => kZmodDigitizer1430_125,
      kADC_SamplingClkPeriod => kADC_SamplingClkPeriod_120,
      kADC_ClkDiv => 1, 
      kExtCmdInterfaceEn => kExtCmdInterfaceEn,
      kCDCEI2C_Addr => kCDCEI2C_Addr,
      kCDCE_SimulationConfig => kCDCE_SimulationConfig,
      kCDCE_SimulationCmdTotal => kCDCE_SimulationCmdTotal,
      kCDCEFreqSel => kCDCEFreqSel_120 
   );
   
InstTbTestTop_ZmodSDR_125: entity work.tb_TestTop
   Generic Map(
      kZmodID => kZmodDigitizer1430_125,
      kADC_SamplingClkPeriod => kADC_SamplingClkPeriod_125,
      kADC_ClkDiv => 1, 
      kExtCmdInterfaceEn => kExtCmdInterfaceEn,
      kCDCEI2C_Addr => kCDCEI2C_Addr,
      kCDCE_SimulationConfig => kCDCE_SimulationConfig,
      kCDCE_SimulationCmdTotal => kCDCE_SimulationCmdTotal,
      kCDCEFreqSel => kCDCEFreqSel_125 
   );         

end Behavioral;