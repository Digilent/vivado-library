
-------------------------------------------------------------------------------
--
-- File: ADI_SPI.vhd
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
-- This module manages the SPI communication with the Analog Devices 3 wire SPI 
-- configuration interface
--  
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
Library UNISIM;
use UNISIM.vcomponents.all;
use IEEE.math_real.all;
use work.PkgZmodDigitizer.all;

entity ADI_SPI is
    Generic
    (
         -- The sSPI_Clk signal is obtained by dividing SysClk100 to 2^kSysClkDiv.  
        kSysClkDiv : integer range 2 to 63 := 4; 
        -- The number of data bits for the data phase of the transaction: 
        -- only 8 data bits currently supported.
        kDataWidth : integer range 8 to 8 := 8;
        -- The number of bits of the command phase of the SPI transaction.
        kCommandWidth : integer range 8 to 16 := 16 
    );
    Port (
       -- input clock (100MHZ).   
       SysClk100 : in STD_LOGIC;
       -- active low synchronous reset signal.    
       asRst_n : in STD_LOGIC;       
       --AD92xx/AD96xx SPI interface signals.
       sSPI_Clk : out STD_LOGIC;  
       sSDIO : inout STD_LOGIC;
       sCS : out STD_LOGIC := '1';
       
       --Upper layer Interface signals
       
       --a pulse on this input initiates the transfers, also used to register upper layer interface inputs.
       sApStart : in STD_LOGIC;
       --SPI read data output.  
       sRdData : out std_logic_vector(kDataWidth - 1 downto 0);
       --SPI command data. 
       sWrData : in std_logic_vector(kDataWidth - 1 downto 0);
       --SPI command register address.  
       sAddr : in std_logic_vector(kCommandWidth - 4 downto 0);
       --Number of data bytes + 1; not currently used (for future development).  
       sWidth : in std_logic_vector(1 downto 0);
       --Select between Read/Write operations.  
       sRdWr : in STD_LOGIC;   
       --A pulse is generated on this output once the SPI transfer is successfully completed.
       sDone : out STD_LOGIC;
       --Busy flag; sApStart ignored while this signal is asserted . 
       sBusy : out STD_LOGIC); 
end ADI_SPI;

architecture Behavioral of ADI_SPI is

function MAX(In1 : integer; In2 : integer) 
        return integer is
   begin
      if (In1 > In2) then
         return In1;            
      else
         return In2;
      end if;          
end function;

constant kZeros : unsigned (kSysClkDiv - 1 downto 0) := (others => '0');
constant kOnes : unsigned (kSysClkDiv - 1 downto 0) := (others => '1');

signal sClkCounter : unsigned(kSysClkDiv - 1 downto 0) := (others => '0');
signal sSPI_ClkRst: std_logic;
signal sRdDataR : std_logic_vector(kDataWidth - 1 downto 0);
signal sTxVector : std_logic_vector (kDataWidth + kCommandWidth - 1 downto 0);
signal sRxData : std_logic;
signal sTxData : std_logic := '0';
signal sTxShift, sRxShift : std_logic;
signal sLdTx : std_logic;
signal sApStartR, sApStartPulse : std_logic;
constant kCounterMax : integer := MAX((kDataWidth + kCommandWidth + 1), kCS_PulseWidthHigh);
constant kCounterNumBits : integer := integer(ceil(log2(real(kCounterMax))));
signal sCounter : unsigned (kCounterNumBits-1 downto 0);
signal sCounterInt : integer range 0 to (2**kCounterNumBits-1);
signal sCntRst_n, sTxCntEn, sRxCntEn, sDoneCntEn : std_logic := '0';
signal sBitCount : integer range 0 to kDataWidth; --Maximum 4 byte transfers for Analog Devices 2 Wire SPI
signal sDir : std_logic := '0';
signal sDirFsm : std_logic;
signal sCS_Fsm : std_logic;
signal sDoneFsm : std_logic;
signal sBusyFsm : std_logic; 

signal sCurrentState : FsmStatesSPI_t := StIdle;
signal sNextState : FsmStatesSPI_t;
-- signals used for debug purposes
-- signal fsm_state, fsm_state_r : std_logic_vector(3 downto 0);
signal kHalfScale : unsigned (kSysClkDiv - 1 downto 0);
   
begin

kHalfScale <= '1' & kZeros(kSysClkDiv - 2 downto 0);

------------------------------------------------------------------------------------------
-- SPI interface signal assignment
------------------------------------------------------------------------------------------ 

InstIOBUF : IOBUF -- instantiate SDIO three state output buffer.
   generic map (
      DRIVE => 12,
      IOSTANDARD => "LVCMOS18",
      SLEW => "SLOW")
   port map (
      O => sRxData,     -- Buffer output
      IO => sSDIO,   -- Buffer inout port (connect directly to top-level port)
      I => sTxData,     -- Buffer input
      T => sDir      -- 3-state enable input, high=input, low=output 
   );

