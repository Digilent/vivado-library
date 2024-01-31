
-------------------------------------------------------------------------------
--
-- File: PkgZmodDigitizer.vhd
-- Author: Tudor Gherman, Robert Bocos
-- Original Project: ZmodScopeController
-- Date: 2021
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
-- This package contains the constants and functions used for the
-- ZmodDigitizerController IP
--  
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package PkgZmodDigitizer is

-- Zmod Scope variants identifier
constant kZmodDigitizer1430_105 : integer := 0; -- Zmod Digitizer 1430 - 105 (AD9648)
constant kZmodDigitizer1030_40  : integer := 1; -- Zmod Digitizer 1030 - 40 (AD9204)
constant kZmodDigitizer1030_125 : integer := 2; -- Zmod Digitizer 1030 - 125 (AD9608) 
constant kZmodDigitizer1230_40  : integer := 3; -- Zmod Digitizer 1230 - 40 (AD9231)
constant kZmodDigitizer1230_125 : integer := 4; -- Zmod Digitizer 1230 - 125 (AD9628) 
constant kZmodDigitizer1430_40  : integer := 5; -- Zmod Digitizer 1430 - 40 (AD9251)
constant kZmodDigitizer1430_125 : integer := 6; -- Zmod Digitizer 1430 - 125 (AD9648)      
    
--Timing parameters
constant kSysClkPeriod : time := 10ns;              -- System Clock Period
constant ktS : time := 2 ns;                        -- Setup time between CSB and SCLK
constant ktH : time := 2 ns;                        -- Hold time between CSB and SCLK
constant ktDS : time := 2 ns;                       -- Setup time between the data and the rising edge of SCLK
constant ktDH : time := 2 ns;                       -- Hold time between the data and the rising edge of SCLK
constant ktclk : time := 40 ns;                     -- minimum period of the SCLK
constant kSclkHigh : time := 10 ns;                 -- SCLK pulse width high (min)
constant kSclkLow : time := 10 ns;                  -- SCLK pulse width low (min)
--constant kSclkT_Max : time := 10 ns;              -- SCLK pulse width low (min)
constant kSclkT_Min : time := 50 ns;                -- SCLK pulse width low (min)
constant kTdcoMax : time := 4.4 ns;
constant kRelayConfigTime : time := 3ms;            -- relay set and reset signals
--ADC Model Registers
constant aReg00_Mask : std_logic_vector(7 downto 0) := "01100110";

--Implementation constants
constant kCS_PulseWidthHigh : integer := 31;   --CS pulse width high not specified in AD9648
constant kSPI_DataWidth : integer := 8;        --ADI_SPI module data width
constant kSPI_CommandWidth : integer := 16;    --ADI_SPI module command width
constant kSPI_AddrWidth : integer := kSPI_CommandWidth - 3;    --ADI_SPI module command width
constant kSPI_SysClkDiv : integer := 4;       --ADI_SPI module system clock divide constant
                                              --No minimum SPI clock frequency specified by AD9648. The maximum frequency is 25MHz.

type ADC_SPI_Commands_t is array (19 downto 0) of std_logic_vector(23 downto 0);
type ADC_SPI_Readback_t is array (19 downto 0) of std_logic_vector(7 downto 0);
constant kAD96xx_SPI_Cmd : ADC_SPI_Commands_t := (x"000500",  --19 Device index: none
                                               x"000800", --18 Power modes: Normal operation
                                               x"000502", --17 Device index: B
                                               x"000800", --16 Power modes: Normal operation
                                               x"000501", --15 Device index: A
                                               x"003A02", --14 Sync control : continuous | sync enable | 0
                                               x"001781", --13 Output Delay; DCO delay enabled; 1.12ns
                                               x"001511", --12 Output adjust: CMOS drive strength 01 - 2X [DCO | DOUT]
                                               x"002A00", --11 Overrange control: output disable
                                               x"000B03", --10 Clck Divide: 4
                                               x"001680", --9 Clock Phase control: DCO inverted, Input clock divider phase adjust 0
                                               x"000500", --8 Device index: none
                                               x"001421", --7 Output mode: CMOS | interleave | enable B | output not invert | 2's Complement
                                               x"000803", --6 Power modes: digital reset
                                               x"000502", --5 Device index: B
                                               x"001431", --4 Output mode: CMOS | interleave | disable A | output not invert | 2's Complement
                                               x"000803", --3 Power modes: digital reset
                                               x"000501", --2 Device index: A
                                               x"000100", --1 Chip ID: read chip ID
                                               x"00003C"  --0 SPI Port Config: soft reset
                                            );                                            
constant kAD96xx_SPI_Rdbck : ADC_SPI_Readback_t:= (x"00",  --19 Device index: none
                                                x"00", --18 Power modes: Normal operation
                                                x"02", --17 Device index: B
                                                x"00", --16 Power modes: Normal operation
                                                x"01", --15 Device index: A
                                                x"02", --14 Sync control : continuous | sync enable | 0
                                                x"81", --13 Output Delay; DCO delay enabled; 1.12ns
                                                x"11", --12 Output adjust: CMOS drive strength 01 - 2X [DCO | DOUT]
                                                x"00", --11 Overrange control: output disable
                                                x"03", --10 Clck Divide: 4
                                                x"80", --9 Clock Phase control: DCO inverted, Input clock divider phase adjust 0
                                                x"00", --8 Device index: none
                                                x"21", --7 Output mode: CMOS | interleave | enable B | output not invert | 2's Complement
                                                x"03", --6 Power modes: digital reset
                                                x"02", --5 Device index: B
                                                x"31", --4 Output mode: CMOS | interleave | disable A | output not invert | 2's Complement
                                                x"03", --3 Power modes: digital reset
                                                x"01", --2 Device index: A
                                                x"88", --1 Chip ID expected value:88
                                                x"18"  --0 SPI Port Config: soft reset                                                
                                               );
