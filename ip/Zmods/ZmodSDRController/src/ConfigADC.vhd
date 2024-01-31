
-------------------------------------------------------------------------------
--
-- File: ConfigADC.vhd
-- Author: Tudor Gherman, Robert Bocos
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
-- This module writes an intial configuration into the ADC registers and then
-- manages the optional SPI Indirect Access Port.
--  
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.PkgZmodDigitizer.all;

entity ConfigADC is
   Generic (
      -- Parameter identifying the Zmod:    
      -- 6 -> Zmod Digitizer 1430 - 125 (AD9648)
      kZmodID : integer range 6 to 6 := 6;
      -- ADC Clock divider ratio (Register 0x0B of AD96xx and AD92xx).
      kADC_ClkDiv : integer range 1 to 8 := 1;
      --The number of data bits for the data phase of the SPI transaction: 
      --only 8 data bits currently supported.
      kDataWidth : integer range 8 to 8 := 8;
      --The number of bits of the command phase of the SPI transaction.
      kCommandWidth : integer range 16 to 16 := 16;
      kSimulation : boolean := false
   );
   Port (
      -- 100MHZ clock input. 
      SysClk100 : in STD_LOGIC;
      -- Reset signal asynchronously asserted and synchronously 
      -- de-asserted (in SysClk100 domain).
      asRst_n : in STD_LOGIC;
      -- ADC initialization complete signaling
      sInitDoneADC : out STD_LOGIC := '0';
      -- ADC initialization error signaling 
      sConfigError : out STD_LOGIC;
      -- ADC initialization enable signal
      --Configuration of the ADC over SPI should be done after sConfigADCEnable is asserted which only happens after the CDCE clock generator is configured
      --and the PLL inside the CDCE is locked, otherwise the ADC should be kept in reset
      sConfigADCEnable : in STD_LOGIC;
      --AD9648 SPI interface signals
      sADC_Sclk : out STD_LOGIC;  
      sADC_SDIO : inout STD_LOGIC;
      sADC_CS : out STD_LOGIC := '1';
      -- SPI Indirect access port; it provides the means to indirectly access
      -- the ADC registers. It is designed to interface with 2 AXI StreamFIFOs, 
      -- one that stores commands to be transmitted and one to store the received data.
      sCmdTxAxisTvalid: IN STD_LOGIC;
      sCmdTxAxisTready: OUT STD_LOGIC;
      sCmdTxAxisTdata: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      sCmdRxAxisTvalid: OUT STD_LOGIC;
      sCmdRxAxisTready: IN STD_LOGIC;
      sCmdRxAxisTdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
   );
end ConfigADC;

architecture Behavioral of ConfigADC is

signal sCurrentState : FsmStatesADC_t := StStart; 
signal sNextState : FsmStatesADC_t;
-- signals used for debug purposes
-- signal fsmcfg_state, fsmcfg_state_r : std_logic_vector(5 downto 0);
--External Command FIFO Interface
signal sLdCmdTxData: std_logic;
signal sCmdTxDataReg: std_logic_vector(23 downto 0);
signal sCmdTxAxisTreadyLoc: std_logic;
signal sCmdRxAxisTvalidLoc: std_logic;
signal sCmdRxAxisTdataLoc :  STD_LOGIC_VECTOR(7 DOWNTO 0);

