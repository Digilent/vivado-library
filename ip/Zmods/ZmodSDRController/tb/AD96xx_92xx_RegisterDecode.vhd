
-------------------------------------------------------------------------------
--
-- File: AD96xx_92xx_RegisterDecode.vhd
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
-- This module implements the register set for the AD96xx and AD92xx
-- simulation models
--  
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.PkgZmodDigitizer.all;

entity AD96xx_92xx_RegisterDecode is
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
      -- Register address width
      kAddrWidth : integer range 0 to 32 := 13;
      -- Register data width: only 8 data bits currently supported
      kRegDataWidth : integer range 0 to 32 := 8
   );
   Port (   
      -- 100MHZ clock input
      SysClk100 : in STD_LOGIC;
      -- Reset signal asynchronously asserted and synchronously 
      -- de-asserted (in SysClk100 domain) 
      asRst_n : in STD_LOGIC;
      -- When InsertError is asserted the model produces an erroneous reading for register address x01
      InsertError : in STD_LOGIC;  
      -- Signal indicating that the data phase of he register write SPI transaction is completed and aDataDecode is valid      
      sDataWriteDecodeReady : in STD_LOGIC;
      -- Signal indicating that the address phase of the SPI transaction is completed and aAddrDecode is valid
      sAddrDecodeReady : in STD_LOGIC;
      -- Input register data used to update internal egister values for write register operations
      sDataDecode : in STD_LOGIC_VECTOR (kRegDataWidth-1 downto 0); 
      -- Register address input 
      sAddrDecode : in STD_LOGIC_VECTOR (kAddrWidth-1 downto 0);
      -- Output register data produced by this module upon address decode for register read operations
      sRegDataOut : out STD_LOGIC_VECTOR (kRegDataWidth-1 downto 0)
   );
end AD96xx_92xx_RegisterDecode;

architecture Behavioral of AD96xx_92xx_RegisterDecode is

signal sAddrDecodeReadyPulse, sAddrDecodeReadyDly : std_logic := '0';
signal sDataWriteDecodeReadyPulse, sDataWriteDecodeReadyDly : std_logic := '0';
signal sReg00 : std_logic_vector(7 downto 0) := x"18";
signal sReg01 : std_logic_vector(7 downto 0) := SelADC_ID(kZmodID);
signal sReg02 : std_logic_vector(7 downto 0) := SelADC_Grade(kZmodID);
signal sReg05 : std_logic_vector(7 downto 0) := x"03";
signal sRegFF : std_logic_vector(7 downto 0) := x"00";
signal sReg08ChA : std_logic_vector(7 downto 0) := x"00";
signal sReg08ChB : std_logic_vector(7 downto 0) := x"00";
signal sReg09 : std_logic_vector(7 downto 0) := x"01";
signal sReg0B : std_logic_vector(7 downto 0) := x"00";
signal sReg0C : std_logic_vector(7 downto 0) := x"00";
signal sReg0DChA : std_logic_vector(7 downto 0) := x"00";
signal sReg0DChB : std_logic_vector(7 downto 0) := x"00";
signal sReg10ChA : std_logic_vector(7 downto 0) := x"00";
signal sReg10ChB : std_logic_vector(7 downto 0) := x"00";
signal sReg14ChA : std_logic_vector(7 downto 0) := x"00";
signal sReg14ChB : std_logic_vector(7 downto 0) := x"00";
signal sReg15 : std_logic_vector(7 downto 0) := x"00";
signal sReg16 : std_logic_vector(7 downto 0) := x"00";
signal sReg17 : std_logic_vector(7 downto 0) := x"00";
signal sReg18 : std_logic_vector(7 downto 0) := x"04";
signal sReg19 : std_logic_vector(7 downto 0) := x"00";
signal sReg1A : std_logic_vector(7 downto 0) := x"00";
signal sReg1B : std_logic_vector(7 downto 0) := x"00";
signal sReg1C : std_logic_vector(7 downto 0) := x"00";
signal sReg2A : std_logic_vector(7 downto 0) := x"01";
signal sReg2EChA : std_logic_vector(7 downto 0) := x"01";
signal sReg2EChB : std_logic_vector(7 downto 0) := x"01";
signal sReg3A : std_logic_vector(7 downto 0) := x"01";
signal sReg100 : std_logic_vector(7 downto 0) := x"00";
signal sReg101 : std_logic_vector(7 downto 0) := x"80";
signal sReg102 : std_logic_vector(7 downto 0) := x"00";

