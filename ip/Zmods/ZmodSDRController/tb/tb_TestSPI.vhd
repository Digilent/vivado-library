
-------------------------------------------------------------------------------
--
-- File: tb_TestSPI.vhd
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
-- This test bench is used to illustrate the ADI_SPI module behavior.
-- A register read and a register write operations are performed. Multiple
-- back to back register read and write operation behavior are tested as part
-- of the tests carried out in the tb_TestConfigADC test bench.
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.PkgZmodDigitizer.all;

entity tb_TestSPI is
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
end tb_TestSPI;

architecture Behavioral of tb_TestSPI is

  signal sRst_n : std_logic := '0';
  signal sSPI_Clk, sSDIO : std_logic := 'X';
  signal sCS : std_logic := '1';
  signal sRdData : std_logic_vector(7 downto 0);
  signal sWrData : std_logic_vector(7 downto 0) := (others => 'X');
  signal sAddr : std_logic_vector(12 downto 0) := (others => 'X');
  signal sWidth : std_logic_vector(1 downto 0) := (others => 'X');
  signal sRdWr : std_logic;
  signal sAPStart : std_logic;
  signal sDone : std_logic;
  signal sBusy  : std_logic;

  constant kSysClkPeriod : time := 10ns;  -- System Clock Period
  
  signal SysClk100 : std_logic := '1';

begin

ADI_SPI_inst: entity work.ADI_SPI 
Port Map( 
    --
    SysClk100 => SysClk100,
    asRst_n => sRst_n,
    sSPI_Clk => sSPI_Clk,
    sSDIO => sSDIO,
    sCS => sCS,
    sApStart => sApStart, 
    sRdData => sRdData,
    sWrData => sWrData,
    sAddr => sAddr,
    sWidth => sWidth, 
    sRdWr => sRdWr,
    sDone => sDone,
    sBusy => sBusy
    ); 
    
AD96xx_92xx_inst: entity work.AD96xx_92xxSPI_Model
   Generic Map(
      kZmodID => kZmodID,
      kDataWidth => kSPI_DataWidth,
      kCommandWidth => kSPI_CommandWidth
   )
Port Map(
    SysClk100 => SysClk100, 
    asRst_n => sRst_n,
    InsertError => '0', 
    sSPI_Clk => sSPI_Clk,
    sSDIO => sSDIO,
    sCS => sCS
    );   

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
  
  Main: process
  begin
  
   -- Hold the reset condition for 10 clock cycles
   -- (one clock cycle is sufficient, however 10 clock cycles makes
   -- it easier to visualize the reset condition in simulation).
    sRst_n <= '0';
    sWrData <= x"00";
    sAddr <= "0000000000000";
    sWidth <= "00";
    sRdWr <= '0';
    sApStart <= '0';
    wait for 10 * kSysClkPeriod;
    
    -- Perform a register write operation.
    -- Signals are assigned at test bench level on the falling edge of SysClk100
    wait until falling_edge(SysClk100);
    sRst_n <= '1';
    sWrData <= x"AA";
    sAddr <= "0000000001011";
    sWidth <= "00";
    -- Trigger register write operation.
    sApStart <= '1';
    -- Wait until SPI transaction is completed.
    wait until sDone = '1';
    wait until falling_edge(SysClk100);
    sApStart <= '0';
    -- Wait until ADI_SPI module returns to idle state.
    wait until sBusy = '0';
    wait for 10*kSysClkPeriod;
   
    -- Perform a register read operation.
    wait until falling_edge(SysClk100);    
    sWrData <= x"AA";
    sAddr <= "0000000000001";
    sWidth <= "00";
    sRdWr <= '1';
    -- Trigger register read operation.
    sApStart <= '1';
    -- Wait until SPI transaction is completed.
    wait until sDone = '1';
    wait until falling_edge(SysClk100);
    sApStart <= '0';
    -- Wait until ADI_SPI module returns to idle state.
    wait until sBusy = '0';
  
    wait;
  end process;
  
end Behavioral;
