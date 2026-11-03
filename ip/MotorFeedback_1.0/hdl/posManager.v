`timescale 1ns / 1ps

module posManager ( 
   input  wire        clk,
   output wire [15:0] pos11,
   output wire [15:0] pos12,
   output wire [15:0] pos21,
   output wire [15:0] pos22,
   output wire [15:0] pos_diff,
   output reg  [31:0] count_clk,
   input  wire        m1,
   input  wire        m2,
   input  wire [1:0]  clear
);

   reg m1_delay, m2_delay, m1_clean, m2_clean;
   initial begin
      count_clk = 32'b0;
      m1_delay  =  1'b0;
      m2_delay  =  1'b0;
      m1_clean  =  1'b0;
      m2_clean  =  1'b0;
   end

   always @ (posedge clk) begin
      if (clear[0]) count_clk <= 32'b0;
      else          count_clk <= count_clk + 1'b1;

      m1_delay <= m1;
      m2_delay <= m2;
      m1_clean <= m1_delay;
      m2_clean <= m2_delay;
   end

   wire subtract;
   assign subtract = (pos12[15] | pos22[15]) & (pos12 != 16'b0) & (pos22 != 16'b0);

   reg [15:0] distance;
   always @ (*) begin
      if (pos12 < pos22) distance = pos12;
      else               distance = pos22;
   end

   assign pos_diff = pos12 - pos22;

   posCounter pos_counter1 (
      .clk(clk),
      .pos1(pos11),
      .pos2(pos12),
      .sensor(m1_clean),
      .clear(clear),
      .subtract(subtract),
      .distance(distance)
   );

   posCounter pos_counter2 (
      .clk(clk),
      .pos1(pos21),
      .pos2(pos22),
      .sensor(m2_clean),
      .clear(clear),
      .subtract(subtract),
      .distance(distance)
   );
endmodule

module posManager_testbench ();
   reg         clk;
   wire [15:0] pos11, pos12, pos21, pos22, pos_diff;
   wire [31:0] count_clk;
   reg         m1, m2;
   reg  [1:0]  clear;

   posManager dut (
      .clk(clk),
      .pos11(pos11),
      .pos12(pos12),
      .pos21(pos21),
      .pos22(pos22),
      .pos_diff(pos_diff),
      .count_clk(count_clk),
      .m1(m1),
      .m2(m2),
      .clear(clear)
   );

   parameter CLOCK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLOCK_PERIOD / 2) clk <= ~clk;
   end

   integer i;
   initial begin
         m1 <= 0; m2 <= 0; clear <= 2'b00; @(posedge clk);
                           clear <= 2'b01; @(posedge clk);
                           clear <= 2'b00; @(posedge clk);
         m1 <= 1;                          @(posedge clk);
         m1 <= 0;                          @(posedge clk);
         m1 <= 1;                          @(posedge clk);
         m1 <= 0;                          @(posedge clk);
         m1 <= 1;                          @(posedge clk);
         m1 <= 0;                          @(posedge clk);
      for (i = 0; i < 16; i = i + 1) begin
         m1 <= 0; m2 <= 0;                 @(posedge clk);
         m1 <= 1; m2 <= 1;                 @(posedge clk);
      end
                           clear <= 2'b01; @(posedge clk);
                           clear <= 2'b00; @(posedge clk);
      for (i = 0; i < 32768; i = i + 1) begin
         m1 <= 0; m2 <= 0;                 @(posedge clk);
         m1 <= 1; m2 <= 1;                 @(posedge clk);
      end
                           clear <= 2'b10; @(posedge clk);
                           clear <= 2'b00; @(posedge clk);
                                           @(posedge clk);
                                           @(posedge clk);
                                           @(posedge clk);
      for (i = 0; i < 16; i = i + 1) begin
         m1 <= 0; m2 <= 0;                 @(posedge clk);
         m1 <= 1; m2 <= 1;                 @(posedge clk);
      end
                           clear <= 2'b11; @(posedge clk);
                           clear <= 2'b00; @(posedge clk);
                  m2 <= 0;                 @(posedge clk);
                  m2 <= 1;                 @(posedge clk);
                  m2 <= 0;                 @(posedge clk);
                  m2 <= 1;                 @(posedge clk);
                  m2 <= 0;                 @(posedge clk);
                  m2 <= 1;                 @(posedge clk);
                  m2 <= 0;                 @(posedge clk);
                  m2 <= 1;                 @(posedge clk);
                  m2 <= 0;                 @(posedge clk);
                  m2 <= 1;                 @(posedge clk);
      $stop;
   end
endmodule
