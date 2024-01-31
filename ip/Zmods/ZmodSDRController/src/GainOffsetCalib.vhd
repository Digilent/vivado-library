
-------------------------------------------------------------------------------
--
-- File: GainOffsetCalib.vhd
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
-- This module applies the gain and offset calibration to the raw data samples
-- received from the DataPath module.
--  
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity GainOffsetCalib is
   Generic (
      -- ADC/DAC number of bits
      kWidth : integer range 10 to 16 := 14;
      -- ADC/DAC dynamic/static calibration 
      kExtCalibEn : boolean := false;
      -- When asserted, kInvert determines the sign inversion of the data samples
      -- received. Used to compensate the physical inversion of some of the 
      -- channels on the PCB at the ADC/DAC input/output on the Zmod.
      kInvert : boolean := false;  
      -- Low gain multiplicative (gain) compensation coefficient parameter
      kLgMultCoefStatic : std_logic_vector (17 downto 0) := "010000000000000000";
      -- Low gain additive (offset) compensation coefficient parameter 
      kLgAddCoefStatic : std_logic_vector (17 downto 0) := "000000000000000000";
      -- High gain multiplicative (gain) compensation coefficient parameter 
      kHgMultCoefStatic : std_logic_vector (17 downto 0) := "010000000000000000";
      -- High gain additive (offset) compensation coefficient parameter  
      kHgAddCoefStatic : std_logic_vector (17 downto 0) := "000000000000000000" 
   );
   Port (
      -- Sampling clock 
      SamplingClk : in STD_LOGIC;
      -- Reset signal asynchronously asserted and synchronously 
      -- de-asserted (in the SamplingClk domain)
      acRst_n : in STD_LOGIC;
      -- cTestMode is used to bypass the calibration block. When this signal
      -- is asserted, raw samples are provided on the data interface  
      cTestMode : in STD_LOGIC;
      -- If at the start of the acquisition, this module puts on cCalibDataOut output signal the first acquired and calibrated samples, 
      -- together with cDataCalibValid = '1', but doDataAxisTready is not asserted, in the next clock cycle the value on cCalibDataOut will change, 
      -- since it will take the values of the next calibrated samples. This violates the AXI Stream interface specification.
      -- This signal was added to prevent that. In a top level this signal should be connected to an AXI Stream Slave TREADY signal.
      cDataAcceptanceReady : in STD_LOGIC;
      -- Low gain gain compensation coefficient external port
      cExtLgMultCoef : in std_logic_vector (17 downto 0);
      -- Low gain offset compensation coefficient external port 
      cExtLgAddCoef : in std_logic_vector (17 downto 0);
      -- High gain gain compensation coefficient external port  
      cExtHgMultCoef : in std_logic_vector (17 downto 0);
      -- High gain offset compensation coefficient external port  
      cExtHgAddCoef : in std_logic_vector (17 downto 0);   
      -- Gain Relay State (1 -> High Gain; 0 -> Low Gain)
      cGainState : in std_logic;
      -- Raw data input
      cDataRaw : in STD_LOGIC_VECTOR (kWidth-1 downto 0);
      -- Raw data valid signal
      cDataInValid : in STD_LOGIC;
      -- Calibrated output data
      cCalibDataOut : out STD_LOGIC_VECTOR (15 downto 0);
      -- Output data valid signal 
      cDataCalibValid : out STD_LOGIC
      );
end GainOffsetCalib;

architecture Behavioral of GainOffsetCalib is

signal cDataRaw18bSigned : signed(17 downto 0);
signal cDataRaw18b : std_logic_vector(17 downto 0);
signal cCalibMult : signed(35 downto 0);
signal cCalibAdd : signed(35 downto 0);
signal cCoefAdd : std_logic_vector(35 downto 0);
signal cCoefAddSigned : signed(35 downto 0);
signal cCoefMult : std_logic_vector(17 downto 0);
signal cCoefMultSigned : signed(17 downto 0);
signal cCoefMultLg, cCoefMultHg :  std_logic_vector (17 downto 0);
signal cCoefAddLg, cCoefAddHg : std_logic_vector (17 downto 0);
signal cDataInValidR : STD_LOGIC;
signal cDataCalibValidLoc : std_logic;
signal cCalibDataOutLoc : std_logic_vector(15 downto 0);
signal cFirstWordAccepted : std_logic;

constant kDummy : std_logic_vector (17-kWidth downto 0) := (others => '0');
    
begin

--Channel1 low gain gain compensation coefficient (output port or IP parameter).
cCoefMultLg <= cExtLgMultCoef when kExtCalibEn = true else kLgMultCoefStatic;
--Channel1 high gain gain compensation coefficient (output port or IP parameter). 
cCoefMultHg <= cExtHgMultCoef when kExtCalibEn = true else kHgMultCoefStatic;
--Channel1 low gain offset compensation coefficient (output port or IP parameter). 
cCoefAddLg  <= cExtLgAddCoef  when kExtCalibEn = true else kLgAddCoefStatic;
--Channel1 high gain offset compensation coefficient (output port or IP parameter).  
cCoefAddHg  <= cExtHgAddCoef  when kExtCalibEn = true else kHgAddCoefStatic;  

