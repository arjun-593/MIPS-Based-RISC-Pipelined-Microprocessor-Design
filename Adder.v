`timescale 1ns/1ns

/* 1. Adder module performs 32-bit binary addition using a series of 1-bit full adders (FAs).It uses a generate block to instantiate 32 FA modules, 
      each responsible for adding one bit of add_a and add_b along with the carry-in from the previous bit. Basically it's a ripple carry adder.
   2. The initial carry-in (w[0]) is set to 0.
   3. The full adders work in parallel, with each stage passing its carry-out to the next stage.
   4. The result of the addition is stored in add_out, a 32-bit wide output. The carry-out from the most significant bit (stored in w[32]) 
       is not used in this design. Means we don't need that */

module Adder(add_a, add_b, add_out);

    input [31:0] add_a, add_b;
    wire [32:0] w;
    output [31:0] add_out;  
    genvar i;

    assign w[0] = 0;

    generate 
        for(i=0;i<32;i=i+1)
        begin: adder
            FA FA_inst(add_a[i], add_b[i], w[i], w[i+1], add_out[i]);
        end
    endgenerate

endmodule 

module FA(input a, input b,input cin, output cout, output s);

// {cout, s} concatenates cout and s into a 2-bit vector. 'a + b + cin' adds the three input bits, producing a 2-bit result 
// where the most significant bit is the carry-out and the least significant bit is the sum.
    assign {cout,s} = a+b+cin;
	 
endmodule 
