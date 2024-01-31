
-------------------------------------------------------------------------------
--
-- File: CalibDataReference.vhd
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
-- This module generates the reference output data for the GainOffsetCaib module.
-- It is supposed to run in parallel with the GainOffsetCaib module as part of
-- the test bench and share the same inputs. Malfunctions of the GainOffsetCaib 
-- can be detected by comparing its output with the output of this module.
--  
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.numeric_std.all;

entity CalibDataReference is
    Generic (
       -- ADC/DAC number of bits
       kWidth : integer range 10 to 16 := 14;
       -- ADC/DAC dynamic/static calibration
       kExtCalibEn : boolean := false; 
       -- Channel1 low gain multiplicative (gain) compensation coefficient parameter
       kLgMultCoefStatic : std_logic_vector (17 downto 0) := "010000000000000000"; 
       -- Channel1 low gain additive (offset) compensation coefficient parameter
       kLgAddCoefStatic : std_logic_vector (17 downto 0) := "000000000000000000";
       -- Channel1 high gain multiplicative (gain) compensation coefficient parameter 
       kHgMultCoefStatic : std_logic_vector (17 downto 0) := "010000000000000000";
       -- Channel1 high gain additive (offset) compensation coefficient parameter  
       kHgAddCoefStatic : std_logic_vector (17 downto 0) := "000000000000000000";
       -- Invert input data sign
       kInvert : boolean := false;
       -- Calibration stage latency
       kLatency : integer := 2;
       -- Calibration stage latency in test mode; Must be > 1 and < kLatency
       -- The GainOffsetCaib module has different latencies in test mode
       -- and in normal operation. 
       kTestLatency : integer := 1  
    );
    Port (
       -- Sampling clock   
       SamplingClk : in STD_LOGIC;
      -- cTestMode is used to bypass the calibration block. When this signal
      -- is asserted, raw samples are provided on the output data port. 
       cTestMode : in STD_LOGIC;
       -- Data input port
       cChIn : in STD_LOGIC_VECTOR (kWidth-1 downto 0);
       -- Data output port
       cChOut : out STD_LOGIC_VECTOR (kWidth-1 downto 0);
       --Channel1 low gain gain compensation coefficient external port
       cExtLgMultCoef : in std_logic_vector (17 downto 0);
       --Channel1 low gain offset compensation coefficient external port 
       cExtLgAddCoef : in std_logic_vector (17 downto 0);
       --Channel1 high gain gain compensation coefficient external port  
       cExtHgMultCoef : in std_logic_vector (17 downto 0);
       --Channel1 high gain offset compensation coefficient external port;  
       cExtHgAddCoef : in std_logic_vector (17 downto 0);
       -- Gain Relay State (1 -> High Gain; 0 -> Low Gain)
       cGainState : in std_logic
    );  
end CalibDataReference;

architecture Behavioral of CalibDataReference is

signal cLgCoefAdd, cHgCoefAdd, cLgCoefMult, cHgCoefMult : signed (17 downto 0);
signal cLgMult, cHgMult : signed (35 downto 0) := (others => '0');
signal cChOutAux : std_logic_vector (kWidth-1 downto 0);
type ADC_ChArray_t is array (kLatency-1 downto 0) of std_logic_vector(kWidth-1 downto 0); 
signal cChInDelayed : ADC_ChArray_t := (others => (others => '0')); 
signal cLgCoefAddReal : real;
signal cHgCoefAddReal : real;
signal cLgCoefMultReal : real;
signal cHgCoefMultReal : real;
signal cChOutReal : real;
signal cChInReal : real;
signal cChInSigned : signed (kWidth-1 downto 0);
signal sChOutSigned : signed (kWidth-1 downto 0);
constant kTwoPow17 : real := 2.0**17.0;
constant kTwoPow16 : real := 2.0**16.0;
constant kTwoPowNadc : real := 2.0**real((kWidth-1));
-- Constants representing the minimum (negative) value and the maximum 
-- (positive) value that cChIn can take. If inversion is requested by
-- setting kInvert to "true", in case cChIn = kValMin, the inversion
-- can't be performed directly on kWidth. The output of the inversion
-- needs to be forced to kValMax.
constant kValMin : std_logic_vector (15 downto 0) := x"8000";
constant kValMax : std_logic_vector (15 downto 0) := x"7FFF";

