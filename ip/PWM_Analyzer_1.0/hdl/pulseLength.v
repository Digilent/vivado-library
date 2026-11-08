`timescale 1ns / 1ps

module pulseLength (
   input  wire        clk,
   input  wire        reset,
   output reg  [30:0] pw_low,
   output reg  [30:0] pw_high,
   output reg  [31:0] pwm_per,
   input  wire        pwm
);

   reg [1:0] ps, ns;
   parameter
   init  = 2'b00,
   first = 2'b01,
   low   = 2'b10,
   high  = 2'b11;

   reg        pwm_prev;
   reg [30:0] count_clk0, count_clk1;
   initial begin
      ps = init;

      pwm_prev   =  1'b1;
      count_clk0 = 31'b0;
      count_clk1 = 31'b0;
      pw_high    = 31'b0;
      pw_low     = 31'b0;
      pwm_per    = 32'b0;
   end

   always @ (*) begin
      case (ps)
         init:  if (pwm_prev ^ pwm)       ns = first;
                else                      ns = init;
         first: if (~pwm_prev & pwm)      ns = high;
                else if (pwm_prev & ~pwm) ns = low;
                else                      ns = first;
         low:   if (pwm)                  ns = high;
                else                      ns = low;
         high:  if (~pwm)                 ns = low;
                else                      ns = high;
      endcase
      pwm_per = pw_low + pw_high;
   end

   always @ (posedge clk) begin
      if (reset) begin
         count_clk0 <= 31'b0;
         count_clk1 <= 31'b0;
         pw_high    <= 31'b0;
         pw_low     <= 31'b0;
      end else begin
         case (ps)
            first:   begin
                        if (~pwm) count_clk0 <= count_clk0 + 1'b1;
                        else      count_clk1 <= count_clk1 + 1'b1;
                     end
            low:     begin
                        if (count_clk1) begin
                           pw_high    <= count_clk1;
                           count_clk1 <= 31'b0;
                        end
                        count_clk0 <= count_clk0 + 1'b1;
                     end
            high:    begin
                        if (count_clk0) begin
                           pw_low     <= count_clk0;
                           count_clk0 <= 31'b0;
                        end
                        count_clk1 <= count_clk1 + 1'b1;
                     end
            default: begin
                        pw_low     <= 31'b0;
                        pw_high    <= 31'b0;
                        count_clk0 <= 31'b0;
                        count_clk1 <= 31'b0;
                     end
         endcase
      end

      pwm_prev <= pwm;
   end
   
   always @ (posedge clk) begin
      if (reset) ps <= init;
      else       ps <= ns;
   end
endmodule

module pulseLength_testbench ();
   reg         clk, reset;
   wire [30:0] pw_low, pw_high;
   wire [31:0] pwm_per;
   reg         pwm;

   pulseLength dut (
      .clk(clk),
      .reset(reset),
      .pw_low(pw_low),
      .pw_high(pw_high),
      .pwm_per(pwm_per),
      .pwm(pwm)
   );

   parameter CLK_PER = 10;
   initial begin
      clk <= 1;
      forever #(CLK_PER / 2) clk <= ~clk;
   end

   integer i, j;
   initial begin
            reset <= 0; pwm <= 0; @(posedge clk);
            reset <= 1;           @(posedge clk);
            reset <= 0; pwm <= 1; @(posedge clk);
                        pwm <= 0; @(posedge clk);
                        pwm <= 1; @(posedge clk);
      for (i = 0; i < 12; i = i + 1) begin
                                  @(posedge clk);
      end
                        pwm <= 0; @(posedge clk);
                        pwm <= 1; @(posedge clk);
      for (i = 0; i < 24; i = i + 1) begin
                                  @(posedge clk);
      end
                        pwm <= 0; @(posedge clk);
                        pwm <= 1; @(posedge clk);
      for (i = 0; i < 48; i = i + 1) begin
                                  @(posedge clk);
      end
                        pwm <= 0; @(posedge clk);
                        pwm <= 1; @(posedge clk);
      for (i = 0; i < 12; i = i + 1) begin
         for (j = 0; j < 4; j = j + 1) begin
                        pwm <= 0; @(posedge clk);
         end
         for (j = 0; j < 8; j = j + 1) begin
                        pwm <= 1; @(posedge clk);
         end
      end
      $stop;
   end
endmodule
