/************************************************************************/
/*                                                                      */
/*  OLED_Driver.c   -- Graphics Driver Library for OLED Display         */
/*                                                                      */
/************************************************************************/
/*  Author:     Gene Apperson                                           */
/*  Copyright 2011, Digilent Inc.                                       */
/************************************************************************/
/*
  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/
/************************************************************************/
/*  Module Description:                                                 */
/*                                                                      */
/*  This is part of the device driver software for the OLED bit mapped  */
/*  display on the Digilent Basic I/O Shield. This module contains the  */
/*  initialization functions and basic display control functions.       */
/*                                                                      */
/************************************************************************/
/*  Revision History:                                                   */
/*                                                                      */
/*  04/29/2011(GeneA): Created                                          */
/*  08/03/2011(GeneA): added functions to shut down the display and to  */
/*      turn the display on and off.                                    */
/*  06/20/2016(ArtVVB): edited for PmodOLED IP                          */
/*                                                                      */
/*  12/15/2016(jPeyron) edited for better use for OnboardOLED in        */
/*                      as well as inverting the white and black        */
/*  10/31/2017(ArtVVB): 2016.4 Maintenance, replaced OLED_Delay with    */
/*                      usleep                                          */
/*  08/09/2023(MihaiR): edited the init and term functions so they      */
/*                      have the proper instructions for startup and    */
/*                      shut down while minimizing backpowering, some   */
/*                      of the functions had minor changes such as      */
/*                      changing the order in which                     */
/*                      their instructions were called                  */
/************************************************************************/


/* ------------------------------------------------------------ */
/*              Include File Definitions                        */
/* ------------------------------------------------------------ */

#include "PmodOLED.h"
#include "ChrFont0.c"
#include "FillPat.c"
#include "sleep.h"

/* ------------------------------------------------------------ */
/*              Local Symbol Definitions                        */
/* ------------------------------------------------------------ */

#define cmdOledDisplayOn       0xAF
#define cmdOledDisplayOff      0xAE
#define cmdOledSegRemap        0xA1 //map column 127 to SEG0
#define cmdOledComDir          0xC8 //scan from COM[N-1] to COM0
#define cmdOledComConfig       0xDA //set COM hardware configuration
#define DispContrast1          0x81
#define DispContrast2          0x0F
#define SetSegRemap            0xA0
#define SetScanDirection       0xC0
#define SetLowerColumnAddress  0xDA
#define LowerColumnAddress     0x02

/* Setting pins based on DSPI_SS pin plus offset to get to lower 4 pins
** on pmod connector
*/
#define DataCmd     0x1
#define Reset       0x2
#define VbatCtrl    0x4
#define VddCtrl     0x8

/* ------------------------------------------------------------ */
/*              Local Variables                                 */
/* ------------------------------------------------------------ */

/* This array is the offscreen frame buffer used for rendering.
** It isn't possible to read back frome the OLED display device,
** so display data is rendered into this offscreen buffer and then
** copied to the display.
*/
extern const u8 rgbFillPat[];

/* ------------------------------------------------------------ */
/*              Forward Declarations                            */
/* ------------------------------------------------------------ */

void    OLED_HostInit   (PmodOLED *InstancePtr, u32 GPIO_Address, u32 SPI_Address);
void    OLED_HostTerm   (PmodOLED *InstancePtr);
void    OLED_DevInit    (PmodOLED *InstancePtr,u8 orientation, u8 invert);
void    OLED_DevTerm    (PmodOLED *InstancePtr);
void    OLED_DvrInit    (PmodOLED *InstancePtr);

void    OLED_PutBuffer  (PmodOLED *InstancePtr, int cb, uint8_t *rgbTx);
//uint8_t   Spi2PutByte     (uint8_t bVal);

/* ------------------------------------------------------------ */
/*              Procedure Definitions                           */
/* ------------------------------------------------------------ */
/***    OLED_Init
**
**  Parameters:
**      InstancePtr - pointer to SPI handler and OLED data
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Initialize the OLED display subsystem.
*/

