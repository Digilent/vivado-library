-------------------------------------------------------------------------------
--
-- File: ResetBridge.vhd
-- Author: Elod Gyorgy
-- Original Project: HDMI input on 7-series Xilinx FPGA
-- Date: 20 October 2014
-- Last modification date: 05 October 2022
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
-- This module is a reset-bridge. It takes a reset signal asynchronous to the 
-- target clock domain (OutClk) and provides a safe asynchronous or synchronous
-- reset for the OutClk domain (aoRst). The signal aoRst is asserted immediately 
-- as aRst arrives, but is de-asserted synchronously with the OutClk rising
-- edge. This means it can be used to safely reset any FF in the OutClk domain,
-- respecting recovery time specs for FFs.
-- The additional output register does not have placement and overly
-- restrictive delay constraints, so that the tools can freely replicate it,
-- if needed.
--
-- Constraints:
-- # Replace <InstResetBridge> with path to ResetBridge instance, keep rest unchanged
-- # Begin scope to ResetBridge instance
-- current_instance [get_cells <InstResetBridge>]
-- # Reset input to the synchronizer must be ignored for timing analysis
-- set_false_path -through [get_ports -scoped_to_current_instance aRst]
-- # Constrain internal synchronizer paths to half-period, which is expected to be easily met with ASYNC_REG=true
-- set ClkPeriod [get_property PERIOD [get_clocks -of_objects [get_ports -scoped_to_current_instance OutClk]]]
-- set_max_delay -from [get_cells OutputFF*.SyncAsyncx/oSyncStages_reg[*]] -to [get_cells OutputFF*.SyncAsyncx/oSyncStages_reg[*]] [expr $ClkPeriod/2]
-- current_instance -quiet
-- # End scope to ResetBridge instance
-- 
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ResetBridge is
   Generic (
      kPolarity : std_logic := '1';
      kStages : natural := 2;
      kOutputFF : boolean := false); -- additional output FF for replication
   Port (
      aRst : in STD_LOGIC; -- asynchronous reset; active-high, if kPolarity=1
      OutClk : in STD_LOGIC;
      aoRst : out STD_LOGIC);
   attribute keep_hierarchy : string;
   attribute keep_hierarchy of ResetBridge : entity is "yes";
end ResetBridge;

architecture Behavioral of ResetBridge is
signal aRst_int, aoRst_int : std_logic;
begin

aRst_int <= kPolarity xnor aRst; --SyncAsync uses active-high reset

OutputFF_Yes: if kOutputFF generate
   SyncAsyncx: entity work.SyncAsync
      generic map (
         kResetTo => '1',
         kStages => kStages) --use double FF synchronizer
      port map (
         aoReset => aRst_int,
         aIn => '0',
         OutClk => OutClk,
         oOut => aoRst_int);

-- Output FF that can be replicated by the tools, if needed
   OutputFF: process (OutClk, aoRst_int)
   begin
      if (aoRst_int = '1') then
         aoRst <= kPolarity;
      elsif Rising_Edge(OutClk) then
         aoRst <= not kPolarity;
      end if;
   end process;
end generate OutputFF_Yes;

OutputFF_No: if not kOutputFF generate
   SyncAsyncx: entity work.SyncAsync
      generic map (
         kResetTo => kPolarity,
         kStages => kStages) --use double FF synchronizer
      port map (
         aoReset => aRst_int,
         aIn => not kPolarity,
         OutClk => OutClk,
         oOut => aoRst);
end generate OutputFF_No;

end Behavioral;
