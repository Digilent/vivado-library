
-------------------------------------------------------------------------------
--
-- File: SPI_IAP_TestModule.vhd
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
-- This module is designed to emulate the upper level IP for the SPI indirect
-- access port to facilitate the testing of the ConfigADC module.
-- The Axi Stream command FIFO is loaded with kCmdFIFO_NoWrCmds commands and the 
-- data read back from the AD96xx_92xxSPI_Model is compared against the expected 
-- data.
--  
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.PkgZmodDigitizer.all;

entity SPI_IAP_TestModule is
   Generic (
      -- Parameter identifying the Zmod:
      -- 0 -> Zmod Scope 1410 - 105 (AD9648)       
      -- 1 -> Zmod Scope 1010 - 40 (AD9204)       
      -- 2 -> Zmod Scope 1010 - 125 (AD9608)       
      -- 3 -> Zmod Scope 1210 - 40 (AD9231)       
      -- 4 -> Zmod Scope 1210 - 125 (AD9628)       
      -- 5 -> Zmod Scope 1410 - 40 (AD9251)       
      -- 6 -> Zmod Scope 1410 - 125 (AD9648)
      kZmodID : integer range 0 to 6 := 6
   );
   Port (
      -- 100MHZ clock input. 
      SysClk100 : in STD_LOGIC;
      -- Reset signal asynchronously asserted and synchronously 
      -- de-asserted (in SysClk100 domain).
      asRst_n : in STD_LOGIC;
      -- ADC initialization complete flag.
      sInitDoneADC : in std_logic;
      
      -- SPI Indirect access port; it provides the means to indirectly access
      -- the ADC registers. It is designed to interface with 2 AXI StreamFIFOs, 
      -- one that stores commands to be transmitted and one to store the received data.
      
      -- TX command AXI stream interface
      sCmdTxAxisTvalid: out STD_LOGIC;
      sCmdTxAxisTready: in STD_LOGIC;
      sCmdTxAxisTdata: out STD_LOGIC_VECTOR(31 DOWNTO 0);
      -- TX command AXI stream interface
      sCmdRxAxisTvalid: in STD_LOGIC;
      sCmdRxAxisTready: out STD_LOGIC;
      sCmdRxAxisTdata : in STD_LOGIC_VECTOR(31 DOWNTO 0)     
   );
end SPI_IAP_TestModule;

architecture Behavioral of SPI_IAP_TestModule is

