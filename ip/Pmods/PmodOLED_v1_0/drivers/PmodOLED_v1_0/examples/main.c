/******************************************************************************/
/*                                                                            */
/* main.c -- Demo project for the PmodOLED IP                                 */
/*                                                                            */
/******************************************************************************/
/* Author: Arthur Brown                                                       */
/* Copyright 2016, Digilent Inc.                                              */
/******************************************************************************/
/* File Description:                                                          */
/*                                                                            */
/* This demo_project initializes and uses the PmodOLED to display strings     */
/* and show different available fill patterns.                                */
/*                                                                            */
/* In order to properly quit the demo, a serial terminal application should   */
/* be connected to your board over UART at the appropriate Baud rate, as      */
/* specified below.                                                           */
/*                                                                            */
/******************************************************************************/
/* Revision History:                                                          */
/*                                                                            */
/*    06/20/2016(ArtVVB):   Created                                           */
/*    12/15/2016(jPeyron):  Edited for better use for OnboardOLED in, as well */
/*                          as inverting the white and black                  */
/*    08/25/2017(ArtVVB):   Added proper cache management functions           */
/*    02/17/2018(atangzwj): Validated for Vivado 2017.4                       */
/*                                                                            */
/******************************************************************************/
/* Baud Rates:                                                                */
/*                                                                            */
/*    Microblaze: 9600 or what was specified in UARTlite core                 */
/*    Zynq: 115200                                                            */
/*                                                                            */
/******************************************************************************/

/* ------------------------------------------------------------ */
/*                  Include File Definitions                    */
/* ------------------------------------------------------------ */

#include <stdio.h>
#include "PmodOLED.h"
#include "sleep.h"
#include "xil_cache.h"
#include "xil_printf.h"
#include "xparameters.h"

/* ------------------------------------------------------------ */
/*                  Global Variables                            */
/* ------------------------------------------------------------ */

PmodOLED myDevice;

/* ------------------------------------------------------------ */
/*                  Forward Declarations                        */
/* ------------------------------------------------------------ */

void DemoInitialize();
void DemoRun();
void DemoCleanup();
void EnableCaches();
void DisableCaches();

// To change between PmodOLED and OnBoardOLED is to change Orientation
const u8 orientation = 0x0; // Set up for Normal PmodOLED(false) vs normal
                            // Onboard OLED(true)
const u8 invert = 0x0; // true = whitebackground/black letters
                       // false = black background /white letters

/* ------------------------------------------------------------ */
/*                  Function Definitions                        */
/* ------------------------------------------------------------ */

int main() {
   DemoInitialize();
   DemoRun();
   DemoCleanup();

   // Microblaze applications can automatically reboot on exit. Prevent
   // this by looping indefinitely, giving the user time to power off the board.
   while (1);

   return 0;
}

void DemoInitialize() {
   EnableCaches();
   OLED_Begin(&myDevice, XPAR_PMODOLED_0_AXI_LITE_GPIO_BASEADDR,
         XPAR_PMODOLED_0_AXI_LITE_SPI_BASEADDR, orientation, invert);
}

/* ------------------------------------------------------------ */
/*** DemoRun()
**
**   Parameters:
**      none
**
**   Return Value:
**      none
**
**   Errors:
**      If the demo is shut down without properly exiting, does not reinitialize
**      properly.
**
**   Description:
**      Displays Demo message and each available Fill Pattern.
**      Pauses between runs to check if user wants to continue, if not, exits.
**      To be safe, exit through prompt before closing demo.
**      Requires UART connection to terminal program on PC.
*/
void DemoRun() {
   int irow, ib, i;
   u8 *pat;
   char c;

   xil_printf("UART and SPI opened for PmodOLED Demo\n\r");

   while (1) {
      xil_printf("entering loop\r\n");
      // Choosing Fill pattern 0
      pat = OLED_GetStdPattern(0);
      OLED_SetFillPattern(&myDevice, pat);
      // Turn automatic updating off
      OLED_SetCharUpdate(&myDevice, 0);

      // Draw a rectangle over writing then slide the rectangle down slowly
      // displaying all writing
      for (irow = 0; irow < OledRowMax; irow++) {
         OLED_ClearBuffer(&myDevice);
         OLED_SetCursor(&myDevice, 0, 0);
         OLED_PutString(&myDevice, "PmodOLED");
         OLED_SetCursor(&myDevice, 0, 1);
         OLED_PutString(&myDevice, "by Digilent");
         OLED_SetCursor(&myDevice, 0, 2);
         OLED_PutString(&myDevice, "Simple Demo");

         OLED_MoveTo(&myDevice, 0, irow);
         OLED_FillRect(&myDevice, 127, 31);
         OLED_MoveTo(&myDevice, 0, irow);
         OLED_LineTo(&myDevice, 127, irow);
         OLED_Update(&myDevice);
         usleep(100000);
      }

      sleep(1);
      // Blink the display three times.
      for (i = 0; i < 3; i++) {
         OLED_DisplayOff(&myDevice);
         usleep(500000);
         OLED_DisplayOn(&myDevice);
         usleep(500000);
      }
      sleep(2);

      // Now erase the characters from the display
      for (irow = OledRowMax - 1; irow >= 0; irow--) {
         OLED_SetDrawColor(&myDevice, 1);
         OLED_SetDrawMode(&myDevice, OledModeSet);
         OLED_MoveTo(&myDevice, 0, irow);
         OLED_LineTo(&myDevice, 127, irow);
         OLED_Update(&myDevice);
         usleep(25000);
         OLED_SetDrawMode(&myDevice, OledModeXor);
         OLED_MoveTo(&myDevice, 0, irow);
         OLED_LineTo(&myDevice, 127, irow);
         OLED_Update(&myDevice);
      }

      sleep(1);

      // Draw a rectangle in center of screen
      // Display the 8 different patterns available
      OLED_SetDrawMode(&myDevice, OledModeSet);

      for (ib = 1; ib < 8; ib++) {
         OLED_ClearBuffer(&myDevice);
         pat = OLED_GetStdPattern(ib);
         OLED_SetFillPattern(&myDevice, pat);
         OLED_MoveTo(&myDevice, 55, 1);
         OLED_FillRect(&myDevice, 75, 27);
         OLED_DrawRect(&myDevice, 75, 27);
         OLED_Update(&myDevice);

         sleep(1);
      }

#ifdef __MICROBLAZE__
      c = 'q';
#else
      xil_printf("(q)uit or any key to continue:\n\r");
      c = inbyte();
#endif

      if (c == 'q' || c == 'Q')
         break;
   }
   xil_printf("Exiting PmodOLED Demo\n\r");
}

void DemoCleanup() {
   OLED_End(&myDevice);
   DisableCaches();
}

void EnableCaches() {
#ifdef __MICROBLAZE__
#ifdef XPAR_MICROBLAZE_USE_ICACHE
   Xil_ICacheEnable();
#endif
#ifdef XPAR_MICROBLAZE_USE_DCACHE
   Xil_DCacheEnable();
#endif
#endif
}

void DisableCaches() {
#ifdef __MICROBLAZE__
#ifdef XPAR_MICROBLAZE_USE_DCACHE
   Xil_DCacheDisable();
#endif
#ifdef XPAR_MICROBLAZE_USE_ICACHE
   Xil_ICacheDisable();
#endif
#endif
}
