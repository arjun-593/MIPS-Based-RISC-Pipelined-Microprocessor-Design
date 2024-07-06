`timescale 1ns / 1ps

module Multiplexer2To1_5bit(
		input [4:0]A, B,
		input select,
		output [4:0]result
    );

	assign result = select ? B : A;

endmodule
