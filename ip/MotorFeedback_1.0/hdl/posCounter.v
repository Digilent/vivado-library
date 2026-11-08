`timescale 1ns / 1ps

module posCounter (
   input  wire        clk,
   output reg  [15:0] pos1,     // Use for speed calculation
   output reg  [15:0] pos2,     // Use for position control
   input  wire        sensor,   // Sensor input signal
   input  wire [1:0]  clear,    // clear[0] for pos1, clear[1] for pos2
   input  wire        subtract, // subtract distance from pos2
   input  wire [15:0] distance  // Ammount to reduce pos2 when subtract is true
);

   reg sensor_prev;

   initial begin
      pos1        = 16'b0;
      pos2        = 16'b0;
      sensor_prev =  1'b0;
   end

   wire sensor_rise;
   assign sensor_rise = ~sensor_prev & sensor;

   always @ (posedge clk) begin
      if (clear[0])         pos1 <= 16'b0;
      else if (sensor_rise) pos1 <= pos1 + 1'b1;

      if (clear[1])         pos2 <= 16'b0;
      else if (subtract)    pos2 <= pos2 - distance + sensor_rise;
      else if (sensor_rise) pos2 <= pos2 + 1'b1;

      sensor_prev <= sensor;
   end
endmodule

module posCounter_testbench ();
   reg         clk;
   wire [15:0] pos1;
   wire [15:0] pos2;
   reg         sensor;
   reg  [1:0]  clear;
   reg         subtract;
   wire [15:0] distance;

   posCounter dut (
      .clk(clk),
      .pos1(pos1),
      .pos2(pos2),
      .sensor(sensor),
      .clear(clear),
      .subtract(subtract),
      .distance(distance)
   );

   parameter CLOCK_PERIOD = 10;
   initial begin
      clk <= 0;
      forever #(CLOCK_PERIOD / 2) clk <= ~clk;
   end

   assign distance = 16'b111;

   integer i;
   initial begin
         sensor <= 0; clear <= 2'b00; subtract <= 0; @(posedge clk);
                      clear <= 2'b01;                @(posedge clk);
         sensor <= 1; clear <= 2'b00;                @(posedge clk);
         sensor <= 0;                                @(posedge clk);
      for (i = 0; i < 10; i = i + 1) begin
         sensor <= 1;                                @(posedge clk);
         sensor <= 0;                                @(posedge clk);
      end
                                      subtract <= 1; @(posedge clk);
                                      subtract <= 0; @(posedge clk);
      for (i = 0; i < 6; i = i + 1) begin
         sensor <= 1;                                @(posedge clk);
         sensor <= 0;                                @(posedge clk);
      end
                      clear <= 2'b10;                @(posedge clk);
                      clear <= 2'b00;                @(posedge clk);
      for (i = 0; i < 6; i = i + 1) begin
         sensor <= 1;                                @(posedge clk);
         sensor <= 0;                                @(posedge clk);
      end
                      clear <= 2'b11;                @(posedge clk);
                      clear <= 2'b00;                @(posedge clk);
      $stop;
   end
endmodule