constant kAD92xx_SPI_Cmd : ADC_SPI_Commands_t := (x"000500",  --19 Device index: none
                                               x"000800", --18 Power modes: Normal operation
                                               x"000502", --17 Device index: B
                                               x"000800", --16 Power modes: Normal operation
                                               x"000501", --15 Device index: A
                                               x"010002", --14 Sync control : continuous | sync enable | 0
                                               x"001781", --13 Output Delay; DCO delay enabled; 1.12ns
                                               x"001511", --12 Output adjust: CMOS drive strength 01 - 2X [DCO | DOUT]
                                               x"002A00", --11 Overrange control: output disable
                                               x"000B03", --10 Clck Divide: 4
                                               x"000500", --9 Device index: none
                                               x"001680", --8 Clock Phase control: DCO inverted, Input clock divider phase adjust 0
                                               x"001421", --7 Output mode: CMOS | interleave | enable B | output not invert | 2's Complement
                                               x"000803", --6 Power modes: digital reset
                                               x"000502", --5 Device index: B
                                               x"001431", --4 Output mode: CMOS | interleave | disable A | output not invert | 2's Complement
                                               x"000803", --3 Power modes: digital reset
                                               x"000501", --2 Device index: A
                                               x"000100", --1 Chip ID: read chip ID
                                               x"00003C"  --0 SPI Port Config: soft reset
                                            );                                            
constant kAD92xx_SPI_Rdbck : ADC_SPI_Readback_t:= (x"00",  --19 Device index: none
                                                x"00", --18 Power modes: Normal operation
                                                x"02", --17 Device index: B
                                                x"00", --16 Power modes: Normal operation
                                                x"01", --15 Device index: A
                                                x"02", --14 Sync control : continuous | sync enable | 0
                                                x"81", --13 Output Delay; DCO delay enabled; 1.12ns
                                                x"11", --12 Output adjust: CMOS drive strength 01 - 2X [DCO | DOUT]
                                                x"00", --11 Overrange control: output disable
                                                x"03", --10 Clck Divide: 4
                                                x"00", --9 Device index: none
                                                x"80", --8 Clock Phase control: DCO inverted, Input clock divider phase adjust 0
                                                x"21", --7 Output mode: CMOS | interleave | enable B | output not invert | 2's Complement
                                                x"03", --6 Power modes: digital reset
                                                x"02", --5 Device index: B
                                                x"31", --4 Output mode: CMOS | interleave | disable A | output not invert | 2's Complement
                                                x"03", --3 Power modes: digital reset
                                                x"01", --2 Device index: A
                                                x"88", --1 Chip ID expected value:88
                                                x"18"  --0 SPI Port Config: soft reset                                                
                                               );                                               
constant kSetTrsfReg : std_logic_vector(23 downto 0) := x"00FF01";                                                   
--ADC Register addresses
constant kDevIndex : std_logic_vector(12 downto 0)    := "00000" & x"05";
constant kPwrModes : std_logic_vector(12 downto 0)    := "00000" & x"08";
constant kSyncCtrll : std_logic_vector(12 downto 0)   := "00000" & x"3A";
constant kOutDly : std_logic_vector(12 downto 0)      := "00000" & x"17";
constant kOutAdj : std_logic_vector(12 downto 0)      := "00000" & x"15";
constant kOvrrCtrl : std_logic_vector(12 downto 0)    := "00000" & x"2A";
constant kClkPhCtrl : std_logic_vector(12 downto 0)   := "00000" & x"16"; 
constant kClkDiv : std_logic_vector(12 downto 0)      := "00000" & x"0B";  
constant kOutMode : std_logic_vector(12 downto 0)     := "00000" & x"14";                                            
constant kChipID : std_logic_vector(12 downto 0)      := "00000" & x"01";  
constant kSPI_PortCfg : std_logic_vector(12 downto 0) := "00000" & x"01";                                             

--ID Register value for supported Zmods
constant AD9648_ID : std_logic_vector(7 downto 0) := x"88";
constant AD9204_ID : std_logic_vector(7 downto 0) := x"25";
constant AD9608_ID : std_logic_vector(7 downto 0) := x"9C";
constant AD9231_ID : std_logic_vector(7 downto 0) := x"24";
constant AD9628_ID : std_logic_vector(7 downto 0) := x"89";
constant AD9251_ID : std_logic_vector(7 downto 0) := x"23";

constant AD9648_Grade : std_logic_vector(7 downto 0) := x"40";
constant AD9204_Grade : std_logic_vector(7 downto 0) := x"10";
constant AD9608_Grade : std_logic_vector(7 downto 0) := x"50";
constant AD9231_Grade : std_logic_vector(7 downto 0) := x"10";
constant AD9628_Grade : std_logic_vector(7 downto 0) := x"50";
constant AD9251_Grade : std_logic_vector(7 downto 0) := x"10";

-- Constant indicating the number of configurable registers present in the CDCE6214-Q1
constant kCDCE_RegisterNr : integer := 86;
constant kCDCE_RegNrZeroBased : integer := (kCDCE_RegisterNr-1);

-- Constant indicating the number of frequency configs for the CDCE6214-Q1
constant kCDCE_FreqCfgsNr : integer := 7;

type CDCE_TWI_Masks_t is array (0 to 85) of std_logic_vector(15 downto 0);
type CDCE_TWI_Commands_t is array (0 to 85) of std_logic_vector(31 downto 0);
type CDCE_I2C_Cmd_Array_t is array (0 to (kCDCE_FreqCfgsNr - 1)) of CDCE_TWI_Commands_t;
                                                
