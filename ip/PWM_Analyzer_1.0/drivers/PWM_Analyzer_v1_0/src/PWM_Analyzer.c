/******************************************************************************/
/*                                                                            */
/* PWM_Analyzer.c -- Driver definitions for the PWM_Analyzer IP               */
/*                                                                            */
/******************************************************************************/
/* Author: Arvin Tang                                                         */
/*                                                                            */
/******************************************************************************/
/* File Description:                                                          */
/*                                                                            */
/* This file contains the drivers for the PWM_Analyzer IP from Digilent.      */
/*                                                                            */
/******************************************************************************/
/* Revision History:                                                          */
/*                                                                            */
/*    09/12/2017(atangzwj): Created                                           */
/*                                                                            */
/******************************************************************************/

/************ Include Files ************/

#include "PWM_Analyzer.h"
#include "xil_io.h"


/************ Function Definitions ************/

/*
 * u32 PWM_Analyzer_GetDutyCycle_percent(u32 baseAddr)
 * double PWM_Analyzer_GetDutyCycle_decFrac(u32 baseAddr)
 * -----------------------------------------------------------------------------
 * Parameters:
 *       baseAddr: Base address of PWM_Analyzer registers
 *
 * Return:
 *       Duty cycle of PWM signal, based on most recent period
 *        - percentage rounded to nearest integer
 *        - decimal-fraction rounded to 2 decimal places
 *       0 if nothing has been measured since reset
 *
 * Description:
 *       Return duty cycle of PWM signal as
 *        - percentage (out of 100)
 *        - decimal-fraction (out of 1)
 */
u32 PWM_Analyzer_GetDutyCycle_percent(u32 baseAddr) {
   u64 on_time = (u64) PWM_Analyzer_GetOnTime_clkEdges(baseAddr);
   u32 period = PWM_Analyzer_GetPeriod_clkEdges(baseAddr);
   if (period == 0)
      return 0;
   return (u32) (on_time * 1000 / period + 5) / 10;
}

double PWM_Analyzer_GetDutyCycle_decFrac(u32 baseAddr) {
   return PWM_Analyzer_GetDutyCycle_percent(baseAddr) / 100.0;
}

/*
 * u32 PWM_Analyzer_GetOffTime_ms(u32 baseAddr, int clk_freq)
 * u32 PWM_Analyzer_GetOnTime_ms(u32 baseAddr, int clk_freq)
 * u32 PWM_Analyzer_GetPeriod_ms(u32 baseAddr, int clk_freq)
 * -----------------------------------------------------------------------------
 * Parameters:
 *       baseAddr: Base address of PWM_Analyzer registers
 *       clk_freq: Frequency of the PWM_Analyzer's clock in Hz
 *
 * Return:
 *       Duration of most recent off time, on time, or period in milliseconds
 *
 * Description:
 *       Return the duration, in milliseconds, of the most recent
 *        - off time (PWM is low/off),
 *        - on time  (PWM is high/on),
 *        - period   (posedge to posedge / negedge to negedge)
 */
u32 PWM_Analyzer_GetOffTime_ms(u32 baseAddr, int clk_freq) {
   u64 clk_edges = (u64) PWM_Analyzer_GetOffTime_clkEdges(baseAddr);
   return (u32) (clk_edges * 10000 / clk_freq + 5) / 10;
}

u32 PWM_Analyzer_GetOnTime_ms(u32 baseAddr, int clk_freq) {
   u64 clk_edges = (u64) PWM_Analyzer_GetOnTime_clkEdges(baseAddr);
   return (u32) (clk_edges * 10000 / clk_freq + 5) / 10;
}

u32 PWM_Analyzer_GetPeriod_ms(u32 baseAddr, int clk_freq) {
   u64 clk_edges = (u64) PWM_Analyzer_GetPeriod_clkEdges(baseAddr);
   return (u32) (clk_edges * 10000 / clk_freq + 5) / 10;
}

/*
 * u32 PWM_Analyzer_GetOffTime_us(u32 baseAddr, int clk_freq)
 * u32 PWM_Analyzer_GetOnTime_us(u32 baseAddr, int clk_freq)
 * u32 PWM_Analyzer_GetPeriod_us(u32 baseAddr, int clk_freq)
 * -----------------------------------------------------------------------------
 * Parameters:
 *       baseAddr: Base address of PWM_Analyzer registers
 *       clk_freq: Frequency of the PWM_Analyzer's clock in Hz
 *
 * Return:
 *       Duration of most recent off time, on time, or period in microseconds
 *
 * Description:
 *       Return the duration, in microseconds, of the most recent
 *        - off time (PWM is low/off),
 *        - on time  (PWM is high/on),
 *        - period   (posedge to posedge / negedge to negedge)
 */
