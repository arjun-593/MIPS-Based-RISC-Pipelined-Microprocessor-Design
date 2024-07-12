`timescale 1ns/1ns

// Ripple Carry Adder with cin - 4 bits
`include "Full_Adder.v"
module RCA4(output [3:0] sum, output cout, input [3:0] a, b, input cin);
  
  wire [3:1] c;
  
  Full_Adder fa0(sum[0], c[1], a[0], b[0], cin);
  Full_Adder fa1(sum[1], c[2], a[1], b[1], c[1]);
  Full_Adder fa2(sum[2], c[3], a[2], b[2], c[2]);
  Full_Adder fa31(sum[3], cout, a[3], b[3], c[3]);

 endmodule
