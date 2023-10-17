-------------------------------------------------------------------------------
--
-- File: SyncBase.vhd
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
-- This module synchronizes a signal (iIn) in one clock domain (InClk) with
-- another clock domain (OutClk) and provides it on oOut.
-- The number of FFs in the synchronizer chain
-- can be configured with kStages. The reset value for oOut can be configured
-- with kResetTo. The asynchronous resets (aiReset and aoReset) with
-- synchronous deassertion are always active-high, and they should not be
-- asserted independently.
--
-- Constraints:
-- # Replace <InstSyncBase> with path to SyncBase instance, keep rest unchanged
-- # Begin scope to SyncBase instance
-- current_instance [get_cells <InstSyncBase>]
-- # Input to synchronizer ignored for timing analysis
-- set_false_path -through [get_pins SyncAsyncx/aIn]
-- # Constrain internal synchronizer paths to half-period, which is expected to be easily met with ASYNC_REG=true
-- set ClkPeriod [get_property PERIOD [get_clocks -of_objects [get_ports -scoped_to_current_instance OutClk]]]
-- set_max_delay -from [get_cells SyncAsyncx/oSyncStages_reg[*]] -to [get_cells SyncAsyncx/oSyncStages_reg[*]] [expr $ClkPeriod/2]
-- current_instance -quiet
-- # End scope to SyncBase instance
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

entity SyncBase is
   Generic (
      kResetTo : std_logic := '0'; --value when reset and upon init
      kStages : natural := 2); --double sync by default
   Port (
      aiReset : in STD_LOGIC; -- active-high asynchronous reset
      InClk : in std_logic;
      iIn : in STD_LOGIC;
      aoReset : in STD_LOGIC; -- active-high asynchronous reset
      OutClk : in STD_LOGIC;
      oOut : out STD_LOGIC);
   attribute keep_hierarchy : string;
   attribute keep_hierarchy of SyncBase : entity is "yes";      
end SyncBase;

architecture Behavioral of SyncBase is

signal iIn_q : std_logic;
begin

--By re-registering iIn on its own domain, we make sure iIn_q is glitch-free
SyncSource: process(aiReset, InClk)
begin
   if (aiReset = '1') then
      iIn_q <= kResetTo;
   elsif Rising_Edge(InClk) then
      iIn_q <= iIn;
   end if;
end process SyncSource;

--Crossing clock boundary here 
SyncAsyncx: entity work.SyncAsync
   generic map (
      kResetTo => kResetTo,
      kStages => kStages)
   port map (
      aoReset => aoReset,
      aIn => iIn_q,
      OutClk => OutClk,
      oOut => oOut);

end Behavioral;
