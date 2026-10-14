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
//  /   /         Filename           : example_top.v
// /___/   /\     Date Last Modified : $Date: 2011/06/02 08:35:03 $
// \   \  /  \    Date Created       : Fri Oct 14 2011
//  \___\/\___\
//
// Device           : 7 Series
// Design Name      : DDR2 SDRAM
// Purpose          :
//   Top-level  module. This module serves as an example,
//   and allows the user to synthesize a self-contained design,
//   which they can be used to test their hardware.
//   In addition to the memory controller, the module instantiates:
//     1. Synthesizable testbench - used to model user's backend logic
//        and generate different traffic patterns
// Reference        :
// Revision History :
//*****************************************************************************

`timescale 1ps/1ps

module example_top #
  (

   //***************************************************************************
   // Traffic Gen related parameters
   //***************************************************************************
   parameter BEGIN_ADDRESS         = 32'h00000000,
   parameter END_ADDRESS           = 32'h00ffffff,
   parameter PRBS_EADDR_MASK_POS   = 32'hff000000,
   parameter ENFORCE_RD_WR         = 0,
   parameter ENFORCE_RD_WR_CMD     = 8'h11,
   parameter ENFORCE_RD_WR_PATTERN = 3'b000,
   parameter C_EN_WRAP_TRANS       = 0,
   parameter C_AXI_NBURST_TEST     = 0,

   //***************************************************************************
   // The following parameters refer to width of various ports
   //***************************************************************************
   parameter BANK_WIDTH            = 3,
                                     // # of memory Bank Address bits.
   parameter COL_WIDTH             = 10,
                                     // # of memory Column Address bits.
   parameter CS_WIDTH              = 1,
                                     // # of unique CS outputs to memory.
   parameter DQ_WIDTH              = 16,
                                     // # of DQ (data)
   parameter DQS_WIDTH             = 2,
   parameter DQS_CNT_WIDTH         = 1,
                                     // = ceil(log2(DQS_WIDTH))
   parameter DRAM_WIDTH            = 8,
                                     // # of DQ per DQS
   parameter ECC                   = "OFF",
   parameter ECC_TEST              = "OFF",
   //parameter nBANK_MACHS           = 4,
   parameter nBANK_MACHS           = 8,
   parameter RANKS                 = 1,
                                     // # of Ranks.
   parameter ROW_WIDTH             = 13,
                                     // # of memory Row Address bits.
   parameter ADDR_WIDTH            = 27,
                                     // # = RANK_WIDTH + BANK_WIDTH
                                     //     + ROW_WIDTH + COL_WIDTH;
                                     // Chip Select is always tied to low for
                                     // single rank devices

   //***************************************************************************
   // The following parameters are mode register settings
   //***************************************************************************
   parameter BURST_MODE            = "8",
                                     // DDR3 SDRAM:
                                     // Burst Length (Mode Register 0).
                                     // # = "8", "4", "OTF".
                                     // DDR2 SDRAM:
                                     // Burst Length (Mode Register).
                                     // # = "8", "4".

   //***************************************************************************
   // Simulation parameters
   //***************************************************************************
   parameter SIMULATION            = "FALSE",
                                     // Should be TRUE during design simulations and
                                     // FALSE during implementations

   //***************************************************************************
   // IODELAY and PHY related parameters
   //***************************************************************************
   parameter TCQ                   = 100,
   


   
   //***************************************************************************
   // System clock frequency parameters
   //***************************************************************************
   parameter nCK_PER_CLK           = 4,
                                     // # of memory CKs per fabric CLK

   
   //***************************************************************************
   // AXI4 Shim parameters
   //***************************************************************************
   
   parameter UI_EXTRA_CLOCKS = "FALSE",
                                     // Generates extra clocks as
                                     // 1/2, 1/4 and 1/8 of fabrick clock.
                                     // Valid for DDR2/DDR3 AXI interfaces
                                     // based on GUI selection
   parameter C_S_AXI_ID_WIDTH              = 4,
                                             // Width of all master and slave ID signals.
                                             // # = >= 1.
   parameter C_S_AXI_ADDR_WIDTH            = 27,
                                             // Width of S_AXI_AWADDR, S_AXI_ARADDR, M_AXI_AWADDR and
                                             // M_AXI_ARADDR for all SI/MI slots.
                                             // # = 32.
   parameter C_S_AXI_DATA_WIDTH            = 32,
                                             // Width of WDATA and RDATA on SI slot.
                                             // Must be <= APP_DATA_WIDTH.
                                             // # = 32, 64, 128, 256.
   parameter C_S_AXI_SUPPORTS_NARROW_BURST = 0,
                                             // Indicates whether to instatiate upsizer
                                             // Range: 0, 1
   parameter C_S_AXI_CTRL_ADDR_WIDTH       = 32,
                                             // Width of AXI-4-Lite address bus
   parameter C_S_AXI_CTRL_DATA_WIDTH       = 32,
                                             // Width of AXI-4-Lite data buses
      

   //***************************************************************************
   // Debug parameters
   //***************************************************************************
   parameter DEBUG_PORT            = "OFF"
                                     // # = "ON" Enable debug signals/controls.
                                     //   = "OFF" Disable debug signals/controls.
      
//   parameter RST_ACT_LOW           = 1
                                     // =1 for active low reset,
                                     // =0 for active high.
   )
  (

   // Inouts
   inout [15:0]                         ddr2_dq,
   inout [1:0]                        ddr2_dqs_n,
   inout [1:0]                        ddr2_dqs_p,

   // Outputs
   output [12:0]                       ddr2_addr,
   output [2:0]                      ddr2_ba,
   output                                       ddr2_ras_n,
   output                                       ddr2_cas_n,
   output                                       ddr2_we_n,
   
   output [0:0]                        ddr2_ck_p,
   output [0:0]                        ddr2_ck_n,
   output [0:0]                       ddr2_cke,
   output [0:0]           ddr2_cs_n,
   
   output [1:0]                        ddr2_dm,
   
   output [0:0]                       ddr2_odt,
   

   // Inputs
   // Single-ended system clock
   input                                        sys_clk_i,
   // Single-ended iodelayctrl clk (reference clock)
   input                                        clk_ref_i,
   
   output                                       tg_compare_error,
   output                                       init_calib_complete,
   
      

   // System reset - Default polarity of sys_rst pin is Active Low.
   // System reset polarity will change based on the option 
   // selected in GUI.
   input                                        sys_rst
   );

function integer clogb2 (input integer size);
    begin
      size = size - 1;
      for (clogb2=1; size>1; clogb2=clogb2+1)
        size = size >> 1;
    end
  endfunction // clogb2

  function integer STR_TO_INT;
    input [7:0] in;
    begin
      if(in == "8")
        STR_TO_INT = 8;
      else if(in == "4")
        STR_TO_INT = 4;
      else
        STR_TO_INT = 0;
    end
  endfunction


  localparam DATA_WIDTH            = 16;
  localparam RANK_WIDTH = clogb2(RANKS);
  localparam PAYLOAD_WIDTH         = (ECC_TEST == "OFF") ? DATA_WIDTH : DQ_WIDTH;
  localparam BURST_LENGTH          = STR_TO_INT(BURST_MODE);
  localparam APP_DATA_WIDTH        = 2 * nCK_PER_CLK * PAYLOAD_WIDTH;
  localparam APP_MASK_WIDTH        = APP_DATA_WIDTH / 8;

  //***************************************************************************
  // Traffic Gen related parameters (derived)
  //***************************************************************************
  localparam  TG_ADDR_WIDTH = ((CS_WIDTH == 1) ? 0 : RANK_WIDTH)
                                 + BANK_WIDTH + ROW_WIDTH + COL_WIDTH;
  localparam MASK_SIZE             = DATA_WIDTH/8;
  localparam DBG_WR_STS_WIDTH      = 40;
  localparam DBG_RD_STS_WIDTH      = 40;
      

  // Wire declarations
      
  wire                              clk;
  wire                              rst;
  wire                              mmcm_locked;
  reg                               aresetn;
  wire                              app_sr_active;
  wire                              app_ref_ack;
  wire                              app_zq_ack;
  wire                              app_rd_data_valid;
  wire [APP_DATA_WIDTH-1:0]         app_rd_data;

  wire                              mem_pattern_init_done;

  wire                              cmd_err;
  wire                              data_msmatch_err;
  wire                              write_err;
  wire                              read_err;
  wire                              test_cmptd;
  wire                              write_cmptd;
  wire                              read_cmptd;
  wire                              cmptd_one_wr_rd;

  // Slave Interface Write Address Ports
  wire [C_S_AXI_ID_WIDTH-1:0]       s_axi_awid;
  wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_awaddr;
  wire [7:0]                        s_axi_awlen;
  wire [2:0]                        s_axi_awsize;
  wire [1:0]                        s_axi_awburst;
  wire [0:0]                        s_axi_awlock;
  wire [3:0]                        s_axi_awcache;
  wire [2:0]                        s_axi_awprot;
  wire                              s_axi_awvalid;
  wire                              s_axi_awready;
   // Slave Interface Write Data Ports
  wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_wdata;
  wire [(C_S_AXI_DATA_WIDTH/8)-1:0]   s_axi_wstrb;
  wire                              s_axi_wlast;
  wire                              s_axi_wvalid;
  wire                              s_axi_wready;
   // Slave Interface Write Response Ports
  wire                              s_axi_bready;
  wire [C_S_AXI_ID_WIDTH-1:0]       s_axi_bid;
  wire [1:0]                        s_axi_bresp;
  wire                              s_axi_bvalid;
   // Slave Interface Read Address Ports
  wire [C_S_AXI_ID_WIDTH-1:0]       s_axi_arid;
  wire [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_araddr;
  wire [7:0]                        s_axi_arlen;
  wire [2:0]                        s_axi_arsize;
  wire [1:0]                        s_axi_arburst;
  wire [0:0]                        s_axi_arlock;
  wire [3:0]                        s_axi_arcache;
  wire [2:0]                        s_axi_arprot;
  wire                              s_axi_arvalid;
  wire                              s_axi_arready;
   // Slave Interface Read Data Ports
  wire                              s_axi_rready;
  wire [C_S_AXI_ID_WIDTH-1:0]       s_axi_rid;
  wire [C_S_AXI_DATA_WIDTH-1:0]     s_axi_rdata;
  wire [1:0]                        s_axi_rresp;
  wire                              s_axi_rlast;
  wire                              s_axi_rvalid;

  wire                              cmp_data_valid;
  wire [C_S_AXI_DATA_WIDTH-1:0]      cmp_data;     // Compare data
  wire [C_S_AXI_DATA_WIDTH-1:0]      rdata_cmp;      // Read data

  wire                              dbg_wr_sts_vld;
  wire [DBG_WR_STS_WIDTH-1:0]       dbg_wr_sts;
  wire                              dbg_rd_sts_vld;
  wire [DBG_RD_STS_WIDTH-1:0]       dbg_rd_sts;

//***************************************************************************



  assign tg_compare_error = cmd_err | data_msmatch_err | write_err | read_err;
      
      


      
// Start of User Design top instance
//***************************************************************************
// The User design is instantiated below. The memory interface ports are
// connected to the top-level and the application interface ports are
// connected to the traffic generator module. This provides a reference
// for connecting the memory controller to system.
//***************************************************************************

  mig_7series_normal_ord  #
    (
//     #parameters_mapping_user_design_top_instance#
   .RST_ACT_LOW                      (RST_ACT_LOW)
     )
    u_mig_7series  (
// Memory interface ports
        .ddr_mem_interface_addr                 (ddr2_addr),
        .ddr_mem_interface_ba                   (ddr2_ba),
        .ddr_mem_interface_cas_n                (ddr2_cas_n),
        .ddr_mem_interface_ck_n                 (ddr2_ck_n),
        .ddr_mem_interface_ck_p                 (ddr2_ck_p),
        .ddr_mem_interface_cke                  (ddr2_cke),
        .ddr_mem_interface_ras_n                (ddr2_ras_n),
        .ddr_mem_interface_we_n                 (ddr2_we_n),
        .ddr_mem_interface_dq                   (ddr2_dq),
        .ddr_mem_interface_dqs_n                (ddr2_dqs_n),
        .ddr_mem_interface_dqs_p                (ddr2_dqs_p),
        .init_calib_complete         
        .ddr_mem_interface_cs_n                 (init_calib_complete),
        .ddr_mem_interface_dm        
        .ddr_mem_interface_odt                  (ddr2_cs_n),
        .ddr_mem_interface_odt                  (ddr2_dm),
        .ddr_mem_interface_odt                  (ddr2_odt),
// Application interface ports
       .ui_clk                         (clk),
       .ui_clk_sync_rst                (rst),

       .mmcm_locked                    (mmcm_locked),
       .aresetn                        (aresetn),
       .app_sr_req                     (1'b0),
       .app_ref_req                    (1'b0),
       .app_zq_req                     (1'b0),
       .app_sr_active                  (app_sr_active),
       .app_ref_ack                    (app_ref_ack),
       .app_zq_ack                     (app_zq_ack),

// Slave Interface Write Address Ports
       .s_axi_awid                     (s_axi_awid),
       .s_axi_awaddr                   (s_axi_awaddr),
       .s_axi_awlen                    (s_axi_awlen),
       .s_axi_awsize                   (s_axi_awsize),
       .s_axi_awburst                  (s_axi_awburst),
       .s_axi_awlock                   (s_axi_awlock),
       .s_axi_awcache                  (s_axi_awcache),
       .s_axi_awprot                   (s_axi_awprot),
       .s_axi_awqos                    (4'h0),
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
       .s_axi_arqos                    (4'h0),
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
// End of User Design top instance


//***************************************************************************
// The traffic generation module instantiated below drives traffic (patterns)
// on the application interface of the memory controller
//***************************************************************************

   always @(posedge clk) begin
     aresetn <= ~rst;
   end

   mig_7series_v4_2_axi4_tg #(

     .C_AXI_ID_WIDTH                   (C_S_AXI_ID_WIDTH),
     .C_AXI_ADDR_WIDTH                 (C_S_AXI_ADDR_WIDTH),
     .C_AXI_DATA_WIDTH                 (C_S_AXI_DATA_WIDTH),
     .C_AXI_NBURST_SUPPORT             (C_AXI_NBURST_TEST),
     .C_EN_WRAP_TRANS                  (C_EN_WRAP_TRANS),
     .C_BEGIN_ADDRESS                  (BEGIN_ADDRESS),
     .C_END_ADDRESS                    (END_ADDRESS),
     .PRBS_EADDR_MASK_POS              (PRBS_EADDR_MASK_POS),
     .DBG_WR_STS_WIDTH                 (DBG_WR_STS_WIDTH),
     .DBG_RD_STS_WIDTH                 (DBG_RD_STS_WIDTH),
     .ENFORCE_RD_WR                    (ENFORCE_RD_WR),
     .ENFORCE_RD_WR_CMD                (ENFORCE_RD_WR_CMD),
     .EN_UPSIZER                       (C_S_AXI_SUPPORTS_NARROW_BURST),
     .ENFORCE_RD_WR_PATTERN            (ENFORCE_RD_WR_PATTERN)

   ) u_axi4_tg_inst
   (
     .aclk                             (clk),
     .aresetn                          (aresetn),

// Input control signals
     .init_cmptd                       (init_calib_complete),
     .init_test                        (1'b0),
     .wdog_mask                        (~init_calib_complete),
     .wrap_en                          (1'b0),

// AXI write address channel signals
     .axi_wready                       (s_axi_awready),
     .axi_wid                          (s_axi_awid),
     .axi_waddr                        (s_axi_awaddr),
     .axi_wlen                         (s_axi_awlen),
     .axi_wsize                        (s_axi_awsize),
     .axi_wburst                       (s_axi_awburst),
     .axi_wlock                        (s_axi_awlock),
     .axi_wcache                       (s_axi_awcache),
     .axi_wprot                        (s_axi_awprot),
     .axi_wvalid                       (s_axi_awvalid),

// AXI write data channel signals
     .axi_wd_wready                    (s_axi_wready),
     .axi_wd_wid                       (s_axi_wid),
     .axi_wd_data                      (s_axi_wdata),
     .axi_wd_strb                      (s_axi_wstrb),
     .axi_wd_last                      (s_axi_wlast),
     .axi_wd_valid                     (s_axi_wvalid),

// AXI write response channel signals
     .axi_wd_bid                       (s_axi_bid),
     .axi_wd_bresp                     (s_axi_bresp),
     .axi_wd_bvalid                    (s_axi_bvalid),
     .axi_wd_bready                    (s_axi_bready),

// AXI read address channel signals
     .axi_rready                       (s_axi_arready),
     .axi_rid                          (s_axi_arid),
     .axi_raddr                        (s_axi_araddr),
     .axi_rlen                         (s_axi_arlen),
     .axi_rsize                        (s_axi_arsize),
     .axi_rburst                       (s_axi_arburst),
     .axi_rlock                        (s_axi_arlock),
     .axi_rcache                       (s_axi_arcache),
     .axi_rprot                        (s_axi_arprot),
     .axi_rvalid                       (s_axi_arvalid),

// AXI read data channel signals
     .axi_rd_bid                       (s_axi_rid),
     .axi_rd_rresp                     (s_axi_rresp),
     .axi_rd_rvalid                    (s_axi_rvalid),
     .axi_rd_data                      (s_axi_rdata),
     .axi_rd_last                      (s_axi_rlast),
     .axi_rd_rready                    (s_axi_rready),

// Error status signals
     .cmd_err                          (cmd_err),
     .data_msmatch_err                 (data_msmatch_err),
     .write_err                        (write_err),
     .read_err                         (read_err),
     .test_cmptd                       (test_cmptd),
     .write_cmptd                      (write_cmptd),
     .read_cmptd                       (read_cmptd),
     .cmptd_one_wr_rd                  (cmptd_one_wr_rd),

// Debug status signals
     .cmp_data_en                      (cmp_data_valid),
     .cmp_data_o                       (cmp_data),
     .rdata_cmp                        (rdata_cmp),
     .dbg_wr_sts_vld                   (dbg_wr_sts_vld),
     .dbg_wr_sts                       (dbg_wr_sts),
     .dbg_rd_sts_vld                   (dbg_rd_sts_vld),
     .dbg_rd_sts                       (dbg_rd_sts)
);

      


   //*****************************************************************
   // Default values are assigned to the debug inputs
   //*****************************************************************
   assign dbg_sel_pi_incdec       = 'b0;
   assign dbg_sel_po_incdec       = 'b0;
   assign dbg_pi_f_inc            = 'b0;
   assign dbg_pi_f_dec            = 'b0;
   assign dbg_po_f_inc            = 'b0;
   assign dbg_po_f_dec            = 'b0;
   assign dbg_po_f_stg23_sel      = 'b0;
   assign po_win_tg_rst           = 'b0;
   assign vio_tg_rst              = 'b0;

endmodule


