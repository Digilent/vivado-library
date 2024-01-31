
-------------------------------------------------------------------------------
--
-- File: AD96xx_92xxSPI_Model.vhd
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
-- Simulation model for the AD9648 ADC. Currently only the configuration SPI 
-- interface implemented. The following conditions are tested:
-- 1. sSpiClk pulse high and low times are respected
-- 2. sSpiClk maximum and minimum (optional) frequency
-- 3. sCS to sSPI_Clk setup and hold times are respected
-- 4. sCS has no glitches during the 1 data byte transaction supported
-- 5. decodes command word and input data for write transactions
-- 6. generates output data byte for read transactions
-- 7. sSDIO to sSPI_Clk setup and hold times are respected
-- 8. No transitions occur on sSDIO and sCS during the idle state
--  
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.PkgZmodDigitizer.all;

entity AD96xx_92xxSPI_Model is
   Generic (
      -- Parameter identifying the Zmod:
      -- 0 -> Zmod Scope 1410 - 105 (AD9648)       
      -- 1 -> Zmod Scope 1010 - 40 (AD9204)       
      -- 2 -> Zmod Scope 1010 - 125 (AD9608)       
      -- 3 -> Zmod Scope 1210 - 40 (AD9231)       
      -- 4 -> Zmod Scope 1210 - 125 (AD9628)       
      -- 5 -> Zmod Scope 1410 - 40 (AD9251)       
      -- 6 -> Zmod Scope 1410 - 125 (AD9648)
      kZmodID : integer range 0 to 6 := 6;
      -- The number of data bits for the data phase of the transaction: 
      -- only 8 data bits currently supported.
      kDataWidth : integer range 0 to 63 := 8;
      -- The number of bits of the command phase of the SPI transaction.
      kCommandWidth : integer range 0 to 63 := 8
   );
   Port (
      -- 100MHz clock used by the AD9648_RegisterDecode block
      SysClk100 : in STD_LOGIC;
      -- Reset signal asynchronously asserted and synchronously 
      -- de-asserted (in SysClk100 domain)
      asRst_n : in STD_LOGIC;
      -- When InsertError is asserted the model produces an erroneous 
	  -- reading for register address x01
      InsertError : in STD_LOGIC;
           
      -- 2 wire SPI interface 
      sSPI_Clk : in STD_LOGIC;  
      sSDIO : inout STD_LOGIC := 'Z';
      sCS : in STD_LOGIC
   );
end AD96xx_92xxSPI_Model;

architecture Behavioral of AD96xx_92xxSPI_Model is

signal sR_W_Decode : std_logic;
signal sWidthDecode : std_logic_vector(1 downto 0);
signal sAddrDecode : std_logic_vector(kCommandWidth - 4 downto 0);
signal sAddrDecodeReady : std_logic;
signal sDataWriteDecodeReady : std_logic;
signal sTransactionInProgress : boolean := false;
signal sDataDecode : std_logic_vector(kDataWidth-1 downto 0);
signal sSPI_ClkRising : time := 0 ns;
signal sSPI_ClkCounter : integer := 0;
signal sLastSPI_ClkEdge : time := 0ns;
signal sLastSPI_ClkRisingEdge : time := 0ns;
signal sSclkHigh : time := 0ns;
signal sRegDataOut : std_logic_vector(kDataWidth-1 downto 0) := x"00";

begin

AD9648_RegisterDecode_inst: entity work.AD96xx_92xx_RegisterDecode
Generic Map(
    kZmodID => kZmodID, 
    kAddrWidth => kCommandWidth-3,
    kRegDataWidth => kDataWidth
    )  
