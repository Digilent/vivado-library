//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.4 (win64) Build 1412921 Wed Nov 18 09:43:45 MST 2015
//Date        : Fri Feb 05 15:23:13 2016
//Host        : WK116 running 64-bit major release  (build 9200)
//Command     : generate_target pmod_concat.bd
//Design      : pmod_concat
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module pmod_concat #(
    parameter Top_Row_Interface = "GPIO",
    parameter Bottom_Row_Interface = "GPIO"
) (
    output [3:0] in_top_gpio_i,
    input  [3:0] in_top_gpio_o,
    input  [3:0] in_top_gpio_t,
    
    output [1:0] in_top_uart_gpio_i,
    input  [1:0] in_top_uart_gpio_o,
    input  [1:0] in_top_uart_gpio_t,
    output in_top_uart_rxd_i,
    input  in_top_uart_txd_o,
    
    output [1:0] in_top_i2c_gpio_i,
    input  [1:0] in_top_i2c_gpio_o,
    input  [1:0] in_top_i2c_gpio_t,
    output in_top_i2c_scl_i,
    input  in_top_i2c_scl_o,
    input  in_top_i2c_scl_t,
    output in_top_i2c_sda_i,
    input  in_top_i2c_sda_o,
    input  in_top_i2c_sda_t,
    
    output in_top_spi_ss_i,
    input  in_top_spi_ss_o,
    input  in_top_spi_ss_t,
    output in_top_spi_sck_i,
    input  in_top_spi_sck_o,
    input  in_top_spi_sck_t,
    output in_top_spi_io0_i,
    input  in_top_spi_io0_o,
    input  in_top_spi_io0_t,
    output in_top_spi_io1_i,
    input  in_top_spi_io1_o,
    input  in_top_spi_io1_t,

    output [3:0] in_bottom_gpio_i,
    input  [3:0] in_bottom_gpio_o,
    input  [3:0] in_bottom_gpio_t,
        
    output [1:0] in_bottom_uart_gpio_i,
    input  [1:0] in_bottom_uart_gpio_o,
    input  [1:0] in_bottom_uart_gpio_t,
    output in_bottom_uart_rxd_i,
    input  in_bottom_uart_txd_o,
    
    output [1:0] in_bottom_i2c_gpio_i,
    input  [1:0] in_bottom_i2c_gpio_o,
    input  [1:0] in_bottom_i2c_gpio_t,
    output in_bottom_i2c_scl_i,
    input  in_bottom_i2c_scl_o,
    input  in_bottom_i2c_scl_t,
    output in_bottom_i2c_sda_i,
    input  in_bottom_i2c_sda_o,
    input  in_bottom_i2c_sda_t,

    output in_bottom_spi_ss_i,
    input  in_bottom_spi_ss_o,
    input  in_bottom_spi_ss_t,
    output in_bottom_spi_sck_i,
    input  in_bottom_spi_sck_o,
    input  in_bottom_spi_sck_t,
    output in_bottom_spi_io0_i,
    input  in_bottom_spi_io0_o,
    input  in_bottom_spi_io0_t,
    output in_bottom_spi_io1_i,
    input  in_bottom_spi_io1_o,
    input  in_bottom_spi_io1_t,

    input out0_I,
    input out1_I,
    input out2_I,
    input out3_I,
    input out4_I,
    input out5_I,
    input out6_I,
    input out7_I,
    output out0_O,
    output out1_O,
    output out2_O,
    output out3_O,
    output out4_O,
    output out5_O,
    output out6_O,
    output out7_O,
    output out0_T,
    output out1_T,
    output out2_T,
    output out3_T,
    output out4_T,
    output out5_T,
    output out6_T,
    output out7_T
);
    generate
        case (Top_Row_Interface)
            "GPIO": begin
                assign in_top_gpio_i = {out3_I,out2_I,out1_I,out0_I};
                assign {out3_O,out2_O,out1_O,out0_O} = in_top_gpio_o;
                assign {out3_T,out2_T,out1_T,out0_T} = in_top_gpio_t;
            end
            "UART": begin
                assign in_top_uart_gpio_i = {out3_I,out0_I};
                assign {out3_O,out0_O} = in_top_uart_gpio_o;
                assign {out3_T,out0_T} = in_top_uart_gpio_t;
                assign out1_O = in_top_uart_txd_o;
                assign in_top_uart_rxd_i = out2_I;
                assign out1_T = 0;
                assign out2_T = 1;
            end
            "I2C": begin
                assign in_top_i2c_gpio_i = {out1_I,out0_I};//Input is I2C bus, output is to Pmod Pins
                assign {out1_O,out0_O} = in_top_i2c_gpio_o;
                assign {out1_T,out0_T} = in_top_i2c_gpio_t;
                assign out2_O = in_top_i2c_scl_o;
                assign out2_T = in_top_i2c_scl_t;
                assign in_top_i2c_scl_i = out2_I;
                assign out3_O = in_top_i2c_sda_o;
                assign out3_T = in_top_i2c_sda_t;
                assign in_top_i2c_sda_i = out3_I;
            end
            "SPI": begin
                assign in_top_spi_ss_i = out0_I;
                assign out0_O = in_top_spi_ss_o;
                assign out0_T = in_top_spi_ss_t;
                assign in_top_spi_io1_i = out1_I; // mosi
                assign out1_O = in_top_spi_io1_o;
                assign out1_T = in_top_spi_io1_t;
                assign in_top_spi_io0_i = out2_I; // miso
                assign out2_O = in_top_spi_io0_o;
                assign out2_T = in_top_spi_io0_t;
                assign in_top_spi_sck_i = out3_I;
                assign out3_O = in_top_spi_sck_o;
                assign out3_T = in_top_spi_sck_t;
            end
            default: begin
                assign out0_O = 0;
                assign out1_O = 0;
                assign out2_O = 0;
                assign out3_O = 0;
                assign out0_T = 1;
                assign out1_T = 1;
                assign out2_T = 1;
                assign out3_T = 1;
            end
        endcase
    endgenerate
  
    generate
        case (Bottom_Row_Interface)
            "GPIO": begin
                assign in_bottom_gpio_i = {out7_I,out6_I,out5_I,out4_I};
                assign {out7_O,out6_O,out5_O,out4_O} = in_bottom_gpio_o;
                assign {out7_T,out6_T,out5_T,out4_T} = in_bottom_gpio_t;
            end
            "UART": begin
                assign in_bottom_uart_gpio_i = {out7_I,out4_I};
                assign {out7_O,out4_O} = in_bottom_uart_gpio_o;
                assign {out7_T,out4_T} = in_bottom_uart_gpio_t;
                assign out5_O = in_bottom_uart_txd_o;
                assign in_bottom_uart_rxd_i = out6_I;
                assign out5_T = 0;
                assign out6_T = 1;
            end
            "I2C": begin
                assign in_bottom_i2c_gpio_i = {out5_I,out4_I};//Input is i2c bus, output is to Pmod Pins
                assign {out5_O,out4_O} = in_bottom_i2c_gpio_o;
                assign {out5_T,out4_T} = in_bottom_i2c_gpio_t;
                assign out6_O = in_bottom_i2c_scl_o;
                assign out6_T = in_bottom_i2c_scl_t;
                assign in_bottom_i2c_scl_i = out6_I;
                assign out7_O = in_bottom_i2c_sda_o;
                assign out7_T = in_bottom_i2c_sda_t;
                assign in_bottom_i2c_sda_i = out7_I;
            end
            "SPI": begin
                assign in_bottom_spi_ss_i = out4_I;
                assign out4_O = in_bottom_spi_ss_o;
                assign out4_T = in_bottom_spi_ss_t;
                assign in_bottom_spi_io0_i = out5_I; // mosi
                assign out5_O = in_bottom_spi_io1_o;
                assign out5_T = in_bottom_spi_io1_t;
                assign in_bottom_spi_io0_i = out6_I; // miso
                assign out6_O = in_bottom_spi_io0_o;
                assign out6_T = in_bottom_spi_io0_t;
                assign in_bottom_spi_sck_i = out7_I;
                assign out7_O = in_bottom_spi_sck_o;
                assign out7_T = in_bottom_spi_sck_t;
            end
            default: begin
                assign out4_O = 0;
                assign out5_O = 0;
                assign out6_O = 0;
                assign out7_O = 0;
                assign out4_T = 1;
                assign out5_T = 1;
                assign out6_T = 1;
                assign out7_T = 1;
            end
        endcase
    endgenerate
endmodule