void OLED_Init(PmodOLED *InstancePtr, u32 GPIO_Address, u32 SPI_Address, u8 orientation, u8 invert)
{

    /* Init the memory variables used to control access to the
    ** display.
    */
    OLED_DvrInit(InstancePtr);
    
    /* Init the PIC32 peripherals used to talk to the display.
    */
    OLED_HostInit(InstancePtr, GPIO_Address, SPI_Address);

    /* Init the OLED display hardware.
    */
    OLED_DevInit(InstancePtr, orientation, invert);

    /* Clear the display.
    */
    OLED_Clear(InstancePtr);

}

/* ------------------------------------------------------------ */
/***    OLED_Term
**
**  Parameters:
**      InstancePtr - pointer to SPI handler and OLED data
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Shut down the OLED display.
*/

void OLED_Term(PmodOLED *InstancePtr)
{

    /* Shut down the OLED display hardware.
    */
    OLED_DevTerm(InstancePtr);

    /* Release the PIC32 peripherals being used.
    */
    OLED_HostTerm(InstancePtr);

}

/* ------------------------------------------------------------ */
/***    OLED_HostInit
**
**  Parameters:
**      InstancePtr - pointer to SPI handler and OLED data
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Perform PIC32 device initialization to prepare for use
**      of the OLED display.
**      This is currently hard coded for the Cerebot 32MX4 and
**      SPI2. This needs to be generalized.
*/

void OLED_HostInit(PmodOLED *InstancePtr, u32 GPIO_Address, u32 SPI_Address)
{
    InstancePtr->GPIO_addr=GPIO_Address;
    OLEDConfig.BaseAddress=SPI_Address;
    
    //All GPIO pins are set as outputs
    OLED_SetGPIOTristateBits(InstancePtr, 0xF, 0b0);
    //Set VBAT and VDD to high so they are not powering yet the OLED
    OLED_SetGPIOBits(InstancePtr, VbatCtrl | VddCtrl, 0b1);
    //Set Reset and DataCmd to low so the OLED is set to command mode and is held in Reset
    OLED_SetGPIOBits(InstancePtr, Reset | DataCmd, 0b0);
    
    if (XST_SUCCESS != OLED_SPIInit(&InstancePtr->OLEDSpi))
        xil_printf("SPI Initialization failed\n\r");
}

/* ------------------------------------------------------------ */
/***    OLED_HostTerm
**
**  Parameters:
**      InstancePtr - pointer to SPI handler and OLED data
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Release processor resources used by the library
*/

void OLED_HostTerm(PmodOLED *InstancePtr)
    {
    // Disable SPI interface, put SCLK, SDIN and CS into tristate
    XSpi_Stop(&InstancePtr->OLEDSpi);

    ///* Make the Data/Command select and Reset pins be inputs.
    //*/
    OLED_SetGPIOTristateBits(InstancePtr, DataCmd | Reset, 0b1);
    OLED_SetGPIOBits(InstancePtr, DataCmd | Reset, 0b1);

    /* Turn off VBAT and wait for 3.5 seconds for VCC to ramp down
    */
    OLED_SetGPIOBits(InstancePtr, VbatCtrl, 0b1);
    usleep(3500000);

    /* Turn off VDD
    */
    OLED_SetGPIOBits(InstancePtr, VddCtrl, 0b1);
    
    // Put VDD and VBAT in tristate
    OLED_SetGPIOTristateBits(InstancePtr, VddCtrl | VbatCtrl, 0b1);
}

/* ------------------------------------------------------------ */
/***    OLED_DvrInit
**
**  Parameters:
**      InstancePtr - pointer to SPI handler and OLED data
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Initialize the OLED software system
*/