COMPONENT ADC_CommandFIFO
  PORT (
    wr_rst_busy : OUT STD_LOGIC;
    rd_rst_busy : OUT STD_LOGIC;
    m_aclk : IN STD_LOGIC;
    s_aclk : IN STD_LOGIC;
    s_aresetn : IN STD_LOGIC;
    s_axis_tvalid : IN STD_LOGIC;
    s_axis_tready : OUT STD_LOGIC;
    s_axis_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_tvalid : OUT STD_LOGIC;
    m_axis_tready : IN STD_LOGIC;
    m_axis_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

signal sCmdTxWrRstBusy, sCmdTxRdRstBusy : std_logic;
signal sCmdRxWrRstBusy, sCmdRxRdRstBusy : std_logic;
signal sMasterTxAxisTvalid, sMasterTxAxisTready : std_logic;
signal sMasterTxAxisTdata : std_logic_vector (31 downto 0);
signal sMasterTxAxisTvalidSR : std_logic_vector (kCmdFIFO_NoWrCmds downto 0);

signal sTestCmdRxAxisTvalid : STD_LOGIC;
signal sTestCmdRxAxisTready : STD_LOGIC;
signal sTestCmdRxAxisTdata : STD_LOGIC_VECTOR(31 DOWNTO 0); 
signal RxCmdIndex : unsigned (kCmdFIFO_NoWrCmds downto 0);
signal sTransactionTimer : unsigned (23 downto 0) := (others => '0');  
signal RxCmdDone, RxCmdOverflow, RxCmdRdbkErr, sRxTransactionTimeExpired : std_logic := '0';
signal sComandList : CmdFIFO_WrCmdList_t;
-- chip grade,  chip ID
constant kCmdFIFO_RdList : CmdFIFO_RdCmdList_t := (SelADC_Grade(kZmodID),SelADC_ID(kZmodID));  

begin

InstTxFIFO : ADC_CommandFIFO
  PORT MAP (
    wr_rst_busy => sCmdTxWrRstBusy,
    rd_rst_busy => sCmdTxRdRstBusy,
    m_aclk => SysClk100,
    s_aclk => SysClk100,
    s_aresetn => asRst_n,
    s_axis_tvalid => sMasterTxAxisTvalid,
    s_axis_tready => sMasterTxAxisTready,
    s_axis_tdata => sMasterTxAxisTdata,
    m_axis_tvalid => sCmdTxAxisTvalid,
    m_axis_tready => sCmdTxAxisTready,
    m_axis_tdata => sCmdTxAxisTdata
  );

sTestCmdRxAxisTready <= '1';
        
InstRxFIFO : ADC_CommandFIFO
  PORT MAP (
    wr_rst_busy => sCmdRxWrRstBusy,
    rd_rst_busy => sCmdRxRdRstBusy,
    m_aclk => SysClk100,
    s_aclk => SysClk100,
    s_aresetn => asRst_n,
    s_axis_tvalid => sCmdRxAxisTvalid,
    s_axis_tready => sCmdRxAxisTready,
    s_axis_tdata => sCmdRxAxisTdata,
    m_axis_tvalid => sTestCmdRxAxisTvalid,
    m_axis_tready => sTestCmdRxAxisTready,
    m_axis_tdata => sTestCmdRxAxisTdata
  );  

-- Load the TX command FIFO with the same command list used for the AD96xx/AD92xx 
-- initialization. The command list is truncated to kNumCommands.
-- A shift register on kNumCommands+1 bits will be used to generate the TX command FIFO
-- master interface valid signal.

ProcTxCmdTvalid: process (SysClk100, asRst_n) 
begin
   if (asRst_n = '0') then
      sMasterTxAxisTvalidSR(kCmdFIFO_NoWrCmds downto 1) <= (others => '1');
      sMasterTxAxisTvalidSR(0) <= '0';
      for i in 0 to kCmdFIFO_NoWrCmds loop
         sComandList(i) <= kCmdFIFO_WrList(i);
      end loop;
   elsif (rising_edge(SysClk100)) then
      if (sMasterTxAxisTready = '1') then  -- sCmdTxWrRstBusy always in Hi-Z in simulation 
         sMasterTxAxisTvalidSR <= '0' & sMasterTxAxisTvalidSR(kCmdFIFO_NoWrCmds downto 1);
         for i in 0 to kCmdFIFO_NoWrCmds-1 loop
            sComandList(i) <= sComandList(i+1);
         end loop;
         sComandList(kCmdFIFO_NoWrCmds) <= (others => '0');
      end if;  
    end if;
end process;

sMasterTxAxisTvalid <= sMasterTxAxisTvalidSR(0);
sMasterTxAxisTdata <= x"00" & sComandList(0);

-- This process verifies if the expected number of read commands have been 
-- completed. An index is incremented as data is extracted from the RX 
-- command FIFO.
ProcCmdIndex: process (SysClk100, asRst_n) 
begin
   if (asRst_n = '0') then
      RxCmdIndex <= (others => '0');
      RxCmdDone <= '0';
      RxCmdOverflow <= '0';
   elsif (rising_edge(SysClk100)) then
      if ((sTestCmdRxAxisTready = '1') and (sTestCmdRxAxisTvalid = '1')) then  
         RxCmdIndex <= RxCmdIndex + 1;
         if (RxCmdIndex = kCmdFIFO_NoRdCmds - 1) then
            RxCmdDone <= '1';
         elsif (RxCmdIndex > kCmdFIFO_NoRdCmds - 1) then
            RxCmdOverflow <= '1';
         end if;
      end if;  
    end if;
end process;

-- Data checker process; Reads the data available in the Rx command FIFO,
-- compares it against the expected values and asserts a flag if all
-- received commands match the expected values.

ProcDataChecker: process (SysClk100, asRst_n) 
begin
   if (asRst_n = '0') then
      RxCmdRdbkErr <= '0';
   elsif (rising_edge(SysClk100)) then
      if ((sTestCmdRxAxisTready = '1') and (sTestCmdRxAxisTvalid = '1')) then  
         if (kCmdFIFO_RdList(to_integer(RxCmdIndex)) /= sTestCmdRxAxisTdata(7 downto 0)) then
            RxCmdRdbkErr <= '1';
         end if;
      end if;  
    end if;
end process;

-- Timer used to determine a timeout condition for the SPI indirect
-- access port transactions to complete. The assertion of sRxTransactionTimeExpired 
-- does not represent an error itself. When sRxTransactionTimeExpired is asserted,
-- RxCmdDone, RxCmdOverflow and RxCmdRdbkErr are evaluated to determine if the
-- transaction was successful or not.
ProcClkCounter: process (SysClk100, asRst_n) --clock frequency divider
begin
   if (asRst_n = '0') then
      sTransactionTimer <= (others => '0');
      sRxTransactionTimeExpired  <= '0';
   elsif (rising_edge(SysClk100)) then
      if (sInitDoneADC = '0') then
         sTransactionTimer <= (others => '0');
      else
         if (sTransactionTimer = kCmdFIFO_Timeout) then
            sRxTransactionTimeExpired  <= '1';
         else
            sTransactionTimer <= sTransactionTimer + 1;
         end if;
      end if;
   end if;
end process; 

-- Process checking relevant status flags and determining if the
-- expected data was correctly received.
ProcMain: process 
begin
   wait until rising_edge(sRxTransactionTimeExpired );
   assert (RxCmdDone = '1' and RxCmdOverflow = '0' and RxCmdRdbkErr = '0')
      report "RX FIFO SPI indirect access port command read back error" & LF & HT & HT 
      severity ERROR;
 
   wait;
end process;
  
end Behavioral;
