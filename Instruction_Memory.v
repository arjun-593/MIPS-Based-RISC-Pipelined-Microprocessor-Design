`timescale 1ns/1ns

module Instruction_Memory(inst_add, inst);

    input wire [31:0] inst_add;
    output wire [31:0] inst;

    reg [31:0] mem [255:0];
    integer i;  // Declare the integer variable outside the initial block

    initial begin
       
        // Initialize the memory with predefined values
        mem[0] = 32'b00100000000000110000000000000011; //opcode = 8
        mem[1] = 32'b00110000000001000000000000000100; // opcode = 12
        mem[2] = 32'b00110100000001010000000000000101; // opcode = 13
        mem[3] = 32'b00101000000001100000000000000010; // opcode = 10
        mem[4] = 32'b10001100000001100000000000000010; // opcode = 35
        mem[5] = 32'b10101100100000110101100000000001; // opcode = 43
        mem[6] = 32'b00111000000001000000000000000100;// opcode = 14
        mem[7] = 32'b00000000000001100000000000000000; //opcode = 0, alu_con = 0, add r type
        mem[8] = 32'b00000000000001010000000000000001; 
        mem[9] = 32'b00000000000001010000000000000010; 
        mem[10] = 32'b00000000000001010000000000000011; 
        mem[11] = 32'b00000000000001010000000000000100; 
        mem[12] = 32'b00000000000001010000000000000101; 
        mem[13] = 32'b00000000000001010000000000000110; 
        mem[14] = 32'b00000000000001010000000000001000; 
        mem[15] = 32'b00000000000001010000000000001001; 
        mem[16] = 32'b00000000000001010000000000001010; 
        mem[17] = 32'b00000000000001010000000000001011; 
        mem[18] = 32'b00000000000001010000000000001100; 
        mem[19] = 32'b00000000000001010000000000001101; 
        mem[20] = 32'b00000000000001010000000000001110; 
        mem[21] = 32'b00000000000001010000000000001111; 
        mem[22] = 32'b000000zzzzzzzzzzzzzzzzzzzzzzzzzz;
      
        
        
        // Initialize the rest of the memory to 0
        for (i = 23; i < 256; i = i + 1) begin
            mem[i] = 32'b0;
        end
    end

    assign inst = mem[inst_add[7:0]];

endmodule