constant CDCE_I2C_Cmds : CDCE_I2C_Cmd_Array_t := (
                                               (x"00550000",
                                                x"00540000",
                                                x"00530000",
                                                x"00520000",
                                                x"00510004",
                                                x"00500000",
                                                x"004F0208",
                                                x"004E0000",
                                                x"004D0000",
                                                x"004C0188",
                                                x"004B8008",
                                                x"004AA181",
                                                x"00491000",
                                                x"00480004",
                                                x"00470006",
                                                x"00460008",
                                                x"0045A181",
                                                x"00441000",
                                                x"00430004",
                                                x"00420006",
                                                x"00410008",
                                                x"0040A181",
                                                x"003F1000",
                                                x"003E0004",
                                                x"003D0000",
                                                x"003C6008",
                                                x"003B0008",
                                                x"003A502C",
                                                x"00391000",
                                                x"00380004",
                                                x"0037001E",
                                                x"00363400",
                                                x"00350069",
                                                x"00345000",
                                                x"003340C0",
                                                x"003207C0",
                                                x"0031001F",
                                                x"0030180A",
                                                x"002F0528",
                                                x"002E0000",
                                                x"002D4F80",
                                                x"002C0318",
                                                x"002B0051",
                                                x"002A0002",
											    x"00290000",
                                                x"00280000",
                                                x"00270000",
                                                x"00260000",
                                                x"00250000",
                                                x"00240000",
                                                x"00230000",
                                                x"00220000",
                                                x"00212710",
                                                x"00200000",
                                                x"001F0000",
                                                x"001E0040",
                                                x"001D0000",
                                                x"001C0000",
                                                x"001B0004",
                                                x"001A0000",
                                                x"00190401",
                                                x"00188718",
                                                x"00170000",
                                                x"00160000",
                                                x"00150000",
                                                x"00140000",
                                                x"00130000",
                                                x"00120000",
                                                x"001126C4",
                                                x"0010921F",
                                                x"000FA037",
                                                x"000E0000",
                                                x"000D0000",
                                                x"000C0000",
                                                x"000B0000",
                                                x"000A0000",
                                                x"00090000",
                                                x"00080000",
                                                x"00070000",
                                                x"00060000",
                                                x"00050008",
                                                x"00040070",
                                                x"00030000",
                                                x"00020002",
                                                x"00012222",
                                                x"00003004"                                         
                                                ),--122.88M
                                                
                                               (x"00550000",
                                                x"00540000",
                                                x"00530000",
                                                x"00520000",
                                                x"00510004",
                                                x"00500000",
                                                x"004F0208",
                                                x"004E0000",
                                                x"004D0000",
                                                x"004C0188",
                                                x"004B8008",
                                                x"004AA181",
                                                x"00491000",
                                                x"00480008",
                                                x"00470006",
                                                x"00460008",
                                                x"0045A181",
                                                x"00441000",
                                                x"00430008",
                                                x"00420006",
                                                x"00410008",
                                                x"0040A181",
                                                x"003F1000",
                                                x"003E0008",
                                                x"003D0000",
                                                x"003C6008",
                                                x"003B0008",
                                                x"003A502C",
                                                x"00391000",
                                                x"00380008",
                                                x"0037001E",
                                                x"00363400",
                                                x"00350069",
                                                x"00345000",
                                                x"003340C0",
                                                x"003207C0",
                                                x"0031001F",
                                                x"0030300A",
                                                x"002F0550",
                                                x"002E0000",
                                                x"002D4F80",
                                                x"002C0318",
                                                x"002B0051",
                                                x"002A0002",
											    x"00290000",
                                                x"00280000",
                                                x"00270000",
                                                x"00260000",
                                                x"00250000",
                                                x"00240000",
                                                x"00230000",
                                                x"00220000",
                                                x"00212710",
                                                x"00200000",
                                                x"001F0000",
                                                x"001E007D",
                                                x"001D0000",
                                                x"001C0000",
                                                x"001B0004",
                                                x"001A0000",
                                                x"00190402",
                                                x"00188718",
                                                x"00170000",
                                                x"00160000",
                                                x"00150000",
                                                x"00140000",
                                                x"00130000",
                                                x"00120000",
                                                x"001126C4",
                                                x"0010921F",
                                                x"000FA037",
                                                x"000E0000",
                                                x"000D0000",
                                                x"000C0000",
                                                x"000B0000",
                                                x"000A0000",
                                                x"00090000",
                                                x"00080000",
                                                x"00070000",
                                                x"00060000",
                                                x"00050008",
                                                x"00040070",
                                                x"00030000",
                                                x"00020002",
                                                x"00012222",
                                                x"00003004"                                         
                                                ),--50M
                                                
                                               (x"00550000",
                                                x"00540000",
                                                x"00530000",
                                                x"00520000",
                                                x"00510004",
                                                x"00500000",
                                                x"004F0208",
                                                x"004E0000",
                                                x"004D0000",
                                                x"004C0188",
                                                x"004B8008",
                                                x"004AA181",
                                                x"00491000",
                                                x"00480006",
                                                x"00470006",
                                                x"00460008",
                                                x"0045A181",
                                                x"00441000",
                                                x"00430006",
                                                x"00420006",
                                                x"00410008",
                                                x"0040A181",
                                                x"003F1000",
                                                x"003E0006",
                                                x"003D0000",
                                                x"003C6008",
                                                x"003B0008",
                                                x"003A502C",
                                                x"00391000",
                                                x"00380006",
                                                x"0037001E",
                                                x"00363400",
                                                x"00350069",
                                                x"00345000",
                                                x"003340C0",
                                                x"003207C0",
                                                x"0031001F",
                                                x"0030300A",
                                                x"002F0528",
                                                x"002E0000",
                                                x"002D4F80",
                                                x"002C0318",
                                                x"002B0051",
                                                x"002A0002",
											    x"00290000",
                                                x"00280000",
                                                x"00270000",
                                                x"00260000",
                                                x"00250000",
                                                x"00240000",
                                                x"00230000",
                                                x"00220000",
                                                x"00212710",
                                                x"00200000",
                                                x"001F0000",
                                                x"001E007D",
                                                x"001D0000",
                                                x"001C0000",
                                                x"001B0004",
                                                x"001A0000",
                                                x"00190402",
                                                x"00188718",
                                                x"00170000",
                                                x"00160000",
                                                x"00150000",
                                                x"00140000",
                                                x"00130000",
                                                x"00120000",
                                                x"001126C4",
                                                x"0010921F",
                                                x"000FA037",
                                                x"000E0000",
                                                x"000D0000",
                                                x"000C0000",
                                                x"000B0000",
                                                x"000A0000",
                                                x"00090000",
                                                x"00080000",
                                                x"00070000",
                                                x"00060000",
                                                x"00050008",
                                                x"00040070",
                                                x"00030000",
                                                x"00020002",
                                                x"00012222",
                                                x"00003004"                                         
                                                ),--80M
                                                
                                               (x"00550000",
                                                x"00540000",
                                                x"00530000",
                                                x"00520000",
                                                x"00510004",
                                                x"00500000",
                                                x"004F0208",
                                                x"004E0000",
                                                x"004D0000",
                                                x"004C0188",
                                                x"004B8008",
                                                x"004AA181",
                                                x"00491000",
                                                x"00480004",
                                                x"00470006",
                                                x"00460008",
                                                x"0045A181",
                                                x"00441000",
                                                x"00430004",
                                                x"00420006",
                                                x"00410008",
                                                x"0040A181",
                                                x"003F1000",
                                                x"003E0004",
                                                x"003D0000",
                                                x"003C6008",
                                                x"003B0008",
                                                x"003A502C",
                                                x"00391000",
                                                x"00380004",
                                                x"0037001E",
                                                x"00363400",
                                                x"00350069",
                                                x"00345000",
                                                x"003340C0",
                                                x"003207C0",
                                                x"0031001F",
                                                x"0030300A",
                                                x"002F0550",
                                                x"002E0000",
                                                x"002D4F80",
                                                x"002C0318",
                                                x"002B0051",
                                                x"002A0002",
											    x"00290000",
                                                x"00280000",
                                                x"00270000",
                                                x"00260000",
                                                x"00250000",
                                                x"00240000",
                                                x"00230000",
                                                x"00220000",
                                                x"00212710",
                                                x"00200000",
                                                x"001F0000",
                                                x"001E007D",
                                                x"001D0000",
                                                x"001C0000",
                                                x"001B0004",
                                                x"001A0000",
                                                x"00190402",
                                                x"00188718",
                                                x"00170000",
                                                x"00160000",
                                                x"00150000",
                                                x"00140000",
                                                x"00130000",
                                                x"00120000",
                                                x"001126C4",
                                                x"0010921F",
                                                x"000FA037",
                                                x"000E0000",
                                                x"000D0000",
                                                x"000C0000",
                                                x"000B0000",
                                                x"000A0000",
                                                x"00090000",
                                                x"00080000",
                                                x"00070000",
                                                x"00060000",
                                                x"00050008",
                                                x"00040070",
                                                x"00030000",
                                                x"00020002",
                                                x"00012222",
                                                x"00003004"                                         
                                                ),--100M
                                                
                                               (x"00550000",
                                                x"00540000",
                                                x"00530000",
                                                x"00520000",
                                                x"00510004",
                                                x"00500000",
                                                x"004F0208",
                                                x"004E0000",
                                                x"004D0000",
                                                x"004C0188",
                                                x"004B8008",
                                                x"004AA181",
                                                x"00491000",
                                                x"00480006",
                                                x"00470006",
                                                x"00460008",
                                                x"0045A181",
                                                x"00441000",
                                                x"00430006",
                                                x"00420006",
                                                x"00410008",
                                                x"0040A181",
                                                x"003F1000",
                                                x"003E0006",
                                                x"003D0000",
                                                x"003C6008",
                                                x"003B0008",
                                                x"003A502C",
                                                x"00391000",
                                                x"00380005",
                                                x"0037001E",
                                                x"00363400",
                                                x"00350069",
                                                x"00345000",
                                                x"003340C0",
                                                x"003207C0",
                                                x"0031001F",
                                                x"0030200A",
                                                x"002F0500",
                                                x"002E0000",
                                                x"002D4F80",
                                                x"002C0318",
                                                x"002B0051",
                                                x"002A0002",
											    x"00290000",
                                                x"00280000",
                                                x"00270000",
                                                x"00260000",
                                                x"00250000",
                                                x"00240000",
                                                x"00230000",
                                                x"00220000",
                                                x"00212710",
                                                x"00200000",
                                                x"001F0000",
                                                x"001E0044",
                                                x"001D0000",
                                                x"001C0000",
                                                x"001B0004",
                                                x"001A0000",
                                                x"00190401",
                                                x"00188718",
                                                x"00170000",
                                                x"00160000",
                                                x"00150000",
                                                x"00140000",
                                                x"00130000",
                                                x"00120000",
                                                x"001126C4",
                                                x"0010921F",
                                                x"000FA037",
                                                x"000E0000",
                                                x"000D0000",
                                                x"000C0000",
                                                x"000B0000",
                                                x"000A0000",
                                                x"00090000",
                                                x"00080000",
                                                x"00070000",
                                                x"00060000",
                                                x"00050008",
                                                x"00040070",
                                                x"00030000",
                                                x"00020002",
                                                x"00012222",
                                                x"00003004"                                         
                                                ),--108.8M
                                                
                                               (x"00550000",
                                                x"00540000",
                                                x"00530000",
                                                x"00520000",
                                                x"00510004",
                                                x"00500000",
                                                x"004F0208",
                                                x"004E0000",
                                                x"004D0000",
                                                x"004C0188",
                                                x"004B8008",
                                                x"004AA181",
                                                x"00491000",
                                                x"00480004",
                                                x"00470006",
                                                x"00460008",
                                                x"0045A181",
                                                x"00441000",
                                                x"00430004",
                                                x"00420006",
                                                x"00410008",
                                                x"0040A181",
                                                x"003F1000",
                                                x"003E0004",
                                                x"003D0000",
                                                x"003C6008",
                                                x"003B0008",
                                                x"003A502C",
                                                x"00391000",
                                                x"00380004",
                                                x"0037001E",
                                                x"00363400",
                                                x"00350069",
                                                x"00345000",
                                                x"003340C0",
                                                x"003207C0",
                                                x"0031001F",
                                                x"0030300A",
                                                x"002F0528",
                                                x"002E0000",
                                                x"002D4F80",
                                                x"002C0318",
                                                x"002B0051",
                                                x"002A0002",
											    x"00290000",
                                                x"00280000",
                                                x"00270000",
                                                x"00260000",
                                                x"00250000",
                                                x"00240000",
                                                x"00230000",
                                                x"00220000",
                                                x"00212710",
                                                x"00200000",
                                                x"001F0000",
                                                x"001E007D",
                                                x"001D0000",
                                                x"001C0000",
                                                x"001B0004",
                                                x"001A0000",
                                                x"00190402",
                                                x"00188718",
                                                x"00170000",
                                                x"00160000",
                                                x"00150000",
                                                x"00140000",
                                                x"00130000",
                                                x"00120000",
                                                x"001126C4",
                                                x"0010921F",
                                                x"000FA037",
                                                x"000E0000",
                                                x"000D0000",
                                                x"000C0000",
                                                x"000B0000",
                                                x"000A0000",
                                                x"00090000",
                                                x"00080000",
                                                x"00070000",
                                                x"00060000",
                                                x"00050008",
                                                x"00040070",
                                                x"00030000",
                                                x"00020002",
                                                x"00012222",
                                                x"00003004"                                         
                                                ),--120M
                                                
                                               (x"00550000",
                                                x"00540000",
                                                x"00530000",
                                                x"00520000",
                                                x"00510004",
                                                x"00500000",
                                                x"004F0208",
                                                x"004E0000",
                                                x"004D0000",
                                                x"004C0188",
                                                x"004B8008",
                                                x"004AA181",
                                                x"00491000",
                                                x"00480005",
                                                x"00470006",
                                                x"00460008",
                                                x"0045A181",
                                                x"00441000",
                                                x"00430005",
                                                x"00420006",
                                                x"00410008",
                                                x"0040A181",
                                                x"003F1000",
                                                x"003E0005",
                                                x"003D0000",
                                                x"003C6008",
                                                x"003B0008",
                                                x"003A502C",
                                                x"00391000",
                                                x"00380005",
                                                x"0037001E",
                                                x"00363400",
                                                x"00350069",
                                                x"00345000",
                                                x"003340C0",
                                                x"003207C0",
                                                x"0031001F",
                                                x"0030180A",
                                                x"002F0500",
                                                x"002E0000",
                                                x"002D4F80",
                                                x"002C0318",
                                                x"002B0051",
                                                x"002A0002",
											    x"00290000",
                                                x"00280000",
                                                x"00270000",
                                                x"00260000",
                                                x"00250000",
                                                x"00240000",
                                                x"00230000",
                                                x"00220000",
                                                x"00212710",
                                                x"00200000",
                                                x"001F0000",
                                                x"001E0041",
                                                x"001D0000",
                                                x"001C0000",
                                                x"001B0004",
                                                x"001A0000",
                                                x"00190401",
                                                x"00188718",
                                                x"00170000",
                                                x"00160000",
                                                x"00150000",
                                                x"00140000",
                                                x"00130000",
                                                x"00120000",
                                                x"001126C4",
                                                x"0010921F",
                                                x"000FA037",
                                                x"000E0000",
                                                x"000D0000",
                                                x"000C0000",
                                                x"000B0000",
                                                x"000A0000",
                                                x"00090000",
                                                x"00080000",
                                                x"00070000",
                                                x"00060000",
                                                x"00050008",
                                                x"00040070",
                                                x"00030000",
                                                x"00020002",
                                                x"00012222",
                                                x"00003004"                                         
                                                )--124.8M
                                                );
                                                