-- Three state buffer direction control register.
ProcDir: process (SysClk100, asRst_n) 
begin
   if (asRst_n = '0') then
      sDir <= '0';
   elsif (rising_edge(SysClk100)) then
      if (sLdTx = '1') then
         sDir <= sDirFsm;
      else
         if ((sClkCounter = kOnes) or (sCS_Fsm = '1')) then
            sDir <= sDirFsm;
         end if;  
      end if;
   end if;    
end process;
         
ProcRegCS: process (SysClk100, asRst_n)
begin
   if (asRst_n = '0') then
      sCS <= '1';
      --fsm_state_r <= (others => '0');
   elsif (rising_edge (SysClk100)) then
      sCS <= sCS_Fsm;
      --fsm_state_r <= fsm_state;
   end if;        
end process;

sSPI_Clk <= sClkCounter(kSysClkDiv - 1 );

------------------------------------------------------------------------------------------
-- Input clock frequency divider
------------------------------------------------------------------------------------------

ProcClkCounter: process (SysClk100, asRst_n) --clock frequency divider
begin
   if (asRst_n = '0') then
      sClkCounter <= (others => '0');
   elsif (rising_edge(SysClk100)) then
      if (sSPI_ClkRst = '1') then
         sClkCounter <= (others => '0');
      else
         sClkCounter <= sClkCounter + 1;
      end if;
   end if;
end process; 

------------------------------------------------------------------------------------------
-- Transmit logic
------------------------------------------------------------------------------------------      
                  
sBitCount <= kDataWidth;

ProcApStartReg: process (SysClk100, asRst_n) 
begin
   if (asRst_n = '0') then
      sApStartR <= '0';
   elsif (rising_edge(SysClk100)) then
      sApStartR <= sApStart;
   end if;
end process; 
      
sApStartPulse <= sApStart and (not sApStartR);

ProcShiftTx: process (SysClk100, asRst_n) --Transmit shift register
begin
   if (asRst_n = '0') then
      sTxVector <= (others => '0');--sRdWr & "00" & sAddr & sWrData;
      sTxData <= '0';
   elsif (rising_edge(SysClk100)) then
      if (sApStartPulse = '1') then
         --sTxVector <= sRdWr & sWidth & sAddr & sWrData;
         sTxVector <= sRdWr & "00" & sAddr & sWrData;
         sTxData <= '0';
      else
         if(sTxShift = '1') then
         --data is placed on the falling edge (sClkCounter = kZeros) of sSPI_Clk for the transmit phase. 
            if ((sClkCounter = kZeros) and (sCounterInt <= kDataWidth+kCommandWidth)) then  
               sTxVector(kDataWidth + kCommandWidth - 1 downto 0) <= sTxVector(kDataWidth + kCommandWidth - 2 downto 0) & '0';
               sTxData <= sTxVector(kDataWidth + kCommandWidth - 1);
            elsif (sCounterInt > kDataWidth+kCommandWidth) then
               sTxData <= '0';
            end if;
         else
            sTxData <= '0';  
         end if;    
      end if;
   end if;  
end process;

ProcTxCount: process (asRst_n, sTxShift, sLdTx, sClkCounter) --Transmit bit count
begin
   if ((asRst_n = '0') or (sLdTx = '1')) then
      sTxCntEn <= '0';
   else
      if(sTxShift = '1') then
      --The TX bit count incremented on the falling edge of the sSPI_Clk (sClkCounter = kZeros). 
         if (sClkCounter = kZeros) then 
            sTxCntEn <= '1';
         else
            sTxCntEn <= '0';
         end if;
      else
         sTxCntEn <= '0';  
      end if;    
   end if;
end process;  

------------------------------------------------------------------------------------------
-- Receive logic
------------------------------------------------------------------------------------------

-- Receive deserializer.
ProcShiftRx: process (SysClk100, asRst_n) 
begin
   if (asRst_n = '0') then
      sRdDataR <= (others =>'0');
   elsif (rising_edge(SysClk100)) then
      if (sRxShift = '0') then
         sRdDataR <= (others =>'0');
      else
         if ((sRxShift = '1') and (sClkCounter = kHalfScale)) then
            --The read data is sampled on the rising edge of the sSPI_Clk (sClkCounter = kHalfScale).
            sRdDataR(kDataWidth - 1 downto 0) <= sRdDataR(kDataWidth - 2 downto 0) & sRxData;   
         end if;  
      end if;
   end if;
end process;
    
ProcRxCount: process (asRst_n, sRxShift, sClkCounter, kHalfScale) --Receive bit count
begin
   if ((asRst_n = '0') or (sRxShift = '0')) then
      sRxCntEn <= '0';
   else
      if (sRxShift = '1') then
         --The RX bit count is incremented on the rising edge of the sSPI_Clk (sClkCounter = kHalfScale).
         if (sClkCounter = kHalfScale) then
            sRxCntEn <= '1';
         else
            sRxCntEn <= '0';    
         end if;
      else
         sRxCntEn <= '0';    
      end if;  
   end if;
end process;