void OLED_DvrInit(PmodOLED *InstancePtr)
    {
    int   ib;
    OLED *OledPtr = &(InstancePtr->OLEDState);

    /* Init the parameters for the default font
    */
    OledPtr->dxcoOledFontCur = cbOledChar;
    OledPtr->dycoOledFontCur = 8;
    OledPtr->pbOledFontCur = (uint8_t*)(rgbOledFont0);
    OledPtr->pbOledFontUser = InstancePtr->OLEDState.rgbOledFontUser;

    for (ib = 0; ib < cbOledFontUser; ib++) {
        OledPtr->rgbOledFontUser[ib] = 0;
    }

    OledPtr->xchOledMax = ccolOledMax / OledPtr->dxcoOledFontCur;
    OledPtr->ychOledMax = crowOledMax / OledPtr->dycoOledFontCur;

    /* Set the default character cursor position.
    */
    OLED_SetCursor(InstancePtr, 0, 0);

    /* Set the default foreground draw color and fill pattern
    */
    OledPtr->clrOledCur = 0x01;
    OledPtr->pbOledPatCur = (uint8_t*)rgbFillPat;
    OLED_SetDrawMode(InstancePtr, modOledSet);

    /* Default the character routines to automaticall
    ** update the display.
    */
    OledPtr->fOledCharUpdate = 1;
}

/* ------------------------------------------------------------ */
/***    OLED_DevInit
**
**  Parameters:
**      InstancePtr - pointer to SPI handler and OLED data
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Initialize the OLED display controller and turn the display on.
*/

void OLED_DevInit(PmodOLED *InstancePtr, u8 orientation, u8 invert)
    {
    /* Turn on the VDD and wait 1 ms for the power to go up
    */
    OLED_SetGPIOBits(InstancePtr, VddCtrl, 0b0);
    usleep(1000);


    /* Set Reset off for 1 ms, send the display off command and turn Reset on for 1ms then keep Reset off
    */
    OLED_SetGPIOBits(InstancePtr, Reset, 0b1);
    usleep(1000);
    OLED_DisplayOff(InstancePtr);
    OLED_SetGPIOBits(InstancePtr, Reset, 0b0);
    usleep(1000);
    OLED_SetGPIOBits(InstancePtr, Reset, 0b1);
    usleep(1000);
    
    
    /* Send the Set Charge Pump and Set Pre-Charge Period commands
    */
    OLED_WriteByte(InstancePtr, 0x8D);//From Univision data sheet, not in SSD1306 data sheet
    OLED_WriteByte(InstancePtr, 0x14);

    OLED_WriteByte(InstancePtr, 0xD9);//From Univision data sheet, not in SSD1306 data sheet
    OLED_WriteByte(InstancePtr, 0xF1);

    // Send the commands to invert the display for onboard OLED or upside down for PmodOLED.
    // uncomment/comment the next 6 lines if you are using the PmodOLED right side up

    if(orientation)
    {

        OLED_WriteByte(InstancePtr, DispContrast1); /* DispContrast 1 */
        OLED_WriteByte(InstancePtr, DispContrast2); /* DispContrast 2 */
        OLED_WriteByte(InstancePtr, SetSegRemap); /* SetSegRemap */
        OLED_WriteByte(InstancePtr, SetScanDirection); /* SetScanDirection /*/
        OLED_WriteByte(InstancePtr, SetLowerColumnAddress); /* Set Lower Column Address command */
        OLED_WriteByte(InstancePtr, LowerColumnAddress); /* Lower Column Address */
    }else
    {

        // Send the commands to invert the display for PmodOLED or upside down for onboardOLED.
        // uncomment/comment the next 4 lines if you are using the PmodOLED right side up

        OLED_WriteByte(InstancePtr, cmdOledSegRemap);//remap columns
        OLED_WriteByte(InstancePtr, cmdOledComDir);//remap the rows

        /* Send the commands to select sequential COM configuration
        */
        OLED_WriteByte(InstancePtr, cmdOledComConfig);//set COM configuration command
        OLED_WriteByte(InstancePtr, 0x20);//sequential COM, left/right remap enabled

    }

    if(invert)
        OLED_WriteByte(InstancePtr, 0xA7);//invert white/black
    else
        OLED_WriteByte(InstancePtr, 0xA6);//invert black/white

    /* Turn on VBAT and wait 100ms
    */
    OLED_SetGPIOBits(InstancePtr, VbatCtrl, 0b0);
    usleep(100000);
    
    /* Send Display On command
    */
    OLED_WriteByte(InstancePtr, cmdOledDisplayOn);
}

/* ------------------------------------------------------------ */
/***    OLED_DevTerm
**
**  Parameters:
**      InstancePtr - pointer to SPI handler and OLED data
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Shut down the OLED display hardware
*/

