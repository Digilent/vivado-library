
-------------------------------------------------------------------------------
--
-- File: DataPathLatency.vhd
-- Author: Tudor Gherman, Robert Bocos
-- Original Project: ZmodScopeController
-- Date: 20 May 2020
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
-- This module emulates the DataPah.vhd module latency. This operation is 
-- necessary to test the calibrated outputs in the tb_TestTop top level test bench
-- of the ZmodScopeController.
-- The FIFO data latency is specified (is it? not sure...) in 
-- Xilinx pg057 Table 3-26 (Read Port Flags Update Latency Due to a Write Operation)
-- Latency = 1 wr_clk + (N + 4) rd_clk (+1 rd_clk) 
-- The latency is defined in Fig. 3-40 of the same document. A register stage 
-- corresponds to 0 cycles of latency. Thus, for a latency of 1 wr_clk, 2 register
-- stages have to be implemented in the write clock domain to emulate the FIFO write
-- latency. An extra cycle needs to be considered for the IDDR primitives in the data 
-- path. Thus, a total of 3 register stages are added on the write clock domain to 
-- emulate the DataPath module write domain latency.
-- Considering the same definition for the read clock domain latency, N+4+1
-- register stages are added on the read clock domain. 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DataPathLatency is
    Generic (
        -- FIFO number of synchronization stages
        kNumFIFO_Stages : integer := 0;
        -- Channel data width
        kDataWidth : integer := 14
    );
    Port (
        ZmodDcoClk : in STD_LOGIC;
        ZmodDcoClkDly : std_logic;
        doDataIn : in STD_LOGIC_VECTOR (kDataWidth-1 downto 0);
        doChA_DataOut : out STD_LOGIC_VECTOR (kDataWidth-1 downto 0);
        doChB_DataOut : out STD_LOGIC_VECTOR (kDataWidth-1 downto 0)
    );
end DataPathLatency;

architecture Behavioral of DataPathLatency is

    signal doChA_DataIn, doChB_DataIn, doChB_DataInFalling : STD_LOGIC_VECTOR (kDataWidth-1 downto 0);
    type cDlyArray_t is array (kNumFIFO_Stages+4 downto 0) of std_logic_vector(kDataWidth-1 downto 0); 
    signal cChA_DataDly, cChB_DataDly : cDlyArray_t := (others => (others => '0')); 
    type dDlyArray_t is array (1 downto 0) of std_logic_vector(kDataWidth-1 downto 0); 
    signal dChA_DataDly, dChB_DataDly : dDlyArray_t := (others => (others => '0')); 

begin

    -- Emulate IDDR on ChA (sampled on rising edge)
    ProcIDDR_ChA : process (ZmodDcoClkDly)
    begin
        if (rising_edge(ZmodDcoClkDly)) then
            doChA_DataIn <= doDataIn;
        end if;
    end process;

    -- Emulate IDDR on ChB (sampled on falling edge)
    ProcIDDR_ChB_Falling : process (ZmodDcoClkDly)
    begin
        if (falling_edge(ZmodDcoClkDly)) then
            doChB_DataInFalling <= doDataIn;
        end if;
    end process;

    ProcIDDR_ChB_Rising : process (ZmodDcoClkDly)
    begin
        if (rising_edge(ZmodDcoClkDly)) then
            doChB_DataIn <= doChB_DataInFalling;
        end if;
    end process;

    --Emulate the D Flip-Flops which are the last stages of the DataPath module 
    ProcDelayDcoClkOut: process (ZmodDcoClk)
    begin
        if (rising_edge(ZmodDcoClk)) then
            doChA_DataOut <= doChA_DataIn;
            doChB_DataOut <= doChB_DataIn;
        end if;
    end process;

end Behavioral;