u32 PWM_Analyzer_GetOffTime_us(u32 baseAddr, int clk_freq) {
   u64 clk_edges = (u64) PWM_Analyzer_GetOffTime_clkEdges(baseAddr);
   return (u32) (clk_edges * 10000000 / clk_freq + 5) / 10;
}

u32 PWM_Analyzer_GetOnTime_us(u32 baseAddr, int clk_freq) {
   u64 clk_edges = (u64) PWM_Analyzer_GetOnTime_clkEdges(baseAddr);
   return (u32) (clk_edges * 10000000 / clk_freq + 5) / 10;
}

u32 PWM_Analyzer_GetPeriod_us(u32 baseAddr, int clk_freq) {
   u64 clk_edges = (u64) PWM_Analyzer_GetPeriod_clkEdges(baseAddr);
   return (u32) (clk_edges * 10000000 / clk_freq + 5) / 10;
}

/*
 * u32 PWM_Analyzer_GetOffTime_ns(u32 baseAddr, int clk_freq)
 * u32 PWM_Analyzer_GetOnTime_ns(u32 baseAddr, int clk_freq)
 * u32 PWM_Analyzer_GetPeriod_ns(u32 baseAddr, int clk_freq)
 * -----------------------------------------------------------------------------
 * Parameters:
 *       baseAddr: Base address of PWM_Analyzer registers
 *       clk_freq: Frequency of the PWM_Analyzer's clock in Hz
 *
 * Return:
 *       Duration of most recent off time, on time, or period in nanoseconds
 *
 * Description:
 *       Return the duration, in nanoseconds, of the most recent
 *        - off time (PWM is low/off),
 *        - on time  (PWM is high/on),
 *        - period   (posedge to posedge / negedge to negedge)
 */
u32 PWM_Analyzer_GetOffTime_ns(u32 baseAddr, int clk_freq) {
   u64 clk_edges = (u64) PWM_Analyzer_GetOffTime_clkEdges(baseAddr);
   return (u32) (clk_edges * 10000000000 / clk_freq + 5) / 10;
}

u32 PWM_Analyzer_GetOnTime_ns(u32 baseAddr, int clk_freq) {
   u64 clk_edges = (u64) PWM_Analyzer_GetOnTime_clkEdges(baseAddr);
   return (u32) (clk_edges * 10000000000 / clk_freq + 5) / 10;
}

u32 PWM_Analyzer_GetPeriod_ns(u32 baseAddr, int clk_freq) {
   u64 clk_edges = (u64) PWM_Analyzer_GetPeriod_clkEdges(baseAddr);
   return (u32) (clk_edges * 10000000000 / clk_freq + 5) / 10;
}

/*
 * u32 PWM_Analyzer_GetOffTime_clkEdges(u32 baseAddr)
 * u32 PWM_Analyzer_GetOnTime_clkEdges(u32 baseAddr)
 * u32 PWM_Analyzer_GetPeriod_clkEdges(u32 baseAddr)
 * -----------------------------------------------------------------------------
 * Parameters:
 *       baseAddr: Base address of PWM_Analyzer registers
 *
 * Return:
 *       Number of clock edges during most recent off time, on time, or period
 *
 * Description:
 *       Return the number of clock edges that occurred during the most recent
 *        - off time (PWM is low/off),
 *        - on time  (PWM is high/on),
 *        - period   (posedge to posedge / negedge to negedge)
 */
u32 PWM_Analyzer_GetOffTime_clkEdges(u32 baseAddr) {
   return Xil_In32(baseAddr + PWM_ANALYZER_OFF_TIME_OFFSET);
}

u32 PWM_Analyzer_GetOnTime_clkEdges(u32 baseAddr) {
   return Xil_In32(baseAddr + PWM_ANALYZER_ON_TIME_OFFSET);
}

u32 PWM_Analyzer_GetPeriod_clkEdges(u32 baseAddr) {
   return Xil_In32(baseAddr + PWM_ANALYZER_PERIOD_OFFSET);
}