-- Register SPI read data once read instruction is completed.    
ProcRdData: process (SysClk100, asRst_n) 
begin
   if (asRst_n = '0') then
      sRdData <= (others => '0');
      sDone <= '0';
   elsif (rising_edge (SysClk100)) then
      sDone <= sDoneFsm;
      if (sDoneFsm = '1') then
         sRdData <= sRdDataR;
      end if;            
   end if;
end process;

ProcBusy: process (SysClk100, asRst_n) --register sBusyFsm output
begin
   if (asRst_n = '0') then
      sBusy <= '1';
   elsif (rising_edge (SysClk100)) then
      sBusy <= sBusyFsm;  
   end if;
end process;

--Counter used by both transmit and receive logic; sCS minimum pulse width high is also timed by this counter.  
ProcCounter: process (SysClk100, asRst_n) 
begin
   if (asRst_n = '0') then
      sCounter <= (others => '0');
   elsif (rising_edge(SysClk100)) then
      if (sCntRst_n = '0') then
         sCounter <= (others => '0');
      else
         if ((sTxCntEn = '1') or (sRxCntEn = '1') or (sDoneCntEn = '1')) then 
            sCounter <= sCounter + 1; 
         end if;    
      end if;  
   end if;
end process;

sCounterInt <= to_integer (sCounter);

------------------------------------------------------------------------------------------
-- SPI State Machine
------------------------------------------------------------------------------------------
  
ProcFsmSync: process (SysClk100, asRst_n) --State machine synchronous process
begin
   if (asRst_n = '0') then
      sCurrentState <= StIdle;
   elsif (rising_edge (SysClk100)) then
      sCurrentState <= sNextState;       
   end if;
end process;

--Next State decode logic      
ProcNextStateAndOutputDecode: process (sCurrentState, sApStart, sRdWr, sCounterInt, sClkCounter, sBitCount)
begin         
   sNextState <= sCurrentState;  
   sDirFsm <= '0';
   sCS_Fsm <= '1';
   sDoneFsm <= '0';
   sRxShift <= '0';
   sTxShift <= '0';
   --fsm_state <= (others => '0');
   sLdTx <= '0';
   sSPI_ClkRst <= '1';
   sCntRst_n <= '0';
   sDoneCntEn <= '0';
   sBusyFsm <= '1';
         
   case (sCurrentState) is
      when StIdle =>
         --fsm_state <= "0000";
         sBusyFsm <= '0';
         sLdTx <= '1';
         if (sApStart = '1') then
            if (sRdWr = '1') then
               sNextState <= StRead1;
            else
               sNextState <= StWrite;
            end if;
         end if;
              
      when StRead1 => --send command bytes
         --fsm_state <= "0001";
         sCS_Fsm <= '0';
         sTxShift <= '1';
         sSPI_ClkRst <= '0';
         sCntRst_n <= '1'; 
         if (sCounterInt = kCommandWidth) then
            sDirFsm <= '1';
            sNextState <= StRead2;
         end if;
                
      when StRead2 => --send last command bit; change three state buffer direction
         --fsm_state <= "0010";
         sDirFsm <= '1';
         sCS_Fsm <= '0';
         sTxShift <= '1';
         sSPI_ClkRst <= '0';
         sCntRst_n <= '1'; 
         if (sCounterInt = kCommandWidth + 1) then
            sNextState <= StRead3;
            sCntRst_n <= '0';
         end if;
                                    
      when StRead3 => --receive register read data
         --fsm_state <= "0011";
         sDirFsm <= '1';
         sCS_Fsm <= '0';
         sRxShift <= '1';
         sSPI_ClkRst <= '0';
         sCntRst_n <= '1';
         if ((sCounterInt = sBitCount) and (sClkCounter = kOnes + 1)) then 
		 --this condition assures a sSPI_Clk pulse width low of 2 SysClk100 cycles for last data bit
            sCntRst_n <= '0';
            sDirFsm <= '0';
            sNextState <= StDone;
         end if;
                
      when StWrite => --send SPI command and register data
         --fsm_state <= "0100";
         sCS_Fsm <= '0';
         sTxShift <= '1';
         sSPI_ClkRst <= '0';
         sCntRst_n <= '1';
         if (sCounterInt = (sBitCount + kCommandWidth + 1)) then
            sSPI_ClkRst <= '1';
            sNextState <= StDone;
         end if;
                
      when StDone => --signal SPI instruction complete
         --fsm_state <= "0101";
         sDoneFsm <= '1';
         sNextState <= StAssertCS;
                
      when StAssertCS => --hold CS high for at least kCS_PulseWidthHigh SysClk100 cycles
         --fsm_state <= "0111";
         sCntRst_n <= '1';
         sDoneCntEn <= '1';
         if (sCounterInt = kCS_PulseWidthHigh) then 
            sNextState <= StIdle;
         end if;                
                     
      when others =>
         --fsm_state <= (others => '1');
         sNextState <= StIdle;
   end case;      
end process;    
           
end Behavioral;      