-- Numerical representation of the calibration module's signals:
-- The first operation of the calibration block is represented by the multiplication
-- of the raw data input by the multiplicative coefficient. The multiplier's 
-- operands are represented as follows:
-- 1. The input raw data is considered to be a fractional number < 1, consisting
-- of a sign bit and 17 fractional bits.
-- 2. The multiplicative coefficient, which can be slightly higher or slightly
-- lower than 1, is also represented on 18 bits, i.e. 1 sign bit, 1 integer bit,
-- and 16 fractional bis.
-- The result of the multiplication is a 36 bit number, consisting of a sign bit,
-- 2 integer bits and 33 fractional bits. Thus, to apply the additive coefficient,
-- (which is interpreted by the module as a 18 bit fractional number - 1 sign bit 
-- + 17 fractional bits)the additive coefficient is also converted to this format 
-- (sign extended by 2 bits and padded with 16 fractional bits). 

-- Determine the additive coefficient based on the channel's gain relay state
-- and convert it to a 36 bit representation (as explained above).
ProcAddCoef : process (SamplingClk, acRst_n)  
begin
   if (acRst_n = '0') then
      cCoefAdd <= (others => '0');
   elsif (rising_edge(SamplingClk)) then
      if (cGainState = '0') then --Low Gain
         cCoefAdd <= cCoefAddLg(17) & cCoefAddLg(17) & cCoefAddLg & x"0000";
      else --High Gain
         cCoefAdd <= cCoefAddHg(17) & cCoefAddHg(17) & cCoefAddHg & x"0000";
      end if;
   end if;
end process;

-- Determine the multiplicative coefficient based on the channel's gain relay state.
ProcMultCoef : process (SamplingClk, acRst_n)  
begin
   if (acRst_n = '0') then
      cCoefMult <= "010000000000000000";
   elsif (rising_edge(SamplingClk)) then
      if (cGainState = '0') then 
         cCoefMult <= cCoefMultLg;
      else
         cCoefMult <= cCoefMultHg;
      end if;
   end if;
end process;

cDataRaw18b <= cDataRaw & kDummy;

-- Invert raw data input if the analog channel is inverted at the
-- ADC/DAC input/output. Inversion of the minimum negative value (-2^kWidth)
-- needs to be done explicitly. 
ProcInvert : process (cDataRaw18b)  
begin
   if (kInvert = false) then
      if (cDataRaw18b = "100000000000000000") then
         -- For the inverted channel, because the inversion is done at the FPGA 
         -- level, the minimum negative value is -2^kWidth+1. For symmetry 
         -- reasons the non inverted channel also limits the minimum negative value 
         -- at -2^kWidth+1.
         cDataRaw18bSigned <= "100000000000000001"; 
      else
         cDataRaw18bSigned <= signed(cDataRaw18b);
      end if;
   else
      if (cDataRaw18b = "100000000000000000") then 
         cDataRaw18bSigned <= "011111111111111111";
      else
         cDataRaw18bSigned <= - signed (cDataRaw18b);  
      end if;
   end if;
end process;
                      
cCoefMultSigned <= signed (cCoefMult);
cCoefAddSigned <= signed (cCoefAdd);

-- Apply the multiplicative coefficient. Register multiplication result.  
ProcRegMultResult : process (SamplingClk, acRst_n)  
begin
   if (acRst_n = '0') then
      cCalibMult <= (others => '0');
      cDataInValidR <= '0';
   elsif (rising_edge(SamplingClk)) then
      cCalibMult <= cDataRaw18bSigned * cCoefMultSigned;
      --Data out valid flag must be synchronized with its corresponding sample.
      cDataInValidR <= cDataInValid;
   end if;
end process;

-- Apply additive coefficient.
cCalibAdd <= cCalibMult + cCoefAddSigned; 

-- Register calibration result; the calibration output is saturated at
-- 2^kWidth - 1 for positive values  or -2^kWidth for negative values;
-- the calibration process is bypassed if cTestMode = '1'.
-- If at the start of the acquisition, this module puts on cCalibDataOut output signal the first acquired and calibrated samples, 
-- together with cDataCalibValid = '1', but doDataAxisTready is not asserted, in the next clock cycle the value on cCalibDataOut will change, 
-- since it will take the values of the next calibrated samples. This violates the AXI Stream interface specification. 
ProcCalibDataAndValid : process (SamplingClk, acRst_n, cDataAcceptanceReady)  
begin
   if (acRst_n = '0') then
      cCalibDataOut <= (others => '0');
      cDataCalibValidLoc <= '0';
      cFirstWordAccepted <= '0';
   elsif (rising_edge(SamplingClk)) then
      cDataCalibValidLoc <= cDataInValidR;
      if (cDataCalibValidLoc = '1' and cDataAcceptanceReady = '1') then
         cFirstWordAccepted <= '1';
      end if;
      if(cFirstWordAccepted = '0' or (cDataCalibValidLoc = '1' and cDataAcceptanceReady = '1'))  then 
         cCalibDataOut <= cCalibDataOutLoc;  
      end if;
   end if;
end process;
      
cDataCalibValid <= cDataCalibValidLoc;
                    
cCalibDataOutLoc <= cDataRaw18b(17 downto 2) when cTestMode = '1' else
                      x"8000" when ((cCalibAdd(35) = '1') and (cCalibAdd(34 downto 33) /= "11")) else
                      x"7FFF" when ((cCalibAdd(35) = '0') and (cCalibAdd(34 downto 33) /= "00")) else
                      (std_logic_vector(cCalibAdd(33 downto 18)));

end Behavioral;
