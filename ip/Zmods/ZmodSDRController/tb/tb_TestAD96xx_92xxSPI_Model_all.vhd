
-------------------------------------------------------------------------------
--
-- File: tb_TestAD96xx_92xxSPI_Model_all.vhd
-- Author: Tudor Gherman
-- Original Project: ZmodScopeController
-- Date: 11 May 2020
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
-- Test bench used to instantiate the tb_TestAD96xx_92xxSPI_Model as multiple 
-- entities so that all supported errors are inserted in the SPI transactions 
-- initiated. This test bench is used to test if the tb_TestAD96xx_92xxSPI_Model  
-- correctly reports the deliberately inserted errors.
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_TestAD96xx_92xxSPI_Model_all is
   Generic (
      -- Parameter identifying the Zmod:
      -- 0 -> Zmod Scope 1410 - 105 (AD9648)       
      -- 1 -> Zmod Scope 1010 - 40 (AD9204)       
      -- 2 -> Zmod Scope 1010 - 125 (AD9608)       
      -- 3 -> Zmod Scope 1210 - 40 (AD9231)       
      -- 4 -> Zmod Scope 1210 - 125 (AD9628)       
      -- 5 -> Zmod Scope 1410 - 40 (AD9251)       
      -- 6 -> Zmod Scope 1410 - 125 (AD9648)
      kZmodID : integer range 0 to 6 := 0
   );
end tb_TestAD96xx_92xxSPI_Model_all;

architecture Behavioral of tb_TestAD96xx_92xxSPI_Model_all is

begin

-- Test the ADI_2WireSPI_Model for a write operation and no
-- error inserted.
InstWrNoErr: entity work.tb_TestAD96xx_92xxSPI_Model
Generic Map(
   kZmodID => kZmodID,
   kErrorType => 0,
   kCmdRdWr => '0',
   kCmdAddr => "0000000000101", 
   kCmdData => x"AA"
   ); 

-- Test the ADI_2WireSPI_Model for a read operation and no
-- error inserted.
InstRdNoErr: entity work.tb_TestAD96xx_92xxSPI_Model
Generic Map(
   kZmodID => kZmodID,
   kErrorType => 0,
   kCmdRdWr => '1',
   kCmdAddr => "0000000000101", 
   kCmdData => x"AA"
   );

-- Test the ADI_2WireSPI_Model for a write operation with a  
-- sSDIO to sSPI_Clk Setup Time error inserted for the SPI transaction.
InstWrData2ClkSetupErr: entity work.tb_TestAD96xx_92xxSPI_Model
Generic Map(
   kZmodID => kZmodID,
   kErrorType => 1,
   kCmdRdWr => '0',
   kCmdAddr => "0000000000101", 
   kCmdData => x"AA"
   );   

-- Test the ADI_2WireSPI_Model for a write operation with a  
-- CS to sSPI_Clk and a data to sSPI_Clk setup time  error inserted 
-- for the SPI transaction.
InstWrCs2ClkSetupErr: entity work.tb_TestAD96xx_92xxSPI_Model
Generic Map(
   kZmodID => kZmodID,
   kErrorType => 2,
   kCmdRdWr => '0',
   kCmdAddr => "0000000000101", 
   kCmdData => x"AA"
   );

-- Test the ADI_2WireSPI_Model for a write operation with a  
-- sSDIO to sSPI_Clk hold time error inserted for the SPI transaction.
InstWrData2ClkHoldErr: entity work.tb_TestAD96xx_92xxSPI_Model
Generic Map(
   kZmodID => kZmodID,
   kErrorType => 3,
   kCmdRdWr => '0',
   kCmdAddr => "0000000000101", 
   kCmdData => x"AA"
   );  

-- Test the ADI_2WireSPI_Model for a write operation with a  
-- sCS to sSPI_Clk hold time error inserted for the SPI transaction.
InstWrCs2ClkHoldErr: entity work.tb_TestAD96xx_92xxSPI_Model
Generic Map(
   kZmodID => kZmodID,
   kErrorType => 4,
   kCmdRdWr => '0',
   kCmdAddr => "0000000000101", 
   kCmdData => x"AA"
   );

-- Test the ADI_2WireSPI_Model for a write operation with a  
-- pulse width errors and a SPI clock period error inserted
-- for the SPI transaction.
InstSclkPulsePeriodErr : entity work.tb_TestAD96xx_92xxSPI_Model
Generic Map(
   kZmodID => kZmodID,
   kErrorType => 5,
   kCmdRdWr => '0',
   kCmdAddr => "0000000000101", 
   kCmdData => x"AA"
   ); 

-- Test the ADI_2WireSPI_Model for a write operation with an  
-- extra address bit error inserted for the SPI transaction.
InstNoBitErr : entity work.tb_TestAD96xx_92xxSPI_Model
Generic Map(
   kZmodID => kZmodID,
   kErrorType => 6,
   kCmdRdWr => '0',
   kCmdAddr => "0000000000101", 
   kCmdData => x"AA"
   );
               
end Behavioral;
