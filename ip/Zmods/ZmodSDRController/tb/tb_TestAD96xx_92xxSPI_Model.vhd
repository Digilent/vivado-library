
-------------------------------------------------------------------------------
--
-- File: tb_TestAD96xx_92xxSPI_Model.vhd
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
-- Test bench used to validate the AD96xx_92xxSPI_Model simulation model. 
-- Errors encoded by the kErrorType generic are deliberately inserted in subsequent 
-- SPI transactions.
-- This test bench will be instantiated as multiple entities in the 
-- tb_TestAD96xx_92xxSPI_Model_all to cover all supported error types. 
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.PkgZmodDigitizer.all;

entity tb_TestAD96xx_92xxSPI_Model is
   Generic (
      -- Parameter identifying the Zmod:
      -- 0 -> Zmod Scope 1410 - 105 (AD9648)       
      -- 1 -> Zmod Scope 1010 - 40 (AD9204)       
      -- 2 -> Zmod Scope 1010 - 125 (AD9608)       
      -- 3 -> Zmod Scope 1210 - 40 (AD9231)       
      -- 4 -> Zmod Scope 1210 - 125 (AD9628)       
      -- 5 -> Zmod Scope 1410 - 40 (AD9251)       
      -- 6 -> Zmod Scope 1410 - 125 (AD9648)
      kZmodID : integer range 0 to 6 := 0;
      -- kErrorType encodes the error introduced by the test bench:
      -- 0-No error.
      -- 1-Insert sSDIO to sSPI_Clk Setup Time error for Cmd[2] and Data[2] bits of kSclkHigh.
      -- 2-Insert CS to sSPI_Clk and data to sSPI_Clk (on Cmd[15])  setup time error of 1ns.
      -- 3-Insert sSDIO to sSPI_Clk hold time error of 1ns for command bit 2.
      -- 4-Insert sCS to sSPI_Clk hold time error of 1ns; sSPI_Clk pulse width errors
      --   and hold time error also inserted on Data[0].
      -- 5-Insert pulse width errors (0.5ns) and TestSPI_Clk period errors Cmd[2] and Data[2].
      -- 6-Send extra address bit (25 bit transfer). 
      kErrorType : integer := 1;
      --kCmdRdWr selects between read and write operations: '1' -> read; '0' -> write.
      kCmdRdWr : std_logic := '0';
      -- Command address; Error reporting depends on the kCmdAddr's value!
      -- Transition on the error affected bits is necessary!
      kCmdAddr : std_logic_vector (12 downto 0) := "0000000000101";
      -- Command address; Error reporting depends on the kCmdAddr's value!
      kCmdData    : std_logic_vector (7 downto 0) := x"AA";
      -- The number of data bits for the data phase of the transaction: 
      -- only 8 data bits currently supported.
      kNoDataBits : integer := 8;
      -- The number of bits of the command phase of the SPI transaction.
      kNoCommandBits : integer := 16
   );
end tb_TestAD96xx_92xxSPI_Model;

architecture Behavioral of tb_TestAD96xx_92xxSPI_Model is

signal asRst_n : std_logic := '0';
signal TestSPI_Clk, tSDIO : std_logic := 'X';
signal tCS : std_logic := '1';
signal tCommand : std_logic_vector(15 downto 0);
signal tData : std_logic_vector(7 downto 0);
signal SysClk100 : std_logic := '1';

begin

  Clock: process
  begin
    for i in 0 to 1000 loop
        wait for kSysClkPeriod/2;
        SysClk100 <= not SysClk100;
        wait for kSysClkPeriod/2;
        SysClk100 <= not SysClk100;
    end loop;
    wait;
  end process;
      
AD96xx_AD92xx_inst: entity work.AD96xx_92xxSPI_Model
   Generic Map(
      kZmodID => kZmodID,
      kDataWidth => kSPI_DataWidth,
      kCommandWidth => kSPI_CommandWidth
   )
   Port Map(
      SysClk100 => SysClk100,
      asRst_n => asRst_n,
      InsertError => '0', 
      sSPI_Clk => TestSPI_Clk,
      sSDIO => tSDIO,
      sCS => tCS
   );   
  
  