Port Map(
    SysClk100 => SysClk100,
    asRst_n => asRst_n, 
    InsertError => InsertError,
    sDataWriteDecodeReady => sDataWriteDecodeReady,
    sAddrDecodeReady => sAddrDecodeReady,
    sDataDecode => sDataDecode,
    sAddrDecode => sAddrDecode,
    sRegDataOut => sRegDataOut
    );   

 -- ADC Main process; checks for: 
 -- 1. sSpiClk pulse high and low times are respected.
 -- 2. sSpiClk maximum and minimum (optional) frequency.
 -- 3. sCS to sSPI_Clk setup and hold times are respected.
 -- 4. sCS has no glitches during the 1 data byte transaction supported.
 -- 5. decodes command word and input data for write transactions.
 -- 6. generates output data byte for read transactions.
 -- A sSPI_Clk falling edge is expected before sCS is pulled high.
ADC_Main: process
begin
    sAddrDecodeReady <= '0';
    sDataWriteDecodeReady <= '0'; 
    if (sCS /= '0') then
        wait until sCS = '0';
    end if;
    sSPI_ClkCounter <= 0;
    sTransactionInProgress <= true;
    sSDIO <= 'Z';
    -- Wait for first sSPI_Clk rising edge
    if (sSPI_Clk /= '0') then
        wait until sSPI_Clk = '0';
    end if;
    wait until sSPI_Clk = '1';
    -- First clock rising edge detected
    sSPI_ClkCounter <= sSPI_ClkCounter + 1;
    sLastSPI_ClkRisingEdge <= now;
    sR_W_Decode <= sSDIO;
    -- Check sCS to sSPI_Clk setup time
    assert ((sCS'delayed'last_event)  >= ktS)
        report "setup time between sCS and sSPI_Clk is smaller than minimum allowed." & LF & HT & HT &
               "Expected: " & time'image(ktS) & LF & HT & HT &
               "Actual: " & time'image(sCS'delayed'last_event)
        severity ERROR;
    -- Check sSPI_Clk pulse width high for MSB
    wait until sSPI_Clk = '0';
    assert ((sSPI_Clk'delayed'last_event)  >= kSclkHigh)
    report "sSPI_Clk pulse width high is smaller than minimum allowed for command MSB." & LF & HT & HT &
           "Expected: " & time'image(kSclkHigh) & LF & HT & HT &
           "Actual: " & time'image(sSPI_Clk'delayed'last_event)
    severity ERROR;
    sSclkHigh <= sSPI_Clk'delayed'last_event;
    -- Repeat for the following kCommandWidth-1 sSPI_Clk periods
    for i in (kCommandWidth - 2) downto 0 loop
        wait until sSPI_Clk = '1';
        sSPI_ClkCounter <= sSPI_ClkCounter + 1;
        sLastSPI_ClkRisingEdge <= now;
        -- Check sSPI_Clk pulse width low
        assert ((sSPI_Clk'delayed'last_event)  >= kSclkLow)
        report "sSPI_Clk pulse width low is smaller than minimum allowed for command bit" & integer'image(i+1) & LF & HT & HT &
               "Expected: " & time'image(kSclkLow) & LF & HT & HT &
               "Actual: " & time'image(sSPI_Clk'delayed'last_event)
        severity ERROR;
        
        -- Check sSPI_Clk frequency (measure between two consecutive rising edges) is smaller than the max allowed
        assert ((sSPI_Clk'delayed'last_event + sSclkHigh)  >= kSclkT_Min)
        report "sSPI_Clk period is smaller than the minimum allowed for command bit" & integer'image(i+1) & LF & HT & HT &
               "Expected: " & time'image(kSclkT_Min) & LF & HT & HT &
               "Actual: " & time'image(sSPI_Clk'delayed'last_event + sSclkHigh)
        severity ERROR;
        
        -- Check sSPI_Clk frequency (measure between two consecutive rising edges) is higher than the min allowed
