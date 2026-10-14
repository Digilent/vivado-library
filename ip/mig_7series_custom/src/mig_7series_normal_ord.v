//*****************************************************************************
// (c) Copyright 2023 Advanced Micro Devices, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//*****************************************************************************
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor             : AMD
// \   \   \/     Version            : 4.2
//  \   \         Application        : MIG
//  /   /         Filename           : mig_7series_normal_ord.v
// /___/   /\     Date Last Modified : $Date: 2011/06/02 08:35:03 $
// \   \  /  \    Date Created       : Fri Oct 14 2011
//  \___\/\___\
//
// Device           : 7 Series
// Design Name      : DDR2 SDRAM
// Purpose          :
//   Wrapper module for the user design top level file. This module can be 
//   instantiated in the system and interconnect as shown in example design 
//   (example_top module).
// Reference        :
// Revision History :
//*****************************************************************************

`timescale 1ps/1ps

module mig_7series_normal_ord #(

      parameter RST_ACT_LOW           = 1,
                                     // =1 for active low reset,
                                     // =0 for active high.
   //***************************************************************************
   // The following parameters refer to width of various ports
   //***************************************************************************
   parameter BANK_WIDTH            = 3,
                                     // # of memory Bank Address bits.
   parameter CK_WIDTH              = 1,
                                     // # of CK/CK# outputs to memory.
   parameter COL_WIDTH             = 10,
                                     // # of memory Column Address bits.
   parameter CS_WIDTH              = 1,
                                     // # of unique CS outputs to memory.
   parameter nCS_PER_RANK          = 1,
                                     // # of unique CS outputs per rank for phy
   parameter CKE_WIDTH             = 1,
                                     // # of CKE outputs to memory.
   parameter DATA_BUF_ADDR_WIDTH   = 5,
   parameter DQ_CNT_WIDTH          = 4,
                                     // = ceil(log2(DQ_WIDTH))
   parameter DQ_PER_DM             = 8,
   parameter DM_WIDTH              = 2,
                                     // # of DM (data mask)
   parameter DQ_WIDTH              = 16,
                                     // # of DQ (data)
   parameter DQS_WIDTH             = 2,
   parameter DQS_CNT_WIDTH         = 1,
                                     // = ceil(log2(DQS_WIDTH))
   parameter DRAM_WIDTH            = 8,
                                     // # of DQ per DQS
   parameter ECC                   = "OFF",
   parameter DATA_WIDTH            = 16,
   parameter ECC_TEST              = "OFF",
   parameter PAYLOAD_WIDTH         = (ECC_TEST == "OFF") ? DATA_WIDTH : DQ_WIDTH,
   parameter MEM_ADDR_ORDER        = "BANK_ROW_COLUMN",
                                      //Possible Parameters
                                      //1.BANK_ROW_COLUMN : Address mapping is
                                      //                    in form of Bank Row Column.
                                      //2.ROW_BANK_COLUMN : Address mapping is
                                      //                    in the form of Row Bank Column.
                                      //3.TG_TEST : Scrambles Address bits
                                      //            for distributed Addressing.
      
   //parameter nBANK_MACHS           = 4,
   parameter nBANK_MACHS           = 8,
   parameter RANKS                 = 1,
                                     // # of Ranks.
   parameter ODT_WIDTH             = 1,
                                     // # of ODT outputs to memory.
   parameter ROW_WIDTH             = 13,
                                     // # of memory Row Address bits.
   parameter ADDR_WIDTH            = 27,
                                     // # = RANK_WIDTH + BANK_WIDTH
                                     //     + ROW_WIDTH + COL_WIDTH;
                                     // Chip Select is always tied to low for
                                     // single rank devices
   parameter USE_CS_PORT          = 1,
                                     // # = 1, When Chip Select (CS#) output is enabled
                                     //   = 0, When Chip Select (CS#) output is disabled
                                     // If CS_N disabled, user must connect
                                     // DRAM CS_N input(s) to ground
   parameter USE_DM_PORT           = 1,
                                     // # = 1, When Data Mask option is enabled
                                     //   = 0, When Data Mask option is disbaled
                                     // When Data Mask option is disabled in
                                     // MIG Controller Options page, the logic
                                     // related to Data Mask should not get
                                     // synthesized
   parameter USE_ODT_PORT          = 1,
                                     // # = 1, When ODT output is enabled
                                     //   = 0, When ODT output is disabled
   parameter PHY_CONTROL_MASTER_BANK = 0,
                                     // The bank index where master PHY_CONTROL resides,
                                     // equal to the PLL residing bank
   parameter MEM_DENSITY           = "1Gb",
                                     // Indicates the density of the Memory part
                                     // Added for the sake of Vivado simulations
   parameter MEM_SPEEDGRADE        = "25E",
                                     // Indicates the Speed grade of Memory Part
                                     // Added for the sake of Vivado simulations
   parameter MEM_DEVICE_WIDTH      = 16,
                                     // Indicates the device width of the Memory Part
                                     // Added for the sake of Vivado simulations


	parameter tCK                   = 3077,
	parameter C_S_AXI_ID_WIDTH              = 4,
                                             // Width of all master and slave ID signals.
                                             // # = >= 1.
   parameter C_S_AXI_MEM_SIZE              = "134217728",
                                     // Address Space required for this component
   parameter C_S_AXI_ADDR_WIDTH            = 27,
                                             // Width of S_AXI_AWADDR, S_AXI_ARADDR, M_AXI_AWADDR and
                                             // M_AXI_ARADDR for all SI/MI slots.
                                             // # = 32.
   parameter C_S_AXI_DATA_WIDTH            = 128,
                                             // Width of WDATA and RDATA on SI slot.
                                             // Must be <= APP_DATA_WIDTH.
                                             // # = 32, 64, 128, 256.
   parameter C_MC_nCK_PER_CLK              = 4,
                                             // Indicates whether to instatiate upsizer
                                             // Range: 0, 1
   parameter C_S_AXI_SUPPORTS_NARROW_BURST = 0,
                                             // Indicates whether to instatiate upsizer
                                             // Range: 0, 1
   parameter C_RD_WR_ARB_ALGORITHM          = "RD_PRI_REG",
                                             // Indicates the Arbitration
                                             // Allowed values - "TDM", "ROUND_ROBIN",
                                             // "RD_PRI_REG", "RD_PRI_REG_STARVE_LIMIT"
                                             // "WRITE_PRIORITY", "WRITE_PRIORITY_REG"
   parameter C_S_AXI_REG_EN0               = 20'h00000,
                                             // C_S_AXI_REG_EN0[00] = Reserved
                                             // C_S_AXI_REG_EN0[04] = AW CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN0[05] =  W CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN0[06] =  B CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN0[07] =  R CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN0[08] = AW CHANNEL UPSIZER REGISTER SLICE
                                             // C_S_AXI_REG_EN0[09] =  W CHANNEL UPSIZER REGISTER SLICE
                                             // C_S_AXI_REG_EN0[10] = AR CHANNEL UPSIZER REGISTER SLICE
                                             // C_S_AXI_REG_EN0[11] =  R CHANNEL UPSIZER REGISTER SLICE
   parameter C_S_AXI_REG_EN1               = 20'h00000,
                                             // Instatiates register slices after the upsizer.
                                             // The type of register is specified for each channel
                                             // in a vector. 4 bits per channel are used.
                                             // C_S_AXI_REG_EN1[03:00] = AW CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN1[07:04] =  W CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN1[11:08] =  B CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN1[15:12] = AR CHANNEL REGISTER SLICE
                                             // C_S_AXI_REG_EN1[20:16] =  R CHANNEL REGISTER SLICE
                                             // Possible values for each channel are:
                                             //
                                             //   0 => BYPASS    = The channel is just wired through the
                                             //                    module.
                                             //   1 => FWD       = The master VALID and payload signals
                                             //                    are registrated.
                                             //   2 => REV       = The slave ready signal is registrated
                                             //   3 => FWD_REV   = Both FWD and REV
                                             //   4 => SLAVE_FWD = All slave side signals and master
                                             //                    VALID and payload are registrated.
                                             //   5 => SLAVE_RDY = All slave side signals and master
                                             //                    READY are registrated.
                                             //   6 => INPUTS    = Slave and Master side inputs are
                                             //                    registrated.
                                             //   7 => ADDRESS   = Optimized for address channel
   parameter C_S_AXI_CTRL_ADDR_WIDTH       = 32,
                                             // Width of AXI-4-Lite address bus
   parameter C_S_AXI_CTRL_DATA_WIDTH       = 32,
                                             // Width of AXI-4-Lite data buses
   parameter C_S_AXI_BASEADDR              = 32'h0000_0000,
                                             // Base address of AXI4 Memory Mapped bus.
   parameter C_ECC_ONOFF_RESET_VALUE       = 1,
                                             // Controls ECC on/off value at startup/reset
   parameter C_ECC_CE_COUNTER_WIDTH        = 8,
                                             // The external memory to controller clock ratio.
	 parameter nCK_PER_CLK           = 4,
	 
	parameter ORDERING              = "NORM",
  parameter  DRAM_TYPE				= "DDR2",
  parameter SIMULATION              = "FALSE"

) (
 
   // Inouts
   inout [DQ_WIDTH-1:0]                         ddr_mem_interface_dq,
   inout [DQS_WIDTH-1:0]                        ddr_mem_interface_dqs_n,
   inout [DQS_WIDTH-1:0]                        ddr_mem_interface_dqs_p,

   // Outputs
   output [ROW_WIDTH-1:0]                       ddr_mem_interface_addr,
   output [BANK_WIDTH-1:0]                      ddr_mem_interface_ba,
   output                                       ddr_mem_interface_ras_n,
   output                                       ddr_mem_interface_cas_n,
   output                                       ddr_mem_interface_we_n,
   output [CK_WIDTH-1:0]                        ddr_mem_interface_ck_n,
   output [CK_WIDTH-1:0]                        ddr_mem_interface_ck_p,
   
   output [CKE_WIDTH-1:0]                       ddr_mem_interface_cke,
   
   output [(CS_WIDTH*nCS_PER_RANK)-1:0]           ddr_mem_interface_cs_n,
   
   output [DM_WIDTH-1:0]                        ddr_mem_interface_dm,
   
   output [ODT_WIDTH-1:0]                       ddr_mem_interface_odt,
   

   // Inputs
   // Single-ended system clock
   input                                        sys_clk_i,
   // Single-ended iodelayctrl clk (reference clock)
   input                                        clk_ref_i,
   
   // user interface signals
   output                                       ui_clk,
   output                                       ui_clk_sync_rst,
   
   output                                       mmcm_locked,
   
   input                                        aresetn,
   // Slave Interface Write Address Ports
   input  [C_S_AXI_ID_WIDTH-1:0]                s_axi_awid,
   input  [C_S_AXI_ADDR_WIDTH-1:0]              s_axi_awaddr,
   input  [7:0]                                 s_axi_awlen,
   input  [2:0]                                 s_axi_awsize,
   input  [1:0]                                 s_axi_awburst,
   input  [0:0]                                 s_axi_awlock,
   input  [3:0]                                 s_axi_awcache,
   input  [2:0]                                 s_axi_awprot,
   input  [3:0]                                 s_axi_awqos,
   input                                        s_axi_awvalid,
   output                                       s_axi_awready,
   // Slave Interface Write Data Ports
   input  [C_S_AXI_DATA_WIDTH-1:0]              s_axi_wdata,
   input  [(C_S_AXI_DATA_WIDTH/8)-1:0]            s_axi_wstrb,
   input                                        s_axi_wlast,
   input                                        s_axi_wvalid,
   output                                       s_axi_wready,
   // Slave Interface Write Response Ports
   input                                        s_axi_bready,
   output [C_S_AXI_ID_WIDTH-1:0]                s_axi_bid,
   output [1:0]                                 s_axi_bresp,
   output                                       s_axi_bvalid,
   // Slave Interface Read Address Ports
   input  [C_S_AXI_ID_WIDTH-1:0]                s_axi_arid,
   input  [C_S_AXI_ADDR_WIDTH-1:0]              s_axi_araddr,
   input  [7:0]                                 s_axi_arlen,
   input  [2:0]                                 s_axi_arsize,
   input  [1:0]                                 s_axi_arburst,
   input  [0:0]                                 s_axi_arlock,
   input  [3:0]                                 s_axi_arcache,
   input  [2:0]                                 s_axi_arprot,
   input  [3:0]                                 s_axi_arqos,
   input                                        s_axi_arvalid,
   output                                       s_axi_arready,
   // Slave Interface Read Data Ports
   input                                        s_axi_rready,
   output [C_S_AXI_ID_WIDTH-1:0]                s_axi_rid,
   output [C_S_AXI_DATA_WIDTH-1:0]              s_axi_rdata,
   output [1:0]                                 s_axi_rresp,
   output                                       s_axi_rlast,
   output                                       s_axi_rvalid,    
   output                                       init_calib_complete,
   // System reset - Default polarity of sys_rst pin is Active Low.
   // System reset polarity will change based on the option 
   // selected in GUI.
   input                                        sys_rst
  );

// Start of IP top instance
  mig_7series_normal_ord_mig #(
  .tCK(tCK),   
      .CK_WIDTH                         (CK_WIDTH),
     .COL_WIDTH                        (COL_WIDTH),
     .CS_WIDTH                         (CS_WIDTH),
     .nCS_PER_RANK                     (nCS_PER_RANK),
     .CKE_WIDTH                        (CKE_WIDTH),
     .DATA_WIDTH                       (DATA_WIDTH),
     .DATA_BUF_ADDR_WIDTH              (DATA_BUF_ADDR_WIDTH),
     .DM_WIDTH                         (DM_WIDTH),
     .DQ_CNT_WIDTH                     (DQ_CNT_WIDTH),
     .DQ_WIDTH                         (DQ_WIDTH),
     .DQS_CNT_WIDTH                    (DQS_CNT_WIDTH),
     .DQS_WIDTH                        (DQS_WIDTH),
     .DRAM_WIDTH                       (DRAM_WIDTH),              
  .C_S_AXI_MEM_SIZE(C_S_AXI_MEM_SIZE),   
  .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH),
  .C_S_AXI_BASEADDR(C_S_AXI_BASEADDR),
       .C_S_AXI_ID_WIDTH                 (C_S_AXI_ID_WIDTH),
     .C_S_AXI_DATA_WIDTH               (C_S_AXI_DATA_WIDTH),
     .C_S_AXI_SUPPORTS_NARROW_BURST    (C_S_AXI_SUPPORTS_NARROW_BURST),
     .C_RD_WR_ARB_ALGORITHM            (C_RD_WR_ARB_ALGORITHM),
     .C_S_AXI_REG_EN0                  (C_S_AXI_REG_EN0),
     .C_S_AXI_REG_EN1                  (C_S_AXI_REG_EN1),
     .C_S_AXI_CTRL_ADDR_WIDTH          (C_S_AXI_CTRL_ADDR_WIDTH),
     .C_S_AXI_CTRL_DATA_WIDTH          (C_S_AXI_CTRL_DATA_WIDTH),
     .C_ECC_ONOFF_RESET_VALUE          (C_ECC_ONOFF_RESET_VALUE),
     .C_ECC_CE_COUNTER_WIDTH           (C_ECC_CE_COUNTER_WIDTH),
  	 .nCK_PER_CLK                      (nCK_PER_CLK),
     .DRAM_TYPE                        (DRAM_TYPE)
  ) u_mig_7series_normal_ord_mig (

    // Memory interface ports
    .ddr_mem_interface_addr                      (ddr_mem_interface_addr),
    .ddr_mem_interface_ba                        (ddr_mem_interface_ba),
    .ddr_mem_interface_cas_n                     (ddr_mem_interface_cas_n),
    .ddr_mem_interface_ck_n                      (ddr_mem_interface_ck_n),
    .ddr_mem_interface_ck_p                      (ddr_mem_interface_ck_p),
    .ddr_mem_interface_cke                       (ddr_mem_interface_cke),
    .ddr_mem_interface_ras_n                     (ddr_mem_interface_ras_n),
    .ddr_mem_interface_we_n                      (ddr_mem_interface_we_n),
    .ddr_mem_interface_dq                        (ddr_mem_interface_dq),
    .ddr_mem_interface_dqs_n                     (ddr_mem_interface_dqs_n),
    .ddr_mem_interface_dqs_p                     (ddr_mem_interface_dqs_p),
    .init_calib_complete            (init_calib_complete),     
    .ddr_mem_interface_cs_n                      (ddr_mem_interface_cs_n),
    .ddr_mem_interface_dm                        (ddr_mem_interface_dm),
    .ddr_mem_interface_odt                       (ddr_mem_interface_odt),
    // Application interface ports
    .ui_clk                         (ui_clk),
    .ui_clk_sync_rst                (ui_clk_sync_rst),
    .mmcm_locked                    (mmcm_locked),
    .aresetn                        (aresetn),
    // Slave Interface Write Address Ports
    .s_axi_awid                     (s_axi_awid),
    .s_axi_awaddr                   (s_axi_awaddr),
    .s_axi_awlen                    (s_axi_awlen),
    .s_axi_awsize                   (s_axi_awsize),
    .s_axi_awburst                  (s_axi_awburst),
    .s_axi_awlock                   (s_axi_awlock),
    .s_axi_awcache                  (s_axi_awcache),
    .s_axi_awprot                   (s_axi_awprot),
    .s_axi_awqos                    (s_axi_awqos),
    .s_axi_awvalid                  (s_axi_awvalid),
    .s_axi_awready                  (s_axi_awready),
    // Slave Interface Write Data Ports
    .s_axi_wdata                    (s_axi_wdata),
    .s_axi_wstrb                    (s_axi_wstrb),
    .s_axi_wlast                    (s_axi_wlast),
    .s_axi_wvalid                   (s_axi_wvalid),
    .s_axi_wready                   (s_axi_wready),
    // Slave Interface Write Response Ports
    .s_axi_bid                      (s_axi_bid),
    .s_axi_bresp                    (s_axi_bresp),
    .s_axi_bvalid                   (s_axi_bvalid),
    .s_axi_bready                   (s_axi_bready),
    // Slave Interface Read Address Ports
    .s_axi_arid                     (s_axi_arid),
    .s_axi_araddr                   (s_axi_araddr),
    .s_axi_arlen                    (s_axi_arlen),
    .s_axi_arsize                   (s_axi_arsize),
    .s_axi_arburst                  (s_axi_arburst),
    .s_axi_arlock                   (s_axi_arlock),
    .s_axi_arcache                  (s_axi_arcache),
    .s_axi_arprot                   (s_axi_arprot),
    .s_axi_arqos                    (s_axi_arqos),
    .s_axi_arvalid                  (s_axi_arvalid),
    .s_axi_arready                  (s_axi_arready),
    // Slave Interface Read Data Ports
    .s_axi_rid                      (s_axi_rid),
    .s_axi_rdata                    (s_axi_rdata),
    .s_axi_rresp                    (s_axi_rresp),
    .s_axi_rlast                    (s_axi_rlast),
    .s_axi_rvalid                   (s_axi_rvalid),
    .s_axi_rready                   (s_axi_rready),
    // System Clock Ports
    .sys_clk_i                       (sys_clk_i),
    // Reference Clock Ports
    .clk_ref_i                      (clk_ref_i),
    .sys_rst                        (sys_rst)
    );
// End of IP top instance

endmodule


