`timescale 1ns/1ns

/* Reg 0-7 normal register
   Reg 8-15 Floating register */

/* 1. This module defines a register file with 32 registers, each 32 bits wide.
   2. It can read two registers simultaneously (useful for instructions that need to operate on two operands, like addition or subtraction.)
      and write (write_data is a 32-bit input that holds the data to be written to the register specified by 5 bit write_add.) to one register.
      Either reading two registers simulatenously in one clock cycle / write to a register in one clock cycle can happen.
   3. The register at address 0 is always read as 0 (Even if there's an attempt to write to this register, it will will always return 0).
   4. The module supports synchronous reset and handles write conflicts (If a read and write operation target the same register in the same cycle, 
      and en_write is high, the data being written (i.e., write_data) will be the data read out.) during read operations. */

module Register_File(clk, rst, en_write, read_add1, read_add2, read_data1, read_data2, write_add, write_data);

    input en_write, clk, rst;
   input [4:0] read_add2, read_add1, write_add; //Addresses for reading data & Address for writing data.
   input [31:0] write_data; //Data input to be written into the register file.
   output reg [31:0] read_data1, read_data2; //Data outputs from the register file.
    

    //Register file storage
    reg [31:0] reg_mem [31:0];
    integer i;

    initial
        for (i=0;i<32;i=i+1)
            reg_mem[i] = 32'b0;

    //Read and write from register file 
    always@(negedge clk)
    begin

        if(rst == 1)
            for (i=0; i<32; i=i+1)
                reg_mem[i] = 32'b0;

        else
        begin
        
        //Address 1
           
 // If read_add1 is 0, read_data1 is set to 0 (register 0 is hardwired to 0 in MIPS architecture).
           if(read_add1 == 0)   
            read_data1 = 32'b0; 
// If read_add1 matches write_add and writing is enabled -> it means the same address is being read and written in the same cycle, so read_data1 is set to write_data.    
        else if((read_add1 == write_add) && en_write)
            read_data1 = write_data;
// Else read_data1 is set to the value stored in the register at address read_add1.
        else
            read_data1 = reg_mem[read_add1] [31:0];

        //Address 2
           
// If read_add2 is 0, read_data2 is set to 0.
        if(read_add2 == 0)
            read_data2 = 32'b0;
// If read_add2 matches write_add and writing is enabled, read_data2 is set to write_data.
        else if((read_add2 == write_add) && en_write)
            read_data2 = write_data;
// Else read_data2 is set to the value stored in the register at address read_add2.
        else
            read_data2  = reg_mem[read_add2] [31:0];

       //Write data

// If writing is enabled (en_write is high) and the write address (write_add) is not 0, write_data is written to the register at address write_add.
        if(en_write && write_add != 0)
            reg_mem[write_add] = write_data;

        end
    
    end
    
endmodule