signal sCmdCnt : unsigned(4 downto 0);
signal sCmdCntInt : integer range 0 to 31;
signal sIncCmdCnt, sRstCmdCnt : std_logic;
--Initialization complete and configuration error flags
signal sInitDoneADC_Fsm : std_logic := '0';
signal sConfigErrorFsm : std_logic;
--Timers
signal sCfgTimer : unsigned (kCountResetResume'range);
signal sCfgTimerRst_n : std_logic;
--SPI Interface
signal sADC_SPI_RdData : std_logic_vector(kDataWidth-1 downto 0);
signal sADC_SPI_Done : std_logic;
signal sADC_SPI_WrData, sADC_SPI_WrDataR : std_logic_vector(kDataWidth-1 downto 0);
signal sADC_SPI_Addr, sADC_SPI_AddrR : std_logic_vector(kCommandWidth - 4 downto 0);
signal sADC_SPI_Width, sADC_SPI_WidthR : std_logic_vector(1 downto 0);
signal sADC_SPI_RdWr, sADC_SPI_RdWrR : std_logic;
signal sADC_SPI_Busy : std_logic;
signal sADC_ApStart, sADC_ApStartR : std_logic;
signal sCountResetResumeVal : unsigned(kCountResetResume'range);

constant kCmdTotal : integer := SelCmdWrListLength(kZmodID);
constant kADC_SPI_CmdDef : ADC_SPI_Commands_t := SelCmdList(kZmodID);
constant kADC_SPI_RdbckDef : ADC_SPI_Readback_t := SelRdbkList(kZmodID);
constant kADC_SPI_Cmd : ADC_SPI_Commands_t := OverwriteClkDiv(kADC_SPI_CmdDef, kADC_ClkDiv);
constant kADC_SPI_Rdbck : ADC_SPI_Readback_t := OverWriteID_ClkDiv(kZmodID, kADC_SPI_RdbckDef, kADC_ClkDiv);

attribute DONT_TOUCH : string;
    attribute DONT_TOUCH of sCurrentState, sNextState : signal is "TRUE";

begin

sCountResetResumeVal <= kCountResetResumeSim when kSimulation else
						kCountResetResume;

-- Instantiate the SPI controller.
ADC_SPI_inst: entity work.ADI_SPI
Generic Map(
        kSysClkDiv => kSPI_SysClkDiv, 
        kDataWidth => kSPI_DataWidth,
        kCommandWidth => kSPI_CommandWidth
) 
Port Map( 
    --
    SysClk100 => SysClk100,
    asRst_n => asRst_n,
    sSPI_Clk => sADC_Sclk,
    sSDIO => sADC_SDIO,
    sCS => sADC_CS,
    sApStart => sADC_ApStartR,
    sRdData => sADC_SPI_RdData,
    sWrData => sADC_SPI_WrDataR,
    sAddr => sADC_SPI_AddrR,
    sWidth => sADC_SPI_WidthR, --tested only for width = "00"
    sRdWr => sADC_SPI_RdWrR,
    sDone => sADC_SPI_Done,
    sBusy => sADC_SPI_Busy
    );    

-- Register the SPI controller inputs.
ProcSPI_ControllerRegister: process (SysClk100, asRst_n)
begin
   if (asRst_n = '0') then
      sADC_SPI_RdWrR <= '0';
      sADC_SPI_WrDataR <= (others => '0');
      sADC_SPI_AddrR <= (others => '0');
      sADC_SPI_WidthR <= (others => '0');
      sADC_ApStartR <= '0';
   elsif (rising_edge(SysClk100)) then
      sADC_SPI_RdWrR <= sADC_SPI_RdWr;
      sADC_SPI_WrDataR <= sADC_SPI_WrData;
      sADC_SPI_AddrR <= sADC_SPI_Addr;
      sADC_SPI_WidthR <= sADC_SPI_Width;
      sADC_ApStartR <= sADC_ApStart;       
   end if;
end process;

sCmdCntInt <= to_integer(sCmdCnt);

-- Register the SPI Indirect Access Port receive interface outputs.
ProcRxExtFIFO_Reg: process (SysClk100, asRst_n) 
begin
   if (asRst_n = '0') then
      sCmdRxAxisTvalid <= '0';
      sCmdRxAxisTdata <= (others => '0');
   elsif (rising_edge(SysClk100)) then
      sCmdRxAxisTvalid <= sCmdRxAxisTvalidLoc;
      sCmdRxAxisTdata <= x"000000" & sCmdRxAxisTdataLoc;       
   end if;
end process; 

-- Register the SPI Indirect Access Port transmit interface outputs. 
ProcCmdAxisTreadyReg: process (SysClk100, asRst_n)  
begin
   if (asRst_n = '0') then
      sCmdTxAxisTready <= '0';
   elsif (rising_edge(SysClk100)) then
      sCmdTxAxisTready <= sCmdTxAxisTreadyLoc;  
    end if;
end process;

-- Register the next SPI Indirect Access Port command on the transmit
-- interface when the configuration state machine is capable of processing it. 
ProcLdCmdTxData: process (SysClk100, asRst_n) 
begin
   if (asRst_n = '0') then
      sCmdTxDataReg <= (others => '0');
   elsif (rising_edge(SysClk100)) then
        if (sLdCmdTxData = '1') then
           sCmdTxDataReg <= sCmdTxAxisTdata(23 downto 0);
        end if;
    end if;
end process; 

-- Timer used to determine timeout conditions for SPI transfers.
-- When a command is sent to the ADC a certain amount of time is allowed for the state
-- machine to read back the expected value in order to make sure the register was correctly
-- configured. Some commands do not take effect immediately, so this mechanism is necessary
-- (SPI Port Config register (address 0x00) soft reset write for example).
ProcCfgTimer: process (SysClk100, asRst_n)   
begin
   if (asRst_n = '0') then
      sCfgTimer <= (others =>'0');
   elsif (rising_edge(SysClk100)) then
      if (sCfgTimerRst_n = '0') then
         sCfgTimer <= (others =>'0');
      else
         sCfgTimer <= sCfgTimer + 1;     
      end if;
   end if;
end process;

-- Counter used to track the number of successfully sent commands.    
ProcCmdCounter: process (SysClk100, asRst_n) 
begin
   if (asRst_n = '0') then
      sCmdCnt <= (others => '0');
   elsif (rising_edge(SysClk100)) then
      if (sRstCmdCnt = '0') then
         sCmdCnt <= (others => '0');
      elsif (sIncCmdCnt = '1') then
         sCmdCnt <= sCmdCnt + 1;
      end if;        
   end if;
end process;

-- Register FSM output flags.  
ProcInitDoneReg: process (SysClk100, asRst_n) 
begin
   if (asRst_n = '0') then
      sInitDoneADC <= '0';
      sConfigError <= '0';
   elsif (rising_edge(SysClk100)) then
      sInitDoneADC <= sInitDoneADC_Fsm;
      sConfigError <= sConfigErrorFsm;  
    end if;
end process;

------------------------------------------------------------------------------------------
-- ADC Configuration state machine
------------------------------------------------------------------------------------------ 

-- State machine synchronous process.
ProcSyncFsm: process (SysClk100, asRst_n)
begin
   if (asRst_n = '0') then
      sCurrentState <= StStart;
      --fsmcfg_state_r <= (others => '0');
   elsif (rising_edge(SysClk100)) then
      sCurrentState <= sNextState;
      --fsmcfg_state_r <= fsmcfg_state;   
   end if;
end process;

-- Next state and output decode.       
ProcNextStateAndOutputDecode: process (sCurrentState, sADC_SPI_RdData, sADC_SPI_Done, sADC_SPI_Busy, 
sCmdTxAxisTvalid, sCmdTxAxisTdata, sCmdTxDataReg, sCmdRxAxisTready, sCmdCntInt, sCfgTimer, sConfigADCEnable,
sCountResetResumeVal)
begin         
   sNextState <= sCurrentState;  
   --fsmcfg_state <= "000000";
   sADC_ApStart <= '0';
   sADC_SPI_WrData <= (others => '0');
   sADC_SPI_Addr <= (others => '0');
   sADC_SPI_Width <= (others => '0');
   sADC_SPI_RdWr <= '0';
   sRstCmdCnt <= '0';
   sIncCmdCnt <= '0';
   sLdCmdTxData <= '0';

   sCfgTimerRst_n <= '0';
   sInitDoneADC_Fsm <= '0';
   sConfigErrorFsm <= '0';
         
   sCmdTxAxisTreadyLoc <= '0';
   sCmdRxAxisTvalidLoc  <= '0';
   sCmdRxAxisTdataLoc  <= (others => '0');
                  
   case (sCurrentState) is
      when StStart =>
         --fsmcfg_state <= "000000";
         if (sConfigADCEnable = '1') then
            sNextState <= StWriteControlReg;
         end if;
         
         -- Perform a register write operation for the sCmdCntInt'th command in the queue.
         -- For some sCmdCntInt only register reads are required.         
         when StWriteControlReg => 
            sRstCmdCnt <= '1';
            sCfgTimerRst_n <= '1';
            --fsmcfg_state <= "000001";
            if (kADC_SPI_Cmd(sCmdCntInt)(20 downto 8) = kChipID) then --Read ID skips register write
               sNextState <= StReadControlReg;
            elsif (sADC_SPI_Busy = '0') then
               sADC_ApStart <= '1';
               sADC_SPI_WrData <= kADC_SPI_Cmd(sCmdCntInt)(7 downto 0);
               sADC_SPI_Addr <= kADC_SPI_Cmd(sCmdCntInt)(20 downto 8);
               sADC_SPI_Width <= kADC_SPI_Cmd(sCmdCntInt)(22 downto 21);
               sADC_SPI_RdWr  <= '0';
               sNextState <= StWaitDoneWriteReg;
            end if;  
         
         -- Wait for register write command to be completed             
         when StWaitDoneWriteReg => 
            --fsmcfg_state <= "000010";
            sRstCmdCnt <= '1';
            sCfgTimerRst_n <= '1';
            if (sADC_SPI_Done = '1') then
               -- AD92xx devices require a Transfer register write operation
               -- for the previous register write to take effect.
               if ((kZmodID = kZmodDigitizer1030_40) or (kZmodID = kZmodDigitizer1230_40) or (kZmodID = kZmodDigitizer1430_40)) then
                  sNextState <= StReadTrsfReg;
               else
                  sNextState <= StReadControlReg;
               end if;   
            end if;

         -- Read Transfer register and check if it is cleared.  
         when StReadTrsfReg => 
            --fsmcfg_state <= "101110";
            sRstCmdCnt <= '1';
            sCfgTimerRst_n <= '1';
            if (sADC_SPI_Busy = '0') then
               sADC_ApStart <= '1';
               sADC_SPI_Addr <= kSetTrsfReg(20 downto 8);
               sADC_SPI_Width <= kSetTrsfReg(22 downto 21);
               sADC_SPI_RdWr <= '1';
               sNextState <= StWaitDoneTrsfRegRd;
            end if; 
         
         -- Wait for Transfer register read command to complete.   
         when StWaitDoneTrsfRegRd => 
            --fsmcfg_state <= "101111";
            sRstCmdCnt <= '1';
            sCfgTimerRst_n <= '1';
            if (sADC_SPI_Done = '1') then
               -- Check if the expected value has been read; A timeout limit
               -- is imposed.
               if (sADC_SPI_RdData = x"00") then
                  sNextState <= StSetTrsfReg;
               elsif (sCfgTimer >= kCfgTimeout) then 
                  sNextState <= StError;
               else
                  sNextState <= StReadTrsfReg;
               end if;
            end if;  
         
         -- Set the Transfer field of the Transfer register.   
         when StSetTrsfReg => 
            sRstCmdCnt <= '1';
            sCfgTimerRst_n <= '1';
            --fsmcfg_state <= "101010";
            if (sADC_SPI_Busy = '0') then
               sADC_ApStart <= '1';
               sADC_SPI_WrData <= kSetTrsfReg(7 downto 0);
               sADC_SPI_Addr <= kSetTrsfReg(20 downto 8);
               sADC_SPI_Width <= kSetTrsfReg(22 downto 21);
               sADC_SPI_RdWr  <= '0';
               sNextState <= StWaitDoneTrsfReg;
            end if;  
            
         -- Wait for SPI command to be completed.   
         when StWaitDoneTrsfReg => 
            --fsmcfg_state <= "101011";
            sRstCmdCnt <= '1';
            sCfgTimerRst_n <= '1';
            if (sADC_SPI_Done = '1') then
               sNextState <= StReadControlReg;
            end if;
         
         -- Read back the register value configured in the StWriteControlReg state.              
         when StReadControlReg => 
            --fsmcfg_state <= "000110";
            sRstCmdCnt <= '1';
            sCfgTimerRst_n <= '1';
            if (sADC_SPI_Busy = '0') then
               sADC_ApStart <= '1';
               sADC_SPI_Addr <= kADC_SPI_Cmd(sCmdCntInt)(20 downto 8);
               sADC_SPI_Width <= kADC_SPI_Cmd(sCmdCntInt)(22 downto 21);
               sADC_SPI_RdWr <= '1';
               sNextState <= StWaitDoneReadReg;
            end if; 
         
         -- Wait for SPI command to be completed and compare the read data against 
         -- the expected value (the kADC_SPI_Rdbck readback sequence)   
         when StWaitDoneReadReg => 
            --fsmcfg_state <= "000111";
            sRstCmdCnt <= '1';
            sCfgTimerRst_n <= '1';
            if (sADC_SPI_Done = '1') then
               -- Wait for bits that are set/reset by the ADC to change value
               -- (Reg00 soft reset for example). Amount of time not specified by data sheet,
               -- the timeout value chosen empirically. 
               if (sADC_SPI_RdData = kADC_SPI_Rdbck(sCmdCntInt)) then
                  sNextState <= StCheckCmdCnt;
               elsif (sCfgTimer >= kCfgTimeout) then 
                  sNextState <= StError;
               else
                  sNextState <= StReadControlReg;
               end if;
            end if;  
         
         -- Check if the command sequence has completed.     
         when StCheckCmdCnt => 
            --fsmcfg_state <= "000011";
            sRstCmdCnt <= '1';
            if (sCmdCntInt = kCmdTotal) then 
               sRstCmdCnt <= '0';
               sNextState <= StResetTimer;
            else
               sIncCmdCnt <= '1';
               sNextState <= StWriteControlReg;       
            end if;   
         
         -- Reset timeout timer.                   
         when StResetTimer =>  
            --fsmcfg_state <= "001001";
            sNextState <= StWaitRecover;
                
         -- Wait to recover form power down mode.       
         when StWaitRecover =>  
            --fsmcfg_state <= "001010";
            sCfgTimerRst_n <= '1';
            if (sCfgTimer = sCountResetResumeVal) then
               sNextState <= StInitDone;
            end if;
         
         -- Indicate that the initialization sequence has completed.                   
         when StInitDone =>  
            --fsmcfg_state <= "001011";
            sInitDoneADC_Fsm <= '1';
            sNextState <= StIdle;
         
         -- IDLE state; wait for changes on the SPI Indirect Access Port.     
         when StIdle =>  
            --fsmcfg_state <= "001100";
            sInitDoneADC_Fsm <= '1';
            if ((sCmdTxAxisTvalid = '1') and (sADC_SPI_Busy = '0')) then
               sLdCmdTxData <= '1';
               if (sCmdTxAxisTdata(23) = '0') then
                  sNextState <= StExtSPI_WrCmd; 
               else
                  sNextState <= StExtSPI_RdCmd; 
               end if; 
            end if;
         
         -- Execute the register write command requested on the SPI Indirect Access Port.                       
         when StExtSPI_WrCmd =>  
            --fsmcfg_state <= "001101";
            sInitDoneADC_Fsm <= '1';
            sADC_ApStart <= '1';
            sADC_SPI_WrData <= sCmdTxDataReg(7 downto 0);
            sADC_SPI_Addr <= sCmdTxDataReg(20 downto 8);
            sADC_SPI_Width <= sCmdTxDataReg(22 downto 21);
            sADC_SPI_RdWr  <= '0';
            sNextState <= StWaitDoneExtWrReg;  
         
         -- Wait for the register write command to complete   
         when StWaitDoneExtWrReg => 
            --fsmcfg_state <= "001110";
            sInitDoneADC_Fsm <= '1';
            if (sADC_SPI_Done = '1') then
               sCmdTxAxisTreadyLoc <= '1';
               sNextState <= StIdle;
            end if;
         
         -- Execute the register read command requested on the SPI Indirect Access Port.                                  
         when StExtSPI_RdCmd =>  
            --fsmcfg_state <= "001111";
            sInitDoneADC_Fsm <= '1';
            sADC_ApStart <= '1';
            sADC_SPI_Addr <= sCmdTxDataReg(20 downto 8);
            sADC_SPI_Width <= sCmdTxDataReg(22 downto 21);
            sADC_SPI_RdWr <= '1';
            sNextState <= StWaitDoneExtRdReg;
         
         -- Wait for the register read command to complete.  
         when StWaitDoneExtRdReg => 
            --fsmcfg_state <= "010000";
            sInitDoneADC_Fsm <= '1';
            if (sADC_SPI_Done = '1') then
               sCmdTxAxisTreadyLoc <= '1';
               sNextState <= StRegExtRxData;
            end if;
         
         -- State used to register the incoming SPI data.       
         when StRegExtRxData => 
            --fsmcfg_state <= "010001";
            sInitDoneADC_Fsm <= '1';
            sCmdRxAxisTvalidLoc  <= '1';
            sCmdRxAxisTdataLoc  <= sADC_SPI_RdData;
            if (sCmdRxAxisTready = '1') then
               sNextState <= StIdle;
            end if;  
             
         -- When an error condition is detected the state machine stalls in this state.
         -- An external reset condition is necessary to exit this state.                                   
         when StError => 
            --fsmcfg_state <= "111111";
            sConfigErrorFsm <= '1';
            report "ADC Configuration readback error." & LF & HT & HT 
            severity ERROR;
                                                   
         when others =>
            sNextState <= StStart;
         end case;      
end process; 
      
end Behavioral;
