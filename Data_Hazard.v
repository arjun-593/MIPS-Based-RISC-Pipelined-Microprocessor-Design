`timescale 1ns/1ns

module Data_Hazard_Unit(
    input [4:0] Rs_D, Rt_D, Rs_E, Rt_E, Write_Reg_E, Write_Reg_M,
    input Reg_Write_E, Reg_Write_M, Reg_Write_W,
    output reg [1:0] Forward_AE, Forward_BE,
    output reg Forward_AD, Forward_BD
);

    // Initial values for forwarding signals
    initial
    begin
        Forward_AE = 2'b00;
        Forward_BE = 2'b00;
        Forward_AD = 1'b1;
        Forward_BD = 1'b1; 
    end

    // Forwarding Unit
    always @(*)
    begin
        // Forward around EX hazard
        if (Reg_Write_M && (Write_Reg_M != 0) && (Write_Reg_M == Rs_E))
            Forward_AE = 2'b10;
        // Forward around MEM hazard
        else if (Reg_Write_W && (Write_Reg_M != 0) && (Write_Reg_M == Rs_E))
            Forward_AE = 2'b01;
        else
            Forward_AE = 2'b00;
    end

    always @(*)
    begin
        // Forward around EX hazard
        if (Reg_Write_M && (Write_Reg_M != 0) && (Write_Reg_M == Rt_E))
            Forward_BE = 2'b10;
        // Forward around MEM hazard
        else if (Reg_Write_W && (Write_Reg_M != 0) && (Write_Reg_M == Rt_E))
            Forward_BE = 2'b01;
        else
            Forward_BE = 2'b00;
    end

    always @(*)
    begin
        Forward_AD = (Write_Reg_M != 0) && (Rs_D == Write_Reg_M) && Reg_Write_M;
        Forward_BD = (Write_Reg_M != 0) && (Rt_D == Write_Reg_M) && Reg_Write_M;
    end

endmodule