constant CDCE_I2C_Masks : CDCE_TWI_Masks_t := (
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000001000",
                                               "0000000000000000",
                                               "0000001000001111",
                                               "0001000000000000",
                                               "0000000000000011",
                                               "0000001111111111",
                                               "1111100000001000",
                                               "0000000000000000",
                                               "0011001111111011",
                                               "1111111111111111",
                                               "0000011000111111",
                                               "0000100000000000",
                                               "0000000000000000",
                                               "0011001111111011",
                                               "1111111111111111",
                                               "0000000000111111",
                                               "0110100000001000",
                                               "0000000000000000",
                                               "0011001111111011",
                                               "1111111111111111",
                                               "0000000000000000",
                                               "1111110000111111",
                                               "1111100000001000",
                                               "0000000000000000",
                                               "0101001111111011",
                                               "1111111111111111",
                                               "0000001111000000",
                                               "0000000000000000",
                                               "0000000001001000",
                                               "0000000000000000",
                                               "0000010001000000",
                                               "0000011100000000",
                                               "0000000000011111",
                                               "0111111111111111",
                                               "0001111111111000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "1111111111111111",
                                               "0000000000101110",
                                               "1000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000011111111",
                                               "1111111111111111",
                                               "0000000011111111",
                                               "1111111111111111",
                                               "0111111111111111",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000011",
                                               "0000000000000000",
                                               "0111111011111111",
                                               "1001111100111111",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "1111000000100000",
                                               "1111111111111111",
                                               "0000000000111111",
                                               "0000000000000000",
                                               "0000000000111111",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000000000000",
                                               "0000000111111110",
                                               "0000000011111111",
                                               "0010001001111000",
                                               "0000001111111111",
                                               "1111111111111111",
                                               "1111010100001011"
                                               );

