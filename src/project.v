/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_tt09_verilog_multiplier (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
    wire [3:0] m = ui_in[7:4];
    wire [3:0] q = ui_in[3:0];
    wire [8:0] p;

    wire [3:0] partial[3:0];
    wire [4:0] sum1, sum2, sum3;
    wire [3:0] c1, c2, c3, c4;
    
    assign partial[0][0] = m[0] & q[0];
    assign partial[0][1] = m[1] & q[0];
    assign partial[0][2] = m[2] & q[0];
    assign partial[0][3] = m[3] & q[0];
    assign partial[1][0] = m[0] & q[1];
    assign partial[1][1] = m[1] & q[1];
    assign partial[1][2] = m[2] & q[1];
    assign partial[1][3] = m[3] & q[1];
    assign partial[2][0] = m[0] & q[2];
    assign partial[2][1] = m[1] & q[2];
    assign partial[2][2] = m[2] & q[2];
    assign partial[2][3] = m[3] & q[2];
    assign partial[3][0] = m[0] & q[3];
    assign partial[3][1] = m[1] & q[3];
    assign partial[3][2] = m[2] & q[3];
    assign partial[3][3] = m[3] & q[3];
    
    fulladder inst1_1(partial[0][1], partial[1][0], 1'b0, sum1[0], c1[0]);
    fulladder inst1_2(partial[0][2], partial[1][1], c1[0], sum1[1], c1[1]);
    fulladder inst1_3(partial[0][3], partial[1][2], c1[1], sum1[2], c1[2]);
    fulladder inst1_4(partial[1][3], 1'b0, c1[2], sum1[3], sum1[4]);
    
    fulladder inst2_1(sum1[1], partial[2][0], 1'b0, sum2[0], c2[0]);
    fulladder inst2_2(sum1[2], partial[2][1], c2[0], sum2[1], c2[1]);
    fulladder inst2_3(sum1[3], partial[2][2], c2[1], sum2[2], c2[2]);
    fulladder inst2_4(sum1[4], partial[2][3], c2[2], sum2[3], sum2[4]);
    
    fulladder inst3_1(sum2[1], partial[3][0], 1'b0, sum3[0], c3[0]);
    fulladder inst3_2(sum2[2], partial[3][1], c3[0], sum3[1], c3[1]);
    fulladder inst3_3(sum2[3], partial[3][2], c3[1], sum3[2], c3[2]);
    fulladder inst3_4(sum2[4], partial[3][3], c3[2], sum3[3], sum3[4]);
    
    assign p[0] = partial[0][0];
    assign p[1] = sum1[0];
    assign p[2] = sum2[0]; 
    assign p[3] = sum3[0];
    assign p[4] = sum3[1];
    assign p[5] = sum3[2];
    assign p[6] = sum3[3];
    assign p[7] = sum3[4];
  
  assign uo_out = p;


  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule

module fulladder(
    input a,
    input b,
    input c,
    output y,
    output z
    );
    
// Internal Signals
    wire int_sig1;
    wire int_sig2;
    wire int_sig3;
    wire int_sig4;
    wire int_sig5;
    wire int_sig6;
    wire int_sig7;
    wire int_sig8;
        
    assign int_sig1 = a & ~b;
    assign int_sig2 = ~a & b;
    assign int_sig3 = int_sig1 + int_sig2;
    assign int_sig4 = int_sig3 & ~c;
    assign int_sig5 = ~int_sig3 & c;
    assign y = int_sig4 + int_sig5; 
    assign int_sig6 = a & b;
    assign int_sig7 = b & c;
    assign int_sig8 = c & a;    
    assign z = int_sig6 | int_sig7 | int_sig8;
     
endmodule