signal sReg00_TimerRst_n : std_logic;
signal sResetReg00 : std_logic;
signal sReg00_Timer : unsigned (23 downto 0);
signal sAddrAux : integer range 0 to 511;

begin

sAddrAux <= to_integer (unsigned (std_logic_vector'((sAddrDecode))));

-- The following section generates a pulse when sAddrDecodeReady is asserted.
-- This pulse indicates that the command phase of the SPI read transaction is
-- completed and that sAddrDecode contains valid data.
ProcAddrDecodeDly: process (SysClk100, asRst_n)   
begin
   if (asRst_n = '0') then
      sAddrDecodeReadyDly <= '0';
   elsif (rising_edge(SysClk100)) then
      sAddrDecodeReadyDly <= sAddrDecodeReady;
    end if;
end process;

sAddrDecodeReadyPulse <= sAddrDecodeReady and (not sAddrDecodeReadyDly);

-- Timer used to reset the soft reset bit of the SPI port config register
-- (Reg00).
ProcReg00Timer: process (SysClk100, asRst_n)   
begin
   if (asRst_n = '0') then
      sReg00_Timer <= (others => '0');
   elsif (rising_edge(SysClk100)) then
      if (sReg00_TimerRst_n = '0') then
         sReg00_Timer <= (others => '0');
      else
         sReg00_Timer <= sReg00_Timer + 1;     
      end if;
   end if;
end process;

-- If the soft reset bit of Reg00 is set over the command interface, it is reset by the AD96xx when the
-- reset operation completes. The amount of time required not specified (20us considered for this model).
ProcResetReg00: process (SysClk100, asRst_n)   
begin
   if (asRst_n = '0') then
      sResetReg00 <= '0';
   elsif (rising_edge(SysClk100)) then
      if (sReg00_Timer = kCountResetResumeSim) then
         sResetReg00 <= '1';
      else
         sResetReg00 <= '0';     
      end if;
   end if;
end process;

-- Process managing register read operations 
ReadRegister: process(SysClk100, asRst_n)
begin
if (asRst_n = '0') then
   sRegDataOut <= (others => '0');
elsif (rising_edge (SysClk100)) then
    if (sAddrDecodeReadyPulse = '1') then
        case (sAddrDecode) is
        when "0000000000000" =>
            sRegDataOut <= sReg00;
        when "0000000000001" =>
            if (InsertError = '0') then
                sRegDataOut <= sReg01;
            else
                sRegDataOut <= x"00";
            end if;
        when "0000000000010" =>
            sRegDataOut <= sReg02;        
        when "0000000000101" =>
            sRegDataOut <= sReg05;
        when "0000011111111" =>
            sRegDataOut <= sRegFF;
        when "0000000001000" =>
            if (sReg05(1 downto 0) = "00") then
                sRegDataOut <= x"00";
                report "Attempt to read local register (x08) with device index set to b00." & LF & HT & HT
                severity ERROR;
            elsif (sReg05(1 downto 0) = "01") then
                sRegDataOut <= sReg08ChA;
            elsif (sReg05(1 downto 0) = "10") then
                sRegDataOut <= sReg08ChB;
            elsif (sReg05(1 downto 0) = "11") then
                sRegDataOut <= x"00";
                report "Attempt to read local register (x08) with device index set to b11." & LF & HT & HT
                severity ERROR;            
            end if;
        when "0000000010001" =>
            sRegDataOut <= sReg09;
        when "0000000001011" =>
            sRegDataOut <= sReg0B;
        when "0000000001100" =>
            sRegDataOut <= sReg0C;
        when "0000000001101" =>
            if (sReg05(1 downto 0) = "00") then
                sRegDataOut <= x"00";
                report "Attempt to read local register (x0D) with device index set to b00." & LF & HT & HT
                severity ERROR;
            elsif (sReg05(1 downto 0) = "01") then
                sRegDataOut <= sReg0DChA;
            elsif (sReg05(1 downto 0) = "10") then
                sRegDataOut <= sReg0DChB;
            elsif (sReg05(1 downto 0) = "11") then
                sRegDataOut <= x"00";
                report "Attempt to read local register (x0D) with device index set to b11." & LF & HT & HT
                severity ERROR;            
            end if;
        when "0000000010000" =>
            if (sReg05(1 downto 0) = "00") then
                sRegDataOut <= x"00";
                report "Attempt to read local register (x10) with device index set to b00." & LF & HT & HT
                severity ERROR;
            elsif (sReg05(1 downto 0) = "01") then
                sRegDataOut <= sReg10ChA;
            elsif (sReg05(1 downto 0) = "10") then
                sRegDataOut <= sReg10ChB;
            elsif (sReg05(1 downto 0) = "11") then
                sRegDataOut <= x"00";
                report "Attempt to read local register (x10) with device index set to b11." & LF & HT & HT
                severity ERROR;            
            end if;
        when "0000000010100" =>
            if (sReg05(1 downto 0) = "00") then
                sRegDataOut <= x"00";
                report "Attempt to read local register (x14) with device index set to b00." & LF & HT & HT
                severity ERROR;
            elsif (sReg05(1 downto 0) = "01") then
                sRegDataOut <= sReg14ChA;
            elsif (sReg05(1 downto 0) = "10") then
                sRegDataOut <= sReg14ChB;
            elsif (sReg05(1 downto 0) = "11") then
                sRegDataOut <= x"00";
                report "Attempt to read local register (x14) with device index set to b11." & LF & HT & HT
                severity ERROR;            
            end if;
        when "0000000010101" =>
            sRegDataOut <= sReg15;
        when "0000000010110" =>
            sRegDataOut <= sReg16;
        when "0000000010111" =>
            sRegDataOut <= sReg17;
        when "0000000011000" =>
            sRegDataOut <= sReg18;
        when "0000000011001" =>
            sRegDataOut <= sReg19;
        when "0000000011010" =>
            sRegDataOut <= sReg1A;
        when "0000000011011" =>
            sRegDataOut <= sReg1B;
        when "0000000011100" =>
            sRegDataOut <= sReg1C;
        when "0000000101010" =>
            sRegDataOut <= sReg2A;
        when "0000000101110" =>
            if (sReg05(1 downto 0) = "00") then
                sRegDataOut <= x"00";
                report "Attempt to read local register (x14) with device index set to b00." & LF & HT & HT
                severity ERROR;
            elsif (sReg05(1 downto 0) = "01") then
                sRegDataOut <= sReg2EChA;
            elsif (sReg05(1 downto 0) = "10") then
                sRegDataOut <= sReg2EChB;
            elsif (sReg05(1 downto 0) = "11") then
                sRegDataOut <= x"00";
                report "Attempt to read local register (x14) with device index set to b11." & LF & HT & HT
                severity ERROR;            
            end if;
        when "0000000111010" =>
            sRegDataOut <= sReg3A;
        when "0000100000000" =>
            sRegDataOut <= sReg100;
        when "0000100000001" =>
            sRegDataOut <= sReg101;
        when "0000100000010" =>
            sRegDataOut <= sReg102;
        when others =>
            sRegDataOut <= x"00";
            report "Invalid Read Address." & LF & HT & HT
            severity ERROR; 
        end case;
    end if;
end if;            
end process ReadRegister;

-- The following section generates a pulse when sDataWriteDecodeReady is asserted.
-- This pulse indicates that the command phase of the SPI write transaction is
-- completed and that sAddrDecode contains valid data.
ProcDataDecodeDly: process (SysClk100, asRst_n)   
begin
   if (asRst_n = '0') then
      sDataWriteDecodeReadyDly <= '0';
   elsif (rising_edge(SysClk100)) then
      sDataWriteDecodeReadyDly <= sDataWriteDecodeReady;
    end if;
end process;

sDataWriteDecodeReadyPulse <= sDataWriteDecodeReady and (not sDataWriteDecodeReadyDly);

-- Process managing register write operations (Reg00 is treated separately).
WriteRegister: process (SysClk100, asRst_n)
begin
   if (asRst_n = '0') then
      sReg01 <= SelADC_ID(kZmodID);
      sReg02 <= SelADC_Grade(kZmodID);
      sReg05 <= x"03";
      sRegFF <= x"00";
      sReg08ChA <= x"00";
      sReg08ChB <= x"00";
      sReg09 <= x"01";
      sReg0B <= x"00";
      sReg0C <= x"00";
      sReg0DChA <= x"00";
      sReg0DChB <= x"00";
      sReg10ChA <= x"00";
      sReg10ChB <= x"00";
      sReg14ChA <= x"00";
      sReg14ChB <= x"00";
      sReg15 <= x"00";
      sReg16 <= x"00";
      sReg17 <= x"00";
      sReg18 <= x"04";
      sReg19 <= x"00";
      sReg1A <= x"00";
      sReg1B <= x"00";
      sReg1C <= x"00";
      sReg2A <= x"01";
      sReg2EChA <= x"01";
      sReg2EChB <= x"01";
      sReg3A <= x"01";
      sReg100 <=x"00";
      sReg101 <= x"80";
      sReg102 <= x"00";
   elsif (rising_edge (SysClk100)) then    
      if (sDataWriteDecodeReadyPulse = '1') then
         case (sAddrDecode) is
            when "0000000000000" =>
            --Reg00 treated separately
            when "0000000000001" =>
               report "Attempt to write to a READ ONLY location." & integer'image(sAddrAux) & LF & HT & HT
               severity ERROR;  
            when "0000000000010" =>
               report "Attempt to write to a READ ONLY location." & integer'image(sAddrAux) & LF & HT & HT
               severity ERROR;         
            when "0000000000101" =>
                sReg05 <= sDataDecode;
            when "0000011111111" =>
                --The transfer register auto clears in an unspecified amount
                --of time. For the IP simulation purpose this register can be
                --considered constant (x"00").
                --sRegFF <= sDataDecode;
            when "0000000001000" =>
               if (sReg05(1 downto 0) = "00") then
                  report "Attempt to write local register (x08) with device index set to b00." & LF & HT & HT
                  severity ERROR;
               elsif (sReg05(1 downto 0) = "01") then
                  sReg08ChA <= sDataDecode;
               elsif (sReg05(1 downto 0) = "10") then
                  sReg08ChB <= sDataDecode;
               elsif (sReg05(1 downto 0) = "11") then
                  sReg08ChA <= sDataDecode;
                  sReg08ChB <= sDataDecode;            
               end if;            
            when "0000000010001" =>
                sReg09 <= sDataDecode;
            when "0000000001011" =>
                sReg0B <= sDataDecode;
            when "0000000001100" =>
                sReg0C <= sDataDecode;
            when "0000000001101" =>
               if (sReg05(1 downto 0) = "00") then
                  report "Attempt to write local register (x0D) with device index set to b00." & LF & HT & HT
                  severity ERROR;
               elsif (sReg05(1 downto 0) = "01") then
                  sReg0DChA <= sDataDecode;
               elsif (sReg05(1 downto 0) = "10") then
                  sReg0DChB <= sDataDecode;
               elsif (sReg05(1 downto 0) = "11") then
                  sReg0DChA <= sDataDecode;
                  sReg0DChB <= sDataDecode;            
               end if;  
            when "0000000010000" =>
               if (sReg05(1 downto 0) = "00") then
                  report "Attempt to write local register (x10) with device index set to b00." & LF & HT & HT
                  severity ERROR;
               elsif (sReg05(1 downto 0) = "01") then
                  sReg10ChA <= sDataDecode;
               elsif (sReg05(1 downto 0) = "10") then
                  sReg10ChB <= sDataDecode;
               elsif (sReg05(1 downto 0) = "11") then
                  sReg10ChA <= sDataDecode;
                  sReg10ChB <= sDataDecode;            
               end if; 
            when "0000000010100" =>
               sReg14ChA(1 downto 0) <= sDataDecode(1 downto 0);
               sReg14ChB(1 downto 0) <= sDataDecode(1 downto 0);
               sReg14ChA(3) <= sDataDecode(3);
               sReg14ChB(3) <= sDataDecode(3);
               sReg14ChA(7 downto 5) <= sDataDecode(7 downto 5);
               sReg14ChB(7 downto 5) <= sDataDecode(7 downto 5);       
               if (sReg05(1 downto 0) = "00") then
                  report "Attempt to write local register (x10) with device index set to b00." & LF & HT & HT
                  severity ERROR;
               elsif (sReg05(1 downto 0) = "01") then
                  sReg14ChA(2) <= sDataDecode(2);
                  sReg14ChA(4) <= sDataDecode(4);
               elsif (sReg05(1 downto 0) = "10") then
                  sReg14ChB(2) <= sDataDecode(2);
                  sReg14ChB(4) <= sDataDecode(4);
               elsif (sReg05(1 downto 0) = "11") then
                  sReg14ChA(2) <= sDataDecode(2);
                  sReg14ChA(4) <= sDataDecode(4);
                  sReg14ChB(2) <= sDataDecode(2);
                  sReg14ChB(4) <= sDataDecode(4);          
               end if; 
            when "0000000010101" =>
               sReg15 <= sDataDecode;
            when "0000000010110" =>
               sReg16 <= sDataDecode;
            when "0000000010111" =>
               sReg17 <= sDataDecode;
            when "0000000011000" =>
               sReg18 <= sDataDecode;
            when "0000000011001" =>
               sReg19 <= sDataDecode;
            when "0000000011010" =>
               sReg1A <= sDataDecode;
            when "0000000011011" =>
               sReg1B <= sDataDecode;
            when "0000000011100" =>
               sReg1C <= sDataDecode;
            when "0000000101010" =>
               sReg2A <= sDataDecode;
            when "0000000101110" =>
               if (sReg05(1 downto 0) = "00") then
                  report "Attempt to write local register (x2E) with device index set to b00." & LF & HT & HT
                  severity ERROR;
               elsif (sReg05(1 downto 0) = "01") then
                  sReg2EChA <= sDataDecode;
               elsif (sReg05(1 downto 0) = "10") then
                  sReg2EChB <= sDataDecode;
               elsif (sReg05(1 downto 0) = "11") then
                  sReg2EChA <= sDataDecode;
                  sReg2EChB <= sDataDecode;            
               end if;
            when "0000000111010" =>
               sReg3A <= sDataDecode;
            when "0000100000000" =>
               sReg100 <= sDataDecode;
            when "0000100000001" =>
               sReg101 <= sDataDecode;
            when "0000100000010" =>
               sReg102 <= sDataDecode;
            when others =>
               report "Invalid Write Address." & integer'image(sAddrAux) & LF & HT & HT
               severity ERROR;    
         end case;
      end if;
   end if;        
end process WriteRegister;

-- Process managing register write operation for Reg00 individually
WriteRegister00: process (SysClk100, asRst_n)
begin
   if (asRst_n = '0') then
      sReg00 <= x"18";
      sReg00_TimerRst_n <= '0';
   elsif (rising_edge (SysClk100)) then   
      if (sDataWriteDecodeReady = '1') then
         if (sAddrDecode = "0000000000000") then
            sReg00 <= sReg00 or (sDataDecode and aReg00_Mask);
            if (sDataDecode(5) = '1' and sDataDecode(2) = '1') then
               sReg00_TimerRst_n <= '1';
            elsif (sDataDecode(5) = '1' and sDataDecode(2) = '0') then
               report "Reg00 bit 5 and 2 must be mirrored." & LF & HT & HT
               severity ERROR;
            elsif (sDataDecode(5) = '0' and sDataDecode(2) = '1') then
               report "Reg00 bit 5 and 2 must be mirrored." & LF & HT & HT
               severity ERROR;                           
            end if;   
         end if;
      elsif (sResetReg00 = '1') then
         sReg00(5) <= '0';
         sReg00(2) <= '0';
         sReg00_TimerRst_n <= '0';    
      end if;
   end if;        
end process WriteRegister00;

end Behavioral;