void OLED_DevTerm(PmodOLED *InstancePtr)
    {
    /* Send the Display Off command.
    */
    OLED_DisplayOff(InstancePtr);
}

/* ------------------------------------------------------------ */
/***    OLED_DisplayOn
**
**  Parameters:
**      InstancePtr - pointer to SPI handler and OLED data
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Turn the display on. This assumes that the display has
**      already been powered on and initialized. All it does
**      is send the display on command.
*/

void OLED_DisplayOn(PmodOLED *InstancePtr)
{
    OLED_SetGPIOBits(InstancePtr, DataCmd, 0b0);
    OLED_WriteByte(InstancePtr, cmdOledDisplayOn);
}

/* ------------------------------------------------------------ */
/***    OLED_DisplayOff
**
**  Parameters:
**      InstancePtr - pointer to SPI handler and OLED data
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Turn the display off. This does not power the display
**      down. All it does is send the display off command.
*/

void OLED_DisplayOff(PmodOLED *InstancePtr)
{
    OLED_SetGPIOBits(InstancePtr, DataCmd, 0b0);
    OLED_WriteByte(InstancePtr, cmdOledDisplayOff);
}

/* ------------------------------------------------------------ */
/***    OLED_Clear
**
**  Parameters:
**      InstancePtr - pointer to SPI handler and OLED data
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Clear the display. This clears the memory buffer and then
**      updates the display.
*/

void OLED_Clear(PmodOLED *InstancePtr)
{
    OLED_ClearBuffer(InstancePtr);
    OLED_Update(InstancePtr);
}

/* ------------------------------------------------------------ */
/***    OLED_ClearBuffer
**
**  Parameters:
**      InstancePtr - pointer to SPI handler and OLED data
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Clear the display memory buffer.
*/

void OLED_ClearBuffer(PmodOLED *InstancePtr)
{
    OLED    *OledPtr = &(InstancePtr->OLEDState);
    int      ib;
    uint8_t *pb;

    pb = OledPtr->rgbOledBmp;

    /* Fill the memory buffer with 0.
    */
    for (ib = 0; ib < cbOledDispMax; ib++) {
        *pb++ = 0x00;
    }
}

/* ------------------------------------------------------------ */
/***    OLED_Update
**
**  Parameters:
**      InstancePtr - pointer to SPI handler and OLED data
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Update the OLED display with the contents of the memory buffer
*/

void OLED_Update(PmodOLED *InstancePtr)
{
    int      ipag;
    int      icol;
    uint8_t *pb;

    pb = InstancePtr->OLEDState.rgbOledBmp;
    for (ipag = 0; ipag < cpagOledMax; ipag++) {
        OLED_SetGPIOBits(InstancePtr, DataCmd, 0b0);

        /* Set the page address
        */
        OLED_WriteByte(InstancePtr, 0x22);
        OLED_WriteByte(InstancePtr, ipag);

        /* Start at the left column
        */
        OLED_WriteByte(InstancePtr, 0x00);
        OLED_WriteByte(InstancePtr, 0x10);

        OLED_SetGPIOBits(InstancePtr, DataCmd, 0b1);

        /* Copy this memory page of display data.
        */
        OLED_PutBuffer(InstancePtr, ccolOledMax, pb);
        pb += ccolOledMax;
    }
}

/* ------------------------------------------------------------ */
/***    OLED_PutBuffer
**
**  Parameters:
**      InstancePtr - pointer to SPI handler and OLED data
**      cb      - number of bytes to send/receive
**      rgbTx   - pointer to the buffer to send
**
**  Return Value:
**      none
**
**  Errors:
**      none
**
**  Description:
**      Send the bytes specified in rgbTx to the slave and return
**      the bytes read from the slave in rgbRx
*/
void OLED_PutBuffer(PmodOLED *InstancePtr, int cb, uint8_t *rgbTx)
{
    int ib;
    /* Write/Read the data
    */
    for (ib = 0; ib < cb; ib++) {
        OLED_WriteByte(InstancePtr, *rgbTx++);
    }
}

/************************************************************************/