--        assert ((aSclkLow + sSclkHigh)  <= kSclkT_Max)
--        report "sSPI_Clk period is higher than the maximum allowed." & LF & HT & HT &
--               "Expected: " & time'image(kSclkT_Max) & LF & HT & HT &
--               "Actual: " & time'image(aSclkLow + sSclkHigh)
--        severity ERROR;
        
        if (i = kCommandWidth - 2) then
            sWidthDecode(1) <= sSDIO;
        elsif (i = kCommandWidth - 3) then
            sWidthDecode(0) <= sSDIO;
        else
            sAddrDecode(i) <= sSDIO;
            if (i=0) then
                sAddrDecodeReady <= '1';
            end if;
        end if;    
        
        -- Wait sSPI_Clk falling edge
        wait until sSPI_Clk = '0';
        -- Check sSPI_Clk pulse width high
        assert ((sSPI_Clk'delayed'last_event)  >= kSclkHigh)
        report "aSCK pulse width high is smaller than minimum allowed for command bit" & integer'image(i)& LF & HT & HT &
               "Expected: " & time'image(kSclkHigh) & LF & HT & HT &
               "Actual: " & time'image(sSPI_Clk'delayed'last_event)
        severity ERROR;
        
        sSclkHigh <= sSPI_Clk'delayed'last_event;
        -- Drive first data byte when bus changes direction
        if (i=0) then
            if (sR_W_Decode = '1') then
                sSDIO <= sRegDataOut(7);
            end if;
            sAddrDecodeReady <= '0';
        end if;            
    end loop;
    
    for i in (kDataWidth - 1) downto 0 loop
        wait until sSPI_Clk = '1';
        sSPI_ClkCounter <= sSPI_ClkCounter + 1;
        sLastSPI_ClkRisingEdge <= now;
        -- Check sSPI_Clk pulse width low
        assert ((sSPI_Clk'delayed'last_event)  >= kSclkLow)
        report "sSPI_Clk pulse width low is smaller than minimum allowed for data bit " & integer'image(i+1) & LF & HT & HT &
               "Expected: " & time'image(kSclkLow) & LF & HT & HT &
               "Actual: " & time'image(sSPI_Clk'delayed'last_event)
        severity ERROR;
        
        -- Check sSPI_Clk frequency (measure between two consecutive rising edges) is smaller than the max allowed
        assert ((sSPI_Clk'delayed'last_event + sSclkHigh)  >= kSclkT_Min)
        report "sSPI_Clk period is smaller than the minimum allowed for data bit " & integer'image(i+1) & LF & HT & HT &
               "Expected: " & time'image(kSclkT_Min) & LF & HT & HT &
               "Actual: " & time'image(sSPI_Clk'delayed'last_event + sSclkHigh)
        severity ERROR;
        
        -- Check sSPI_Clk frequency (measure between two consecutive rising edges) is higher than the min allowed
