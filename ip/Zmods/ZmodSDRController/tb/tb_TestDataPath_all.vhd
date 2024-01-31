
-------------------------------------------------------------------------------
--
-- File: tb_TestDataPath_all.vhd
-- Author: Tudor Gherman
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
-- This test bench is used to test the DataPath & ADC_Calibration modules
-- with static/dynamic calibration and in normal operation/test mode
--  
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_TestDataPath_all is
--  Port ( );
end tb_TestDataPath_all;

architecture Behavioral of tb_TestDataPath_all is

constant kADC_Width : integer range 10 to 16 := 14; 

begin

-- Test the DataPath & ADC_Calibration modules with static calibration and in test mode.
InstDataPathStaticCalibTestMode: entity work.tb_TestDataPathCalib
   Generic Map(
      kADC_Width => kADC_Width
   );
      
end Behavioral;