-- number of commands to load in the TX command FIFO for the CommandFIFO module                                               
constant kCmdFIFO_NoWrCmds : integer := 3;
-- command list loaded in the TX command FIFO of the CommandFIFO module    
type CmdFIFO_WrCmdList_t is array (kCmdFIFO_NoWrCmds downto 0) of std_logic_vector(23 downto 0);
constant kCmdFIFO_WrList : CmdFIFO_WrCmdList_t := (x"800200", -- read chip grade
                                                   x"800100", -- read chip ID
                                                   x"00003C", -- write SPI Port Config
                                                   x"000000"  -- dummy
                                            );
-- number of commands expected to be returned  and loaded in the RX command FIFO of 
-- the CommandFIFO module by the AD9648_SPI_Module in the tb_TestConfigADC test bench.
-- It should be equal to the number of read commands in the kCmdFIFO_WrList.                                              
constant kCmdFIFO_NoRdCmds : integer := 2;
-- data expected in return after sending the kCmdFIFO_WrList commands by the CommandFIFO module
type CmdFIFO_RdCmdList_t is array (kCmdFIFO_NoRdCmds-1 downto 0) of std_logic_vector(7 downto 0);
constant kCmdFIFO_Timeout : unsigned (23 downto 0) := x"000600";                                              
                                                                                                                                       
