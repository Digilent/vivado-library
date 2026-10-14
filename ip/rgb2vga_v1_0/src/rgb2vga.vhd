-------------------------------------------------------------------------------
--
-- File: rgb2vga.vhd
-- Author: Elod Gyorgy
-- Original Project: Genesys 2 demo project
-- Date: 20 March 2015
--
-------------------------------------------------------------------------------
-- (c) 2015 Copyright Digilent Incorporated
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
-- Purpose:
-- To provide a properly blanked vga signal from an rgb interface
--  
-------------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY RGB2VGA IS
  GENERIC (
    VID_IN_DATA_WIDTH : NATURAL := 24;
    KREDDEPTH         : NATURAL := 4;
    KGREENDEPTH       : NATURAL := 4;
    KBLUEDEPTH        : NATURAL := 4
    );
  PORT (
    RGB_pData  : IN STD_LOGIC_VECTOR(VID_IN_DATA_WIDTH-1 DOWNTO 0);
    RGB_pVDE   : IN STD_LOGIC;
    RGB_pHSync : IN STD_LOGIC;
    RGB_pVSync : IN STD_LOGIC;

    PixelClk       : IN  STD_LOGIC;     --pixel clock
    resetn         : IN  std_logic;
    --VGA_OUT_clk : OUT std_logic;
    -- VGA_OUT_de  : OUT std_logic;
    VGA_OUT_RED   : OUT STD_LOGIC_VECTOR(KREDDEPTH-1 DOWNTO 0);
    VGA_OUT_GREEN : OUT STD_LOGIC_VECTOR(KGREENDEPTH-1 DOWNTO 0);
    VGA_OUT_BLUE  : OUT STD_LOGIC_VECTOR(KBLUEDEPTH-1 DOWNTO 0);
    VGA_OUT_HSYNC : OUT STD_LOGIC;
    VGA_OUT_VSYNC : OUT STD_LOGIC
    );
END RGB2VGA;

ARCHITECTURE Behavioral OF RGB2VGA IS
  SIGNAL int_pData : STD_LOGIC_VECTOR(VID_IN_DATA_WIDTH-1 DOWNTO 0);

BEGIN

  Blanking : PROCESS(PixelClk, resetn)
  BEGIN
    if (resetn = '1') then
    IF Rising_Edge(PixelClk) THEN
        IF (RGB_pVDE = '1') THEN
            int_pData <= RGB_pData;
        ELSE
            int_pData <= (OTHERS => '0');
    END IF;
        VGA_OUT_HSYNC <= RGB_pHSync;
        VGA_OUT_VSYNC <= RGB_pVSync;
    END IF;
    else
        int_pData <= (OTHERS => '0');
        end if;
  END PROCESS Blanking;

  VGA_OUT_RED   <= int_pData(VID_IN_DATA_WIDTH-1 DOWNTO VID_IN_DATA_WIDTH - KREDDEPTH);
  VGA_OUT_BLUE  <= int_pData(VID_IN_DATA_WIDTH/3*2-1 DOWNTO VID_IN_DATA_WIDTH/3*2 - KBLUEDEPTH);
  VGA_OUT_GREEN <= int_pData(VID_IN_DATA_WIDTH/3-1 DOWNTO VID_IN_DATA_WIDTH/3 - KGREENDEPTH);
END Behavioral;
