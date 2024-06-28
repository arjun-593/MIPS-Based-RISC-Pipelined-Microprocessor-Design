// processor_tb.v

`timescale 1ns / 1ps

module processor_tb;

    // Inputs
    reg clock;
    reg reset;

    // Outputs
    wire zero;

    // Internal signals for monitoring
    wire [31:0] instruction_code;
    wire [31:0] PC;
    wire [3:0] alu_control;
    wire regwrite;
    wire [4:0] read_reg_num1;
    wire [31:0] read_data1;
    wire [4:0] read_reg_num2;
    wire [31:0] read_data2;
    wire [4:0] write_reg;
    wire [31:0] write_data;

    // Instantiate the Processor
    PROCESSOR uut (
        .clock(clock),
        .reset(reset),
        .zero(zero)
    );

    // Clock generation
    always #5 clock = ~clock; // Toggle clock every 5 time units (100 MHz clock)

    // Assign internal signals for monitoring
    assign instruction_code = uut.IFU_module.Instruction_Code;
    assign PC = uut.IFU_module.PC;
    assign alu_control = uut.control_module.alu_control;
    assign regwrite = uut.control_module.regwrite_control;
    assign read_reg_num1 = uut.datapath_module.read_reg_num1;
    assign read_data1 = uut.datapath_module.read_data1;
    assign read_reg_num2 = uut.datapath_module.read_reg_num2;
    assign read_data2 = uut.datapath_module.read_data2;
    assign write_reg = uut.datapath_module.write_reg;
    assign write_data = uut.datapath_module.write_data;

    initial begin
        // Initialize Inputs
        clock = 0;
        reset = 0;

        // Apply reset
        #10; // Delay 10 time units
        reset = 1; // Assert reset
        #10; // Delay to allow reset propagation
        reset = 0; // Deassert reset

        // Run the simulation to observe waveforms
        #100; // Run simulation for sufficient time to observe the outputs
        $stop; // Stop the simulation

    end

endmodule
