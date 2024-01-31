-------------------------------------------------------------------------------
--
-- File: ClockGen_I2C_DataCheck.vhd
-- Author: Elod Gyorgy, Robert Bocos
-- Original Project: HDMI input on 7-series Xilinx FPGA
-- Date: 15 October 2014
--
-------------------------------------------------------------------------------
-- (c) 2014 Copyright Digilent Incorporated
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
-- Purpose:
--    This modules checks the data sent over I2C by the ConfigClockGen module
--    and compares it with the actual configuration data. Sends out an ERROR
--    when there is a mismatch.
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;
use work.PkgZmodDigitizer.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ClockGen_I2C_DataCheck is
   Generic (
      kSampleClkFreqInMHz : natural := 100;
      kSlaveAddress : std_logic_vector(7 downto 1) := "1101000";
      kFreqSel : integer range 0 to 7 := 0
      );
   Port (
      SampleClk : in STD_LOGIC; --at least fSCL*10
      sRst : in std_logic;
      sI2C_DataOut : out std_logic_vector(7 downto 0);
      -- two-wire interface
      aSDA_I : in  STD_LOGIC;
      aSDA_O : out  STD_LOGIC;
      aSDA_T : out  STD_LOGIC;
      aSCL_I : in  STD_LOGIC;
      aSCL_O : out  STD_LOGIC;
      aSCL_T : out  STD_LOGIC);
end ClockGen_I2C_DataCheck;

architecture Behavioral of ClockGen_I2C_DataCheck is
 
signal sState, sNstate : FsmStatesI2C_t := stIdle;

signal sI2C_DataIn : std_logic_vector(7 downto 0);
signal sI2C_Stb, sI2C_Done, sI2C_End, sI2C_RdWrn : std_logic;
signal sCmdCnt : unsigned(6 downto 0) := (others => '0');
signal sIncCmdCnt : std_logic := '0';
signal sRstCmdCnt : std_logic := '0'; 
begin

-- Instantiate the I2C Slave Receiver
I2C_SlaveController: entity work.TWI_SlaveCtl
   generic map (
      SLAVE_ADDRESS => kSlaveAddress & '0',
      kSampleClkFreqInMHz => kSampleClkFreqInMHz)
   port map (
      D_I         => (others => '0'),
      D_O         => sI2C_DataIn,
      RD_WRN_O    => sI2C_RdWrn,
      END_O       => sI2C_End,
      DONE_O      => sI2C_Done,
      STB_I       => sI2C_Stb,
      SampleClk   => SampleClk,
      SRST        => sRst,
      --two-wire interface
      SDA_I       => aSDA_I,
      SDA_O       => aSDA_O,
      SDA_T       => aSDA_T,
      SCL_I       => aSCL_I,
      SCL_O       => aSCL_O,
      SCL_T       => aSCL_T);

RegisteredOutputs: process (SampleClk)
begin
   if (sRst = '1') then
      sRstCmdCnt <= '0';
   elsif Rising_Edge(SampleClk) then
      if (sI2C_Done = '1') then
         if (sState = stRegAddress_H or sState = stRegAddress_L or sState = stRegData_H or sState = stRegData_L) then
            sI2C_DataOut <= sI2C_DataIn;
            sRstCmdCnt <= '1';
         elsif (sState = stCheckCmdCnt) then
            sRstCmdCnt <= '1';
         end if;
      elsif (sI2C_End = '1') then
            sRstCmdCnt <= '0';
      end if;
   end if;
end process RegisteredOutputs;

ProcCmdCheck: process (SampleClk)
begin
    if Rising_Edge(SampleClk) then
      if (sI2C_Done = '1') then
         if (sState = stRegAddress_H) then
            assert sI2C_DataIn = CDCE_I2C_Cmds(kFreqSel)(to_integer(sCmdCnt))(31 downto 24)
            report "Mismatch between sent CDCE I2C commands and received CDCE I2C commands" & LF & HT & HT
            severity ERROR;
         elsif (sState = stRegAddress_L) then
            assert sI2C_DataIn = CDCE_I2C_Cmds(kFreqSel)(to_integer(sCmdCnt))(23 downto 16)
            report "Mismatch between sent CDCE I2C commands and received CDCE I2C commands" & LF & HT & HT
            severity ERROR;
         elsif (sState = stRegData_H) then
            assert sI2C_DataIn = CDCE_I2C_Cmds(kFreqSel)(to_integer(sCmdCnt))(15 downto 8)
            report "Mismatch between sent CDCE I2C commands and received CDCE I2C commands" & LF & HT & HT
            severity ERROR;
         elsif (sState = stRegData_L) then
            assert sI2C_DataIn = CDCE_I2C_Cmds(kFreqSel)(to_integer(sCmdCnt))(7 downto 0)
            report "Mismatch between sent CDCE I2C commands and received CDCE I2C commands" & LF & HT & HT
            severity ERROR;
         end if;
      end if;
    end if;
end process ProcCmdCheck;

-- Counter used to track the number of successfully received commands.    
    ProcCmdCounter: process (SampleClk, sRst)
    begin
        if (sRst = '1') then
            sCmdCnt <= (others => '0');
        elsif (rising_edge(SampleClk)) then
            if (sRstCmdCnt = '0') then
                sCmdCnt <= (others => '0');
            elsif (sIncCmdCnt = '1') then
                sCmdCnt <= sCmdCnt + 1;
            end if;
        end if;
    end process;
				
-- State machine synchronous process.				
SyncProc: process (SampleClk)
begin
   if Rising_Edge(SampleClk) then
      if (sRst = '1') then
         sState <= stIdle;
      else
         sState <= sNstate;
      end if;   
   end if;
end process SyncProc;
 
--MOORE State-Machine - Outputs based on state only
sI2C_Stb <= '1' when (sState = stRegAddress_H or sState = stRegAddress_L or sState = stRegData_H or sState = stRegData_L) else '0';
sIncCmdCnt <= '1' when (sState = StCheckCmdCnt) else '0';

NextStateDecode: process (sState, sI2C_Done, sI2C_End, sI2C_RdWrn)
begin
   --declare default state for next_state to avoid latches
   sNstate <= sState;
   case (sState) is
      when stIdle =>
         if (sI2C_Done = '1') then
            if (sI2C_RdWrn = '1') then
               sNstate <= stIdle;
            else
               sNstate <= stRegAddress_H;
            end if;
         end if;
         
      when stRegAddress_H =>
         if (sI2C_End = '1') then
            sNstate <= stIdle;
         elsif (sI2C_Done = '1') then
            sNstate <= stRegAddress_L;
         end if;
         
      when stRegAddress_L =>
         if (sI2C_End = '1') then
            sNstate <= stIdle;
         elsif (sI2C_Done = '1') then
            sNstate <= stRegData_H;
         end if; 
         
      when stRegData_H =>
         if (sI2C_End = '1') then
            sNstate <= stIdle;
         elsif (sI2C_Done = '1') then
            sNstate <= stRegData_L;
         end if;
         
      when stRegData_L =>
         if (sI2C_End = '1') then
            sNstate <= stIdle;
         elsif (sI2C_Done = '1') then
            sNstate <= StCheckCmdCnt;
         end if;
      
      when StCheckCmdCnt =>
         if (sI2C_End = '1') then
            sNstate <= stIdle;
         else
            sNstate <= stRegAddress_H;
         end if;
         
      when others =>
         sNstate <= stIdle;
   end case;      
end process NextStateDecode;

end Behavioral;