type CalibCoef_t is record
    LgMultCoef : std_logic_vector (17 downto 0);
    LgAddCoef : std_logic_vector (17 downto 0);
    HgMultCoef : std_logic_vector (17 downto 0);
    HgAddCoef : std_logic_vector (17 downto 0);
end record;

type RelayConfig_t is record
    CouplingConfig : std_logic;
    GainConfig : std_logic; 
end record; 
                                        
constant kCmdWrTotal_AD9648 : integer := 19;
constant kCmdWrTotal_AD9204 : integer := 19;
constant kCmdWrTotal_AD9608 : integer := 19;
constant kCmdWrTotal_AD9231 : integer := 19;
constant kCmdWrTotal_AD9628 : integer := 19;
constant kCmdWrTotal_AD9251 : integer := 19;

constant kCmdReadID_Index : integer := 1;       --Read ID command index in kADC_SPI_Cmd and kADC_SPI_Rdbck arrays
constant kCmdClkDivIndex : integer := 10;       --Clock Divide command index in kADC_SPI_Cmd and kADC_SPI_Rdbck arrays

-- Constant used to measure 290ms (with a clock frequency of 100MHz) to allow the ADC's
-- transition from power down to normal operation (ConfigADC.vhd).
-- 290ms value is computed from:
-- https://www.analog.com/media/en/technical-documentation/data-sheets/ad9648.pdf page 40, 
-- "The pseudo code sequence for a digital reset":
-- 2.9e6 sample clock cycles @ 10MHz minimum sampling clock frequency (for ZmodScope) = 290ms  
constant kCountResetResume : unsigned := to_unsigned (28999999, 25);
-- Smaller version of the kCountResetResume, used only for simulation purposes.
-- (999 + 1) clock cycles @ 100MHz frequency means 10us.
constant kCountResetResumeSim : unsigned := to_unsigned (999, 25);
-- Constant used to measure 4ms (with a clock frequency of 100MHz) that allows to
-- determine the timing intervals for the relay drive signals (ConfigRelays.vhd)       
constant kCount4ms : unsigned := to_unsigned (399999, 24); 
-- Smaller version of the kCount4ms, used only for simulation purposes.
-- (399 + 1) clock cycles @ 100MHz frequency means 4us.
constant kCount4msSim : unsigned := to_unsigned (399, 24);
-- Constant used to measure 5ms with a clock frequency of 100MHz
-- Used to determine the ADC calibration timeout condition (tb_TestConfigADC.vhd and tb_TestTop.vhd)       
constant kCount5ms : integer := 500000;
-- Constant used to measure 291ms (with a clock frequency of 100MHz) that determines a
-- timeout condition on the ADC's SPI interface (ConfigADC.vhd)
-- This value has to be larger than kCountResetResume, otherwise false timeouts on the ADC
-- SPI interface will occur (i.e. after an ADC soft reset is performed).
constant kCfgTimeout : unsigned := to_unsigned (29099999, 25);  
                                                 
type FsmStatesADC_t is (StStart, StCheckCmdCnt, StWriteSoftReset, StWaitDoneRst, StReadPortConfig, 
                        StCheckResetDone, StReadID, StWaitDoneID, StWriteControlReg, StWaitDoneWriteReg, 
                        StWaitDoneReadReg, StReadControlReg, StResetTimer, StWaitRecover, StInitDone, StIdle,  
                        StError, StExtSPI_RdCmd, StExtSPI_WrCmd,  StWaitDoneExtWrReg,  
                        StWaitDoneExtRdReg, StRegExtRxData, StSetTrsfReg, StWaitDoneTrsfReg, StReadTrsfReg, StWaitDoneTrsfRegRd);
 
type FsmStatesRelays_t is (StStart, StConfigCouplingCh1, StConfigCouplingCh1Rst, StConfigCouplingCh2, 
                           StConfigCouplingCh2Rst, StConfigGainCh1, StConfigGainCh1Rst, StConfigGainCh2, 
                           StConfigGainCh2Rst, StPushInitDone, StWaitRdy, StIdle, StError, StWaitAckCouplingCh1, 
                           StChangeCouplingCh1, StWaitAckCouplingCh2, StChangeCouplingCh2, StWaitAckGainCh1, 
                           StChangeGainCh1, StWaitAckGainCh2, StChangeGainCh2, StRstCfgPulse);

type FsmStatesSPI_t is (StIdle, StWrite, StRead1, StRead2, StRead3, StDone, StAssertCS);

type FsmStatesI2C_t is (stIdle, stCheckCmdCnt, stCheckConfigDone, stRegAddress_H, stRegAddress_L, stRegData_H, stRegData_L, 
                           stReadBackAddress_H, stReadBackAddress_L, stReadBackData_H, stReadBackData_L, stCheckReadBackError, stCheckReadBackDone);                                                   
                           
constant kRangeLg : real := 26.25;
constant kRangeHg : real := 1.086;
constant kRangeIdealLg : real := 25.0;
constant kRangeIdealHg : real := 1.0;

-- Function used to determine the Chip ID based on the ZmodIC parameter
-- that identifies the Zmod.
function SelADC_ID(ZmodIC:integer) 
        return std_logic_vector;

-- Function used to determine the Chip grade based on the ZmodIC parameter
-- that identifies the Zmod.
function SelADC_Grade(ZmodIC:integer) 
        return std_logic_vector;

-- Function used to determine the Clock devide ratio field of register 0x0B
-- based on the kADC_ClkDiv generic 
function DetClkDiv(ADC_ClkDiv:integer) 
        return std_logic_vector;         

-- The initiaization command list is different depending on which Zmod is targeted.
-- The SelCmdList function is used to select the appropriate command list based on
-- the ZmodIC parameter.
function SelCmdList(ZmodIC:integer) 
        return ADC_SPI_Commands_t;

-- The initiaization command readback list is different depending on which Zmod is 
-- targeted. The SelCmdList function is used to select the appropriate command list 
-- based on the ZmodIC parameter.
function SelRdbkList(ZmodIC:integer) 
        return ADC_SPI_Readback_t;

-- The OverwriteClkDiv function is used to overwrite the Clock divide ratio field of commad list
-- (CmdList) sent as parameter based on ADC_ClkDiv. It is important to note that the "write
-- Clock Divide register" (address 0x0B) command shares the same position (kCmdClkDivIndex)  in 
-- the command list for the currently supported Zmods.
function OverwriteClkDiv(CmdList:ADC_SPI_Commands_t; ADC_ClkDiv:integer) 
        return ADC_SPI_Commands_t;

-- The OverWriteID_ClkDiv function is used to overwrite the ADC chip ID field of the 
-- command readback list (RdbkList) based on the ZmodIC parameter.
function OverWriteID_ClkDiv(ZmodIC:integer; RdbkList:ADC_SPI_Readback_t; ADC_ClkDiv:integer) 
        return ADC_SPI_Readback_t;

-- The SelCmdWrListLength function is used to detrmine the command list
-- length based on the ZmodIC parameter.
function SelCmdWrListLength(ZmodIC:integer) 
        return integer; 

-- Function used to determine the ADC resolution (kADC_Width) based on the ZmodIC parameter.
-- Used in the top level test bench.
function SelADC_Width(ZmodIC:integer) 
        return integer;
        
-- Function used to compute the IDDR sampling clock phase as a function of the sampling
-- period. This is necessary so the clock phase is always an integer multiple of
-- (45 degrees/output clock division factor) of the MMCM which generates it.
function IDDR_ClockPhase(SamplingPeriod:real) 
        return real;
        
function DCO_ClockPeriod(CDCE_FreqSel:integer)
        return integer;   
                                                       
end PkgZmodDigitizer;

package body PkgZmodDigitizer is

function SelADC_ID(ZmodIC:integer) 
        return std_logic_vector is  
   begin
      case ZmodIC is
         when kZmodDigitizer1430_105 => 
            return AD9648_ID;
         when kZmodDigitizer1030_40 =>
            return AD9204_ID;
         when kZmodDigitizer1030_125 =>
            return AD9608_ID;
         when kZmodDigitizer1230_40 =>
            return AD9231_ID;
         when kZmodDigitizer1230_125 =>
            return AD9628_ID;
         when kZmodDigitizer1430_40 =>
            return AD9251_ID; 
         when kZmodDigitizer1430_125 =>
            return AD9648_ID;
         when others =>
            return x"00";                                                                         
      end case;          
end function;
  
function SelADC_Grade(ZmodIC:integer) 
        return std_logic_vector is  
   begin
      case ZmodIC is
         when kZmodDigitizer1430_105 => 
            return AD9648_Grade;
         when kZmodDigitizer1030_40 =>
            return AD9204_Grade;
         when kZmodDigitizer1030_125 =>
            return AD9608_Grade;
         when kZmodDigitizer1230_40 =>
            return AD9231_Grade;
         when kZmodDigitizer1230_125 =>
            return AD9628_Grade;
         when kZmodDigitizer1430_40 =>
            return AD9251_Grade; 
         when kZmodDigitizer1430_125 =>
            return AD9648_Grade;
         when others =>
            return x"00";                                                                         
      end case;          
end function;

function DetClkDiv(ADC_ClkDiv:integer) 
        return std_logic_vector is
   begin
      if (ADC_ClkDiv = 1) then
         return x"00";
      elsif (ADC_ClkDiv = 2) then   
         return x"01";  
      elsif (ADC_ClkDiv = 3) then   
         return x"02";  
      elsif (ADC_ClkDiv = 4) then   
         return x"03"; 
      elsif (ADC_ClkDiv = 5) then   
         return x"04"; 
      elsif (ADC_ClkDiv = 6) then   
         return x"05";
      elsif (ADC_ClkDiv = 7) then   
         return x"06";
      elsif (ADC_ClkDiv = 8) then   
         return x"07";             
      else
         return x"00";
      end if;          
end function;
  
function SelCmdList(ZmodIC:integer) 
        return ADC_SPI_Commands_t is
   variable CmdListV : ADC_SPI_Commands_t := kAD96xx_SPI_Cmd;     
   begin
      case ZmodIC is
         when kZmodDigitizer1430_105 => 
            CmdListV := kAD96xx_SPI_Cmd;
            return CmdListV;
         when kZmodDigitizer1030_40 =>
            CmdListV := kAD92xx_SPI_Cmd;
            return CmdListV;
         when kZmodDigitizer1030_125 =>
            CmdListV := kAD96xx_SPI_Cmd;
            return CmdListV;
         when kZmodDigitizer1230_40 =>
            CmdListV := kAD92xx_SPI_Cmd;
            return CmdListV;
         when kZmodDigitizer1230_125 =>
            CmdListV := kAD96xx_SPI_Cmd;
            return CmdListV;
         when kZmodDigitizer1430_40 =>
            CmdListV := kAD92xx_SPI_Cmd;
            return CmdListV; 
         when kZmodDigitizer1430_125 =>
            CmdListV := kAD96xx_SPI_Cmd;
            return CmdListV;
         when others =>
            CmdListV := (others => (others => '0'));
            return CmdListV;                                                                         
      end case;          
end function;
  
function SelRdbkList(ZmodIC:integer) 
        return ADC_SPI_Readback_t is
   variable RdbkListV : ADC_SPI_Readback_t := kAD96xx_SPI_Rdbck;     
   begin
      case ZmodIC is
         when kZmodDigitizer1430_105 => 
            RdbkListV := kAD96xx_SPI_Rdbck;
            return RdbkListV;
         when kZmodDigitizer1030_40 =>
            RdbkListV := kAD92xx_SPI_Rdbck;
            return RdbkListV;
         when kZmodDigitizer1030_125 =>
            RdbkListV := kAD96xx_SPI_Rdbck;
            return RdbkListV;
         when kZmodDigitizer1230_40 =>
            RdbkListV := kAD92xx_SPI_Rdbck;
            return RdbkListV;
         when kZmodDigitizer1230_125 =>
            RdbkListV := kAD96xx_SPI_Rdbck;
            return RdbkListV;
         when kZmodDigitizer1430_40 =>
            RdbkListV := kAD92xx_SPI_Rdbck;
            return RdbkListV; 
         when kZmodDigitizer1430_125 =>
            RdbkListV := kAD96xx_SPI_Rdbck;
            return RdbkListV;
         when others =>
            RdbkListV := (others => (others => '0'));
            return RdbkListV;                                                                         
      end case;          