begin

-- Determine the value of the gain and offset calibration coefficients
-- based on the static/dynamic configuration option (kExtCalibEn).
cLgCoefAdd <= signed(kLgAddCoefStatic) when kExtCalibEn = false 
         else signed(cExtLgAddCoef);
cHgCoefAdd <= signed(kHgAddCoefStatic) when kExtCalibEn = false 
         else signed(cExtHgAddCoef);
cLgCoefMult <= signed(kLgMultCoefStatic) when kExtCalibEn = false
         else signed(cExtLgMultCoef);
cHgCoefMult <= signed(kHgMultCoefStatic) when kExtCalibEn = false
         else signed(cExtHgMultCoef);

-- The necessity of these operations is explained in the IP's
-- documentation.
cLgCoefAddReal <= Real(to_integer(cLgCoefAdd))/kTwoPow17;
cHgCoefAddReal <= Real(to_integer(cHgCoefAdd))/kTwoPow17; 
cLgCoefMultReal <= Real(to_integer(cLgCoefMult))/kTwoPow16; 
cHgCoefMultReal <= Real(to_integer(cHgCoefMult))/kTwoPow16;

-- Invert raw data input if the analog channel is inverted at the
-- ADC/DAC input. Inversion of the minimum negative value (-2^kWidth)
-- needs to be done explicitly. 
ProcInvert : process (cChIn)
begin
   if (kInvert = false) then
      -- For the inverted channel, because the inversion is done at the FPGA 
      -- level, the minimum negative value is -2^kWidth+1. For symmetry 
      -- reasons the non inverted channel also limits the minimum negative value 
      -- at -2^kWidth+1. 
      if (cChIn = kValMin(15 downto 16-kWidth)) then 
         cChInSigned <= signed(kValMax(15 downto 16-kWidth))+1;
      else
         cChInSigned <= signed(cChIn);
      end if;	  
   else
      if (cChIn = kValMin(15 downto 16-kWidth)) then 
         cChInSigned <= signed(kValMax(15 downto 16-kWidth));
      else
         cChInSigned <= - signed (cChIn);  
      end if;
   end if;
end process;

cChInReal <= Real(to_integer(cChInSigned)); 

-- Apply the offset and gain coefficients to the input samples.
cChOutReal <= (cChInReal*cLgCoefMultReal+cLgCoefAddReal*kTwoPowNadc) when (cGainState = '0')
             else (cChInReal*cHgCoefMultReal+cHgCoefAddReal*kTwoPowNadc);          

-- Saturate output.          
ProcCalib : process (cChOutReal)   
begin
    if (cChOutReal > (kTwoPowNadc-1.0)) then 
        sChOutSigned <= to_signed(integer(kTwoPowNadc-1.0),kWidth);
    elsif  (cChOutReal < (-kTwoPowNadc)) then 
        sChOutSigned <= to_signed(integer(-kTwoPowNadc),kWidth);
    else
        sChOutSigned <= to_signed(integer(cChOutReal),kWidth);
    end if;
end process;
 
-- Bypass the calibration process if the cTestMode signal is asserted.
cChOutAux <= std_logic_vector (sChOutSigned) when (cTestMode = '0') else cChIn;

-- Simulate the GainOffsetCalib module latency. 
ProcDelay : process (SamplingClk) 
begin
    if (rising_edge(SamplingClk)) then
        cChInDelayed(0) <= cChOutAux;
        for Index in 1 to (kLatency-1) loop
            cChInDelayed (Index) <= cChInDelayed (Index - 1);
        end loop;        
    end if;
end process;

ProcOutput : process (cChInDelayed, cTestMode) 
begin
    if (cTestMode = '0') then
        cChOut <= cChInDelayed(kLatency-1);
    else
        cChOut <= cChInDelayed(kTestLatency-1);
    end if;   
end process;  

end Behavioral;