--        assert ((aSclkLow + sSclkHigh)  <= kSclkT_Max)
--        report "sSPI_Clk period is higher than the maximum allowed." & LF & HT & HT &
--               "Expected: " & time'image(kSclkT_Max) & LF & HT & HT &
--               "Actual: " & time'image(aSclkLow + sSclkHigh)
--        severity ERROR;
        -- Sample sSDIO on rising edge for write operations
        if (sR_W_Decode = '0') then
            sDataDecode(i) <= sSDIO;   
        end if;  
        -- Wait sSPI_Clk falling edge
        wait until sSPI_Clk = '0';
        -- Check sSPI_Clk pulse width high
        assert ((sSPI_Clk'delayed'last_event)  >= kSclkHigh)
        report "aSCK pulse width high is smaller than minimum allowed for data bit" & integer'image(i) & LF & HT & HT &
               "Expected: " & time'image(kSclkHigh) & LF & HT & HT &
               "Actual: " & time'image(sSPI_Clk'delayed'last_event)
        severity ERROR;

        sSclkHigh <= sSPI_Clk'delayed'last_event;
        -- Assign SDIO on falling edge for read operations 
        if (sR_W_Decode = '1') then
            if (i > 0) then
                sSDIO <= sRegDataOut(i-1);
            else
                sSDIO <= 'Z';
            end if;
        else
            if (i=0) then
                sDataWriteDecodeReady <= '1';
            end if;
        end if;           
    end loop;
    
    sLastSPI_ClkEdge <= now;
    sTransactionInProgress <= false; 
    wait until sCS = '1';
    -- Check hold time between SCLK and sCS
    assert ((now - sLastSPI_ClkRisingEdge)  >= ktH)
    report "Hold time (sCS to sSPI_Clk) is smaller than the minimum allowed." & LF & HT & HT &
           "Expected: " & time'image(ktH) & LF & HT & HT &
           "Actual: " & time'image(now - sLastSPI_ClkRisingEdge)
    severity ERROR;
    -- Check if no more than 24 bits transferred 
    assert ((now - sLastSPI_ClkEdge) = sSPI_Clk'last_event)
    report "More than 24 bits transfered for current transaction." & LF & HT & HT 
    severity FAILURE;
    -- Check last sSPI_Clk pulse low duration   
    assert ((now - sLastSPI_ClkEdge)  >= kSclkLow)
    report "aSCK pulse width low is smaller than minimum allowed data bit 0" & LF & HT & HT &
           "Expected: " & time'image(kSclkLow) & LF & HT & HT &
           "Actual: " & time'image(now - sLastSPI_ClkEdge)
    severity ERROR;
    
 end process ADC_Main;
 
 -- Check if sCS low pulse is held low for the entire transaction 
CheckCS: process
begin
    if (sCS /= '0') then
        wait until sCS = '0';
    end if;
    
    wait until sCS = '1';
    assert (sTransactionInProgress  = false)
    report "CS pulse high during transaction." & LF & HT & HT 
    severity FAILURE; 
  
 end process CheckCS;

-- Check if sSDIO to sSPI_Clk setup time is respected 
CheckSetup: process
begin
    if (sSPI_Clk /= '0') then
        wait until sSPI_Clk = '0';
    end if;
    
    wait until sSPI_Clk = '1';
    sSPI_ClkRising <= now;
    -- Check Setup Time
    assert (sSDIO'last_active  >= ktDS)
    report "Setup time (data to sSPI_Clk) is smaller than minimum allowed." & LF & HT & HT &
           "Expected: " & time'image(ktDS) & LF & HT & HT &
           "Actual: " & time'image(sSDIO'last_active)
    severity ERROR; 
  
 end process CheckSetup;

-- Check if sSDIO to sSPI_Clk hold time is respected 
CheckHold: process
begin  
    -- Wait for first clock rising edge
    wait until sSPI_ClkRising /= 0 ns;
    -- Wait for SDIO next bit to be assigned
    wait until sSDIO'event;
    -- Check Hold Time 
    assert ((now - sSPI_ClkRising)  >= ktDH)
    report "Hold time (data to sSPI_Clk) is smaller than minimum allowed." & LF & HT & HT &
           "Expected: " & time'image(ktDH) & LF & HT & HT &
           "Actual: " & time'image(now - sSPI_ClkRising)
    severity ERROR;    
       
 end process CheckHold;

-- Check sSDIO idle condition
CheckSDIO_Idle: process
begin
    wait until now /= 0 ps;  
    if (sCS = '0') then
        wait until sCS = '1';
    end if;
    -- Check that sSDIO is in '0' when entering the idle state
    assert (sSDIO  = '0')
    report "SDIO idle condition not respected." 
    severity WARNING;
    -- Monitor all changes on the sSDIO signal and check if they occur during the idle state (sCS = '1');
    wait until sSDIO'event;
    assert (sCS  = '0')
    report "SDIO idle condition not respected." 
    severity WARNING;
    
end process CheckSDIO_Idle;

CheckSPI_ClkIdle: process
begin  
    wait until now /= 0 ps;
    if (sCS = '0') then
        wait until sCS = '1';
    end if;
    -- Check that sSDIO is in '0' when entering the idle state
    assert (sSPI_Clk  = '0')
    report "sSPI_Clk idle condition not respected." 
    severity WARNING;
    -- Monitor all changes on the sSPI_Clk signal and check if they occur during the idle state (sCS = '1');
    wait until sSPI_Clk'event;
    assert (sCS  = '0')
    report "sSPI_Clk idle condition not respected." 
    severity WARNING;
    
end process CheckSPI_ClkIdle;
  
end Behavioral;