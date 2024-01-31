
-------------------------------------------------------------------------------
--
-- File: tb_TestConfigADC.vhd
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
-- This test bench is used to illustrate the ConfigADC module behavior.
-- It does not represent an extensive test of the module. The external
-- indirect access SPI interface is not used. The AD96xx_92xxSPI_Model is however
-- requested to deliberately insert an error on the InsertError port to test
-- the response of the configuration state machine error reporting circuitry.
--
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.PkgZmodDigitizer.all;

entity tb_TestConfigADC is
   Generic (
      -- Parameter identifying the Zmod:
      -- 0 -> Zmod Scope 1410 - 105 (AD9648)       
      -- 1 -> Zmod Scope 1010 - 40 (AD9204)       
      -- 2 -> Zmod Scope 1010 - 125 (AD9608)       
      -- 3 -> Zmod Scope 1210 - 40 (AD9231)       
      -- 4 -> Zmod Scope 1210 - 125 (AD9628)       
      -- 5 -> Zmod Scope 1410 - 40 (AD9251)       
      -- 6 -> Zmod Scope 1410 - 125 (AD9648)
      kZmodID : integer range 0 to 6 := 1;
      kADC_ClkDiv : integer range 1 to 8 := 4
   );
end tb_TestConfigADC;

architecture Behavioral of tb_TestConfigADC is

signal SysClk100 : std_logic := '1';
signal asRst_n : std_logic := '0';
signal sSPI_Clk, sSDIO : std_logic := 'X';
signal sCS : std_logic := '1';
signal InsertError : std_logic;
  
signal sCmdTxAxisTvalid : std_logic;                        
signal sCmdTxAxisTready : std_logic;                    
signal sCmdTxAxisTdata : std_logic_vector(31 downto 0);                     
signal sCmdRxAxisTvalid : STD_LOGIC;                    
signal sCmdRxAxisTready : std_logic; 
signal sCmdRxAxisTdata :  std_logic_vector (31 downto 0);                    
signal sInitDoneADC : std_logic;   
signal sConfigError : std_logic;   

constant kSysClkPeriod : time := 10ns;  -- System Clock Period
  
begin
  
ConfigADC_inst: entity work.ConfigADC
Generic Map(
     kZmodID => kZmodID,
     kADC_ClkDiv => kADC_ClkDiv,
     kDataWidth => kSPI_DataWidth,
     kCommandWidth => kSPI_CommandWidth,
     kSimulation => true
    ) 
Port Map( 
    --
    SysClk100 => SysClk100,
    asRst_n => asRst_n,
    sInitDoneADC => sInitDoneADC,
    sConfigError => sConfigError,
    sConfigADCEnable => '1',--Pretend that the clock generator that feeds the ADC has been configured and is locked 
    --AD9648 SPI interface signals
    sADC_Sclk => sSPI_Clk,
    sADC_SDIO => sSDIO,
    sADC_CS => sCS,
    sCmdTxAxisTvalid => sCmdTxAxisTvalid,                      
    sCmdTxAxisTready => sCmdTxAxisTready,                    
    sCmdTxAxisTdata => sCmdTxAxisTdata,                  
    sCmdRxAxisTvalid => sCmdRxAxisTvalid,                  
    sCmdRxAxisTready => sCmdRxAxisTready,
    sCmdRxAxisTdata => sCmdRxAxisTdata
    ); 

TestCmdFIFO: entity work.SPI_IAP_TestModule 
   Generic Map(
      kZmodID => kZmodID
   )
   Port Map( 
      SysClk100 => SysClk100,
      asRst_n => asRst_n,
      sInitDoneADC => sInitDoneADC,
      sCmdTxAxisTvalid => sCmdTxAxisTvalid,
      sCmdTxAxisTready => sCmdTxAxisTready,
      sCmdTxAxisTdata => sCmdTxAxisTdata,
      sCmdRxAxisTvalid => sCmdRxAxisTvalid,
      sCmdRxAxisTready => sCmdRxAxisTready,
      sCmdRxAxisTdata => sCmdRxAxisTdata
   );

   
AD96xx_92xx_inst: entity work.AD96xx_92xxSPI_Model
   Generic Map(
      kZmodID => kZmodID,
      kDataWidth => kSPI_DataWidth,
      kCommandWidth => kSPI_CommandWidth
   )
Port Map(
    SysClk100 => SysClk100,
    asRst_n => asRst_n,
    InsertError => InsertError, 
    sSPI_Clk => sSPI_Clk,
    sSDIO => sSDIO,
    sCS => sCS
    );   

Clock: process
begin
   for i in 0 to (kCount5ms*3) loop
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
   asRst_n <= '0'; 
   InsertError <= '0';                                                    
   wait for 10 * kSysClkPeriod;
   -- Signals are assigned at test bench level on the falling edge of SysClk100.
   wait until falling_edge(SysClk100);
   -- Release reset and perform the ADC initialization with no error inserted.
   asRst_n <= '1';
   -- Check if the sInitDoneADC signal is asserted and sConfigError is de-asserted 
   -- after the configuration timeout period (determined empirically)
   wait for kCount5ms * kSysClkPeriod;
   assert (sInitDoneADC = '1')
      report "sInitDoneADC signal not asserted when expected" & LF & HT & HT 
      severity ERROR;
   assert (sConfigError = '0')
      report "sConfigError signal not de-asserted when expected" & LF & HT & HT 
      severity ERROR;
   
   -- Hold the reset condition for 10 clock cycles
   -- (one clock cycle is sufficient, however 10 clock cycles makes
   -- it easier to visualize the reset condition in simulation).  
   asRst_n <= '0'; 
   wait for 10*kSysClkPeriod;
   
   wait until falling_edge(SysClk100);
   -- Request the ADI_2WireSPI_Model to deliberately insert a register read error.
   InsertError <= '1';
   asRst_n <= '1'; 
   -- Check if the sInitDoneADC signal is de-asserted and sConfigError is asserted 
   -- after the configuration timeout period (determined empirically) in the case 
   -- of an erroneous response of the ADC
   wait for kCount5ms * kSysClkPeriod;
   assert (sInitDoneADC = '0')
      report "sInitDoneADC signal is erroneously asserted" & LF & HT & HT 
      severity ERROR;
   assert (sConfigError = '1')
      report "sConfigError signal not asserted when expected" & LF & HT & HT 
      severity ERROR;   
        
   wait;
end process;
  
end Behavioral;
