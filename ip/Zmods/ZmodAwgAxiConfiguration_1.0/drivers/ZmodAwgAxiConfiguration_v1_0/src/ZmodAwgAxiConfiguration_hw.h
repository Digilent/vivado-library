#ifndef ZMOD_AWG_AXI_CONFIGURATION_HW_H_
#define ZMOD_AWG_AXI_CONFIGURATION_HW_H_

#include "xil_types.h"
#include "xil_io.h"

/* Register offsets */
#define ZMOD_AWG_AXI_CONFIGURATION_AP_CTRL_REG_OFFSET 0x0
#define ZMOD_AWG_AXI_CONFIGURATION_GIE_REG_OFFSET 0x4
#define ZMOD_AWG_AXI_CONFIGURATION_IP_INTR_EN_REG_OFFSET 0x8
#define ZMOD_AWG_AXI_CONFIGURATION_IP_INTR_STS_REG_OFFSET 0xc
#define ZMOD_AWG_AXI_CONFIGURATION_CONTROL_REG_OFFSET 0x10
#define ZMOD_AWG_AXI_CONFIGURATION_STATUS_REG_OFFSET 0x18
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH1HGMULTCOEF_REG_OFFSET 0x20
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH1HGADDCOEF_REG_OFFSET 0x28
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH1LGMULTCOEF_REG_OFFSET 0x30
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH1LGADDCOEF_REG_OFFSET 0x38
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH2HGMULTCOEF_REG_OFFSET 0x40
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH2HGADDCOEF_REG_OFFSET 0x48
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH2LGMULTCOEF_REG_OFFSET 0x50
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH2LGADDCOEF_REG_OFFSET 0x58

/* Control Register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_AP_CTRL_START_MASK 0x01
#define ZMOD_AWG_AXI_CONFIGURATION_AP_CTRL_DONE_MASK 0x02
#define ZMOD_AWG_AXI_CONFIGURATION_AP_CTRL_IDLE_MASK 0x04
#define ZMOD_AWG_AXI_CONFIGURATION_AP_CTRL_READY_MASK 0x08
#define ZMOD_AWG_AXI_CONFIGURATION_AP_CTRL_AUTO_RESTART_MASK 0x80

/* Global interrupt enable register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_GIE_ENABLE_MASK 0x01

/* IP interrupt enable register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_IP_INTR_EN_AP_DONE_MASK 0x1
#define ZMOD_AWG_AXI_CONFIGURATION_IP_INTR_EN_AP_READY_MASK 0x2
#define ZMOD_AWG_AXI_CONFIGURATION_IP_INTR_EN_ALL_MASK 0x3

/* IP interrupt status register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_IP_INTR_STS_AP_DONE_MASK 0x1
#define ZMOD_AWG_AXI_CONFIGURATION_IP_INTR_STS_AP_READY_MASK 0x2
/* CONTROL register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_CONTROL_DACENABLE_MASK 0x1
#define ZMOD_AWG_AXI_CONFIGURATION_CONTROL_TESTMODE_MASK 0x2
#define ZMOD_AWG_AXI_CONFIGURATION_CONTROL_EXTCH1SCALE_MASK 0x4
#define ZMOD_AWG_AXI_CONFIGURATION_CONTROL_EXTCH2SCALE_MASK 0x8
/* STATUS register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_STATUS_INITDONEDAC_MASK 0x1
#define ZMOD_AWG_AXI_CONFIGURATION_STATUS_CONFIGERROR_MASK 0x2
/* EXTCH1HGMULTCOEF register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH1HGMULTCOEF_EXTCH1HGMULTCOEF_MASK 0x3ffff
/* EXTCH1HGADDCOEF register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH1HGADDCOEF_EXTCH1HGADDCOEF_MASK 0x3ffff
/* EXTCH1LGMULTCOEF register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH1LGMULTCOEF_EXTCH1LGMULTCOEF_MASK 0x3ffff
/* EXTCH1LGADDCOEF register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH1LGADDCOEF_EXTCH1LGADDCOEF_MASK 0x3ffff
/* EXTCH2HGMULTCOEF register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH2HGMULTCOEF_EXTCH2HGMULTCOEF_MASK 0x3ffff
/* EXTCH2HGADDCOEF register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH2HGADDCOEF_EXTCH2HGADDCOEF_MASK 0x3ffff
/* EXTCH2LGMULTCOEF register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH2LGMULTCOEF_EXTCH2LGMULTCOEF_MASK 0x3ffff
/* EXTCH2LGADDCOEF register bitfields */
#define ZMOD_AWG_AXI_CONFIGURATION_EXTCH2LGADDCOEF_EXTCH2LGADDCOEF_MASK 0x3ffff

#endif /* end of protection macro */