Main: process
begin
   
   -- Assert the reset signal
   asRst_n <= '0';
   -- Hold the reset condition for 10 clock cycles
   -- (one clock cycle is sufficient, however 10 clock cycles makes
   -- it easier to visualize the reset condition in simulation).
   wait for kSysClkPeriod*10;
   asRst_n <= '1';
         
   if (kErrorType = 0) then
      if (kCmdRdWr = '1') then  
         -- Read operation: SPI read register correct sequence.
         TestSPI_Clk <= '0';
         tSDIO <= '0';
         tCS <= '1';
         tCommand <= kCmdRdWr & "00" & kCmdAddr;
         tData <= kCmdData;
         wait for kSysClkPeriod;
         tCS <= '0';
         tSDIO <= tCommand(15);
         wait for ktS;
         for i in (kNoCommandBits - 2) downto 0 loop
            TestSPI_Clk <= '1';
            wait for kSclkHigh*3;
            TestSPI_Clk <= '0';
            tSDIO <= tCommand(i);
            wait for kSclkLow*3;
         end loop;
         for i in (kNoDataBits) downto 0 loop
            TestSPI_Clk <= '1';
            wait for kSclkHigh*3;
            TestSPI_Clk <= '0';
            tSDIO <= 'Z';
            wait for kSclkLow*3;
         end loop;
         wait for ktH;
         tSDIO <= '0';
         tCS <= '1';  
      else 
         -- Write operation: SPI read register correct sequence.     
         tCommand <= kCmdRdWr & "00" & kCmdAddr;
         tData <= kCmdData;
         TestSPI_Clk <= '0';
         tSDIO <= '0';
         tCS <= '1';
         wait for kSysClkPeriod;
         tCS <= '0';
         tSDIO <= tCommand(15);
         wait for ktS;
         for i in (kNoCommandBits - 2) downto 0 loop
            TestSPI_Clk <= '1';
            wait for kSclkHigh*3;
            TestSPI_Clk <= '0';
            tSDIO <= tCommand(i);
            wait for kSclkLow*3;
         end loop;
         for i in (kNoDataBits) downto 0 loop
            TestSPI_Clk <= '1';
            wait for kSclkHigh*3;
            TestSPI_Clk <= '0';
            if (i > 0) then
               tSDIO <= tData(i-1);
            else
               tSDIO <= 'Z';
            end if;
            wait for kSclkLow*3;
         end loop;
         wait for ktH;
         tSDIO <= '0';
         tCS <= '1';
      end if;
      
   elsif (kErrorType = 1) then
      if (kCmdRdWr = '1') then  
         -- Read operation not currently supported for this error type.
         TestSPI_Clk <= '0';
         tCS <= '1';
         tSDIO <= '0';
      else 
         -- Write operation: Insert tSDIO to TestSPI_Clk Setup Time error for Cmd[2] 
         -- and Data[2] bits of kSclkHigh.
         tCommand <= kCmdRdWr & "00" & kCmdAddr;
         tData <= kCmdData;
         TestSPI_Clk <= '0';
         tSDIO <= '0';
         tCS <= '1';
         wait for kSysClkPeriod;
         tCS <= '0';
         tSDIO <= tCommand(15);
         wait for ktS;
         for i in (kNoCommandBits - 2) downto 0 loop
            TestSPI_Clk <= '1';
            if (i = 1) then
               report "Insert sSDIO to sSPI_Clk setup time error on Cmd[2]" & LF & HT & HT;
               tSDIO <= tCommand(i+1);
            end if;
            wait for kSclkHigh*3;
            TestSPI_Clk <= '0';
            if (i /= 2) then
               tSDIO <= tCommand(i);
            end if;
            wait for kSclkLow*3;
         end loop;
         for i in (kNoDataBits) downto 0 loop
            TestSPI_Clk <= '1';
            if (i = 2) then
               report "Insert sSDIO to sSPI_Clk setup time error on Data[2]" & LF & HT & HT;
               tSDIO <= tData(i);
            end if;
            wait for kSclkHigh*3;
            TestSPI_Clk <= '0';
            if (i > 0) then
               if (i /= 3) then
                  tSDIO <= tData(i-1);
               end if;
            else
               tSDIO <= 'Z';
            end if;
            wait for kSclkLow*3;
         end loop;
         wait for ktH;
         tSDIO <= '0';
         tCS <= '1';
      end if;
          
   elsif (kErrorType = 2) then
      if (kCmdRdWr = '1') then  
         -- Read operation not currently supported for this error type.
         TestSPI_Clk <= '0';
         tCS <= '1';
         tSDIO <= '0';
      else 
         -- Write operation: Insert tCS to TestSPI_Clk and tSDIO to TestSPI_Clk 
         -- (on Cmd[15])  setup time error of 1ns.
         tCommand <= kCmdRdWr & "00" & kCmdAddr;
         tData <= kCmdData;
         TestSPI_Clk <= '0';
         tSDIO <= '0';
         tCS <= '1';
         wait for kSysClkPeriod;
         tCS <= '0';
         tSDIO <= tCommand(15);
         wait for (ktS - 1 ns);
         report "Insert sCS and sSDIO (Cmd[15]) to sSPI_Clk setup time error" & LF & HT & HT;
         for i in (kNoCommandBits - 2) downto 0 loop
            TestSPI_Clk <= '1';
            wait for kSclkHigh*3;
            TestSPI_Clk <= '0';
            tSDIO <= tCommand(i);
            wait for kSclkLow*3;
         end loop;
         for i in (kNoDataBits) downto 0 loop
            TestSPI_Clk <= '1';
            wait for kSclkHigh*3;
            TestSPI_Clk <= '0';
            if (i > 0) then
               tSDIO <= tData(i-1);
            else
               tSDIO <= 'Z';
            end if;
            wait for kSclkLow*3;
         end loop;
         wait for ktH;
         tSDIO <= '0';
         tCS <= '1';   
      end if;
      
   elsif (kErrorType = 3) then
      if (kCmdRdWr = '1') then  
         -- Read operation not currently supported for this error type.
         TestSPI_Clk <= '0';
         tCS <= '1';
         tSDIO <= '0';
      else 
         -- Write operation: Insert sSDIO to TestSPI_Clk hold time error of 1ns 
         -- for command bit 2. 
         tCommand <= kCmdRdWr & "00" & kCmdAddr;
         tData <= kCmdData;
         TestSPI_Clk <= '0';
         tSDIO <= '0';
         tCS <= '1';
         wait for kSysClkPeriod;
         tCS <= '0';
         tSDIO <= tCommand(15);
         wait for (ktS);
         for i in (kNoCommandBits - 2) downto 0 loop
            TestSPI_Clk <= '1';
            wait for (ktDH - 1 ns);
            if (i = 1) then
               report "Insert sSDIO (Cmd[2]) to sSPI_Clk hold time error" & LF & HT & HT;
               tSDIO <= tCommand(i);    
            end if;
            wait for (kSclkHigh*3 - ktDH + 1ns);
            TestSPI_Clk <= '0';
            tSDIO <= tCommand(i);
            wait for kSclkLow*3;
         end loop;
         for i in (kNoDataBits) downto 0 loop
            TestSPI_Clk <= '1';
            wait for kSclkHigh*3;
            TestSPI_Clk <= '0';
            if (i > 0) then
               tSDIO <= tData(i-1);
            else
               tSDIO <= 'Z';
            end if;
            wait for kSclkLow*3;
         end loop;
         wait for ktH;
         tSDIO <= '0';
         tCS <= '1';
      end if;   

   elsif (kErrorType = 4) then
      if (kCmdRdWr = '1') then  
         -- Read operation not currently supported for this error type.
         TestSPI_Clk <= '0';
         tCS <= '1';
         tSDIO <= '0';
      else 
         -- Write operation: Insert tCS to TestSPI_Clk hold time error of 1ns; 
         -- TestSPI_Clk pulse width errors and hold time error also inserted on Data[0].
         tCommand <= kCmdRdWr & "00" & kCmdAddr;
         tData <= kCmdData;
         TestSPI_Clk <= '0';
         tSDIO <= '0';
         tCS <= '1';
         wait for kSysClkPeriod;
         tCS <= '0';
         tSDIO <= tCommand(15);
         wait for (ktS);
         for i in (kNoCommandBits - 2) downto 0 loop
            TestSPI_Clk <= '1';
            wait for (kSclkHigh*3);
            TestSPI_Clk <= '0';
            tSDIO <= tCommand(i);
            wait for kSclkLow*3;
         end loop;
         for i in (kNoDataBits) downto 0 loop
            TestSPI_Clk <= '1';
            if (i = 0) then
               wait for ((ktH - 1ns)/2);
               report "insert sSPI_Clk pulse width error and sSDIO (Data[0]) to sSPI_Clk hold time error" & LF & HT & HT;
            else
               wait for kSclkHigh*3;
            end if;
            TestSPI_Clk <= '0';
            if (i > 0) then
               tSDIO <= tData(i-1);
            else
            tSDIO <= 'Z';
            end if;
            if (i = 0) then
               wait for ((ktH - 1ns)/2);
               report "insert sCS to sSPI_Clk hold and sSPI_CLK pulse width errors" & LF & HT & HT;
               tCS <= '1';
            else
               wait for kSclkLow*3;
            end if;
         end loop;
         tSDIO <= '0';
         tCS <= '1';
      end if;
         
   elsif (kErrorType = 5) then
      if (kCmdRdWr = '1') then  
         -- Read operation not currently supported for this error type.
         TestSPI_Clk <= '0';
         tCS <= '1';
         tSDIO <= '0';
      else 
         -- Write operation: insert pulse width errors (0.5ns) and TestSPI_Clk 
         -- period errors on Cmd[2] and Data[2].
         tCommand <= kCmdRdWr & "00" & kCmdAddr;
         tData <= kCmdData;
         TestSPI_Clk <= '0';
         tSDIO <= '0';
         tCS <= '1';
         wait for kSysClkPeriod;       
         tCS <= '0';
         tSDIO <= tCommand(15);
         wait for ktS;
         for i in (kNoCommandBits - 2) downto 0 loop
            if (i=1) then
               -- Rising edge of address bit 2.
               TestSPI_Clk <= '1';
               wait for (kSclkHigh - 0.5ns);
               report "Insert sSPI_Clk pulse width high error on Cmd[2]" & LF & HT & HT;
               TestSPI_Clk <= '0';
               -- Place address bit 1 on SDIO.
               tSDIO <= tCommand(i);
               wait for (kSclkLow - 0.5ns);
               report "Insert sSPI_Clk pulse width low and period error on Cmd[2]" & LF & HT & HT;
            else
               TestSPI_Clk <= '1';
               wait for kSclkHigh*3;
               TestSPI_Clk <= '0';
               tSDIO <= tCommand(i);
               wait for kSclkLow*3;       
            end if;
         end loop;
         for i in (kNoDataBits) downto 0 loop
            if (i = 2) then
               TestSPI_Clk <= '1';
               wait for (kSclkHigh - 0.5ns);
               report "Insert sSPI_Clk pulse width high error on Data[2]" & LF & HT & HT;
               TestSPI_Clk <= '0';
               tSDIO <= tData(i-1);
               wait for (kSclkLow - 0.5ns);
               report "Insert sSPI_Clk pulse width low and period error on Data[2]" & LF & HT & HT;       
            else
               TestSPI_Clk <= '1';
               wait for kSclkHigh*3;
               TestSPI_Clk <= '0';
               if (i > 0) then
                  tSDIO <= tData(i-1);
               else
                  tSDIO <= 'Z';
               end if;
               wait for kSclkLow*3;
            end if;
         end loop;
         wait for ktH;
         tSDIO <= '0';
         tCS <= '1';
      end if;
            
   elsif (kErrorType = 6) then
         if (kCmdRdWr = '1') then  
         -- Read operation not currently supported for this error type.
         TestSPI_Clk <= '0';
         tCS <= '1';
         tSDIO <= '0';
      else 
         -- Write operation: send extra command bit (25 bit transfer).
         tCommand <= kCmdRdWr & "00" & kCmdAddr;
         tData <= kCmdData;
         TestSPI_Clk <= '0';
         tSDIO <= '0';
         tCS <= '1';
         wait for kSysClkPeriod; 
         tCS <= '0';
         tSDIO <= tCommand(15);
         wait for ktS;
         for i in (kNoCommandBits - 2) downto 0 loop
            TestSPI_Clk <= '1';
            wait for kSclkHigh*3;
            TestSPI_Clk <= '0';
            tSDIO <= tCommand(i);
            wait for kSclkLow*3;
         end loop;
         -- Add extra command bit.
         TestSPI_Clk <= '1';
         wait for kSclkHigh*3;
         TestSPI_Clk <= '0';
         tSDIO <= tCommand(0);
         wait for kSclkLow*3;
         for i in (kNoDataBits) downto 0 loop
            TestSPI_Clk <= '1';
            wait for kSclkHigh*3;
            TestSPI_Clk <= '0';
            if (i > 0) then
               tSDIO <= tData(i-1);
            else
               tSDIO <= 'Z';
            end if;
            wait for kSclkLow*3;
         end loop;
         wait for ktH;
         report "Insert Extra bit in transaction" & LF & HT & HT;
         tSDIO <= '0';
         tCS <= '1';
         wait for 100 ns;
      end if;    
   end if;             
  wait;
  end process;
  
end Behavioral;