end function;

function OverwriteClkDiv(CmdList:ADC_SPI_Commands_t; ADC_ClkDiv:integer) 
        return ADC_SPI_Commands_t is
   variable CmdListV : ADC_SPI_Commands_t := CmdList;     
   begin
      CmdListV(kCmdClkDivIndex) := CmdList(kCmdClkDivIndex)(23 downto 8) & DetClkDiv(ADC_ClkDiv);
   return CmdListV;       
end function;
 
function OverWriteID_ClkDiv(ZmodIC:integer; RdbkList:ADC_SPI_Readback_t; ADC_ClkDiv:integer) 
        return ADC_SPI_Readback_t is
   variable RdbkListV : ADC_SPI_Readback_t := RdbkList;     
   begin
      RdbkListV(kCmdClkDivIndex) := DetClkDiv(ADC_ClkDiv);
      case ZmodIC is
         when kZmodDigitizer1430_105 => 
            RdbkListV(kCmdReadID_Index) := AD9648_ID;
            return RdbkListV;
         when kZmodDigitizer1030_40 =>
            RdbkListV(kCmdReadID_Index) := AD9204_ID;
            return RdbkListV;
         when kZmodDigitizer1030_125 =>
            RdbkListV(kCmdReadID_Index) := AD9608_ID;
            return RdbkListV;
         when kZmodDigitizer1230_40 =>
            RdbkListV(kCmdReadID_Index) := AD9231_ID;
            return RdbkListV;
         when kZmodDigitizer1230_125 =>
            RdbkListV(kCmdReadID_Index) := AD9628_ID;
            return RdbkListV;
         when kZmodDigitizer1430_40 =>
            RdbkListV(kCmdReadID_Index) := AD9251_ID;
            return RdbkListV; 
         when kZmodDigitizer1430_125 =>
            RdbkListV(kCmdReadID_Index) := AD9648_ID;
            return RdbkListV;
         when others =>
            RdbkListV(kCmdReadID_Index) := x"00";
            return RdbkListV;                                                                         
      end case;          
end function;

function SelCmdWrListLength(ZmodIC:integer) 
        return integer is   
   begin
      case ZmodIC is
         when kZmodDigitizer1430_105 => 
            return kCmdWrTotal_AD9648;
         when kZmodDigitizer1030_40 =>
            return kCmdWrTotal_AD9204;
         when kZmodDigitizer1030_125 =>
            return kCmdWrTotal_AD9608;
         when kZmodDigitizer1230_40 =>
            return kCmdWrTotal_AD9231;
         when kZmodDigitizer1230_125 =>
            return kCmdWrTotal_AD9628;
         when kZmodDigitizer1430_40 =>
            return kCmdWrTotal_AD9251; 
         when kZmodDigitizer1430_125 =>
            return kCmdWrTotal_AD9648;
         when others =>
            return 0;                                                                         
      end case;          
end function;

function SelADC_Width(ZmodIC:integer) 
        return integer is   
   begin
      case ZmodIC is
         when kZmodDigitizer1430_105 => 
            return 14;
         when kZmodDigitizer1030_40 =>
            return 10;
         when kZmodDigitizer1030_125 =>
            return 10;
         when kZmodDigitizer1230_40 =>
            return 12;
         when kZmodDigitizer1230_125 =>
            return 12;
         when kZmodDigitizer1430_40 =>
            return 14; 
         when kZmodDigitizer1430_125 =>
            return 14;
         when others =>
            return 14;                                                                         
      end case;          
end function;

function IDDR_ClockPhase(SamplingPeriod:real) 
        return real is
   begin
      --400MHz to 200MHz
      if ((SamplingPeriod > 2.5) and (SamplingPeriod <= 5.0)) then
         return 120.0;
      --200MHz to 111MHz 
      elsif ((SamplingPeriod > 5.0) and (SamplingPeriod <= 9.0)) then   
         return 127.5;
	  --111MHz to 100MHz 
      elsif ((SamplingPeriod > 9.0) and (SamplingPeriod <= 10.0)) then   
         return 120.0;
      --100MHz to 50MHz    
      elsif ((SamplingPeriod > 10.0) and (SamplingPeriod <= 20.0)) then
         return 123.75;
      --50MHz to 25MHz 
      elsif ((SamplingPeriod > 20.0) and (SamplingPeriod <= 40.0)) then
         return 125.625;       
      --25MHz to 12.5MHz 
      elsif ((SamplingPeriod > 40.0) and (SamplingPeriod <= 80.0)) then
         return 125.625;       
      --12.5MHz to 10MHz 
      elsif (SamplingPeriod > 80.0) then
         return 125.859375; 
      --Out of specifications;               
      else
         return 1.0;
      end if;          
end function;

function DCO_ClockPeriod(CDCE_FreqSel:integer) 
        return integer is
   begin
      --122.88MHz
      if (CDCE_FreqSel = 0) then
         return 8138;--Clock Period in ps
      --50MHz
      elsif (CDCE_FreqSel = 1) then   
         return 20000;--Clock Period in ps
	  --80MHz 
      elsif (CDCE_FreqSel = 2) then   
         return 12500;--Clock Period in ps
      --100MHz   
      elsif (CDCE_FreqSel = 3) then
         return 10000;--Clock Period in ps
      --110MHz
      elsif (CDCE_FreqSel = 4) then
         return 9090;--Clock Period in ps     
      --120MHz
      elsif (CDCE_FreqSel = 5) then
         return 8333;--Clock Period in ps       
      --125MHz
      elsif (CDCE_FreqSel = 6) then
         return 8000;--Clock Period in ps
      --Out of specifications;               
      else
         return 8138;--Clock Period in ps
      end if;          
end function;

end PkgZmodDigitizer;