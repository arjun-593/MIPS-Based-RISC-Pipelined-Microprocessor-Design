`timescale 1ns / 1ps

module control_hazard(Rs_D, Rt_D, MemtoReg_E, Rt_E, Write_Reg_E, Write_Reg_M, Reg_Write_E,
                    Stall_F, Flush_E, Stall_D, Branch_D, MemtoReg_M);
                    
    input [4:0] Rs_D, Rt_E, Rt_D, Write_Reg_E, Write_Reg_M;
    input Reg_Write_E, MemtoReg_E;
    input Branch_D, MemtoReg_M;

    output reg Stall_D, Stall_F;
    output reg Flush_E;
 

    reg lwstall, branchstall;
    
       //Hazard Stall unit
    always@(*)
    begin 
    	lwstall = ((Rs_D == Rt_E) || (Rt_D == Rt_E)) && MemtoReg_E;

    	branchstall =   Branch_D & (Reg_Write_E 
    					& ((Write_Reg_E == Rs_D) | (Write_Reg_E == Rt_D)) | MemtoReg_M 
    					& ((Write_Reg_M == Rs_D) | (Write_Reg_M == Rt_D)));

    	Stall_F = lwstall || branchstall;
    	Stall_D = lwstall || branchstall;
    	Flush_E = lwstall || branchstall;

    end
endmodule
