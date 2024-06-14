-------------------------------------------------------------------------------
--
-- File: SyncAsync.vhd
-- Author: Elod Gyorgy
-- Original Project: HDMI input on 7-series Xilinx FPGA
-- Date: 15 December 2017
--
-------------------------------------------------------------------------------
--MIT License
--
--Copyright (c) 2016 Digilent
--
--Permission is hereby granted, free of charge, to any person obtaining a copy
--of this software and associated documentation files (the "Software"), to deal
--in the Software without restriction, including without limitation the rights
--to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--copies of the Software, and to permit persons to whom the Software is
--furnished to do so, subject to the following conditions:
--
--The above copyright notice and this permission notice shall be included in all
--copies or substantial portions of the Software.
--
--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--SOFTWARE.
--
-------------------------------------------------------------------------------
--
-- Purpose:
-- This module synchronizes the asynchronous signal (aIn) with the OutClk clock
-- domain and provides it on oOut. The number of FFs in the synchronizer chain
-- can be configured with kStages. The reset value for oOut can be configured
-- with kResetTo. The asynchronous reset (aReset) is always active-high.
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

entity SyncAsync is
   Generic (
      kResetTo : std_logic := '0'; --value when reset and upon init
      kStages : natural := 2; --double sync by default
      kResetPolarity : std_logic := '1'); --aReset active-high by default
   Port (
      aReset : in STD_LOGIC; -- active-high/active-low asynchronous reset
      aIn : in STD_LOGIC;
      OutClk : in STD_LOGIC;
      oOut : out STD_LOGIC);
end SyncAsync;

architecture Behavioral of SyncAsync is
signal oSyncStages : std_logic_vector(kStages-1 downto 0) := (others => kResetTo);
attribute ASYNC_REG : string;
attribute ASYNC_REG of oSyncStages: signal is "TRUE";
begin

Sync: process (OutClk, aReset)
begin
   if (aReset = kResetPolarity) then
      oSyncStages <= (others => kResetTo);
   elsif Rising_Edge(OutClk) then
      oSyncStages <= oSyncStages(oSyncStages'high-1 downto 0) & aIn;
   end if;
end process Sync;
oOut <= oSyncStages(oSyncStages'high);

end Behavioral;
