/*
ALU module, which takes two operands of size 32-bits each and a 4-bit ALU_control as input.
Operation is performed on the basis of ALU_control value and output is 32-bit ALU_result. 
If the ALU_result is zero, a ZERO FLAG is set.
*/

/*
ALU Control lines | Function
-----------------------------
        0000    Bitwise-AND
        0001    Bitwise-OR
        0010	Add (A+B)
        0100	Subtract (A-B)
        1000	Set on less than
        0011    Shift left logical
        0101    Shift right logical
        0110    Multiply
        0111    Bitwise-XOR
*/
/* Old code */

module ALU (
    input [31:0] in1,in2, 
    input[3:0] alu_control,
    output reg [31:0] alu_result,
    output reg zero_flag
);
    always @(*)
    begin
        // Operating based on control input
        case(alu_control)

        4'b0000: alu_result = in1&in2;
        4'b0001: alu_result = in1|in2;
        4'b0010: alu_result = in1+in2;
        4'b0100: alu_result = in1-in2;
        4'b1000: begin 
            if(in1<in2)
            alu_result = 1;
            else
            alu_result = 0;
        end
        4'b0011: alu_result = in1<<in2;
        4'b0101: alu_result = in1>>in2;
        4'b0110: alu_result = in1*in2;
        4'b0111: alu_result = in1^in2;

        endcase

        // Setting Zero_flag if ALU_result is zero
        if (alu_result == 0)
            zero_flag = 1'b1;
        else
            zero_flag = 1'b0;
        
    end
endmodule

//////////////////////////////////////////////////////////////////////////////////
/*New code*/
`timescale 1ns / 1ps

module ALU(
	input [31:0]firstInput, secondInput,
	input [3:0]alucontrol,
	
	output [31:0]ALUout,
	output zero
    );
	 
	 assign ALUout = (alucontrol == 'b0000) ? (firstInput + secondInput) :    //and
				 (alucontrol == 'b0001) ? (firstInput - secondInput) :           //sub
				 (alucontrol == 'b0010) ? (firstInput ^ secondInput) :           //xor
				 (alucontrol == 'b0011) ? (firstInput | secondInput) :           //or
				 (alucontrol == 'b0100) ? (firstInput & secondInput) :           //and
				 (alucontrol == 'b0101) ? (~firstInput) :                        //not
				 (alucontrol == 'b0110) ? (firstInput << secondInput[4:0]) :     //shift left logical
				 (alucontrol == 'b0111) ? (firstInput >> secondInput[4:0]) :     //shift right logical
				 (alucontrol == 'b1000) ? ((firstInput < secondInput) ? 1 : 0)  ://set less than
				 -1;
				 
	assign zero = (ALUout == 0) ? 1 : 0;


endmodule
