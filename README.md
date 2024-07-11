# Microprocessor-IITISoC-24

## Goal :
To Design a Microprocessor using Verilog HDL to perform at least basic arithmetic and logical operations. Later on pipelining the design and avoid redundancy. 

People Involved :

Mentors:
- [Lavanya](https://github.com/SaiLLV) 

Members:
<br>
- [Bhawna Chaudhary](https://github.com/WebWizard104)
- [Arjun S Nair](https://github.com/arjun-593)
- [Deepesh Bansal](https://github.com/DeepeshBansal)
- [Anushka Jha](https://github.com/jhaanushka)

### Outline :
This repository contains the implementation of a 32-bit MIPS based RISC microprocessor using two different approaches. The main goal of this project was to understand the core fundamentals of Microprocessor design and Computer Oraganization and Architecture with a hardware description language like Verilog. The two approaches utilized are as follows:
<br>
- [Approach-1](https://github.com/arjun-593/Microprocessor-Design/tree/main/Approach-1) - Designed a single-core MIPS based RISC Microprocessor (Till Mid-Evaluation)
- [Approach-2]() - Pipelined the existing design by bringing neseccary changes to existing modules and architecture.

### Approach-1 :
In this approach, we implemented a top level Pocessor file and it's testbench processor_tb to simulate our design. Our design consisted of Reg_files, Arithmetic Logical Unit, Datapath, Control Unit, Instruction Fetch Unit, Instruction_Memory with data stored. We started with implementing Direct Register Addressing mode (R Type) with a total of 32 registers storing values.

<img src="https://github.com/DeepeshBansal/Microprocessor-IITISoC-24/blob/main/data/demo/processor_png" width = 848 height = 400>

#### Modules Explanation : 
<br>
<ul>
<li> <strong>Processor module </strong> : Being the main module, it integrates all the modules defined so far, i.e. fetches instruction from instruction memory (present inside the instruction fetch unit). Then the corresponding fractions of instructions are then passed to control unit and data path for further processing. Alu & other control signals from control unit to data path are also handled in this module. </li>
<br> 
<li> <strong>Instruction Fetch Unit (IFU) </strong> : Responsible for fetching instructions from memory for a CPU. It has inputs for clock and reset, and outputs a 32-bit Instruction_Code. The module maintains a 32-bit program counter (PC), initialized to 0. An instance of INST_MEM is used to fetch the instruction corresponding to the current PC.</li>
<br>
<li> <strong>Instruction Memory </strong> : It takes a 32-bit program counter (PC) and a 1-bit reset signal as inputs and outputs a 32-bit instruction code (Instruction_Code). The memory is byte-addressable with 32 locations, and the 32-bit instruction is assembled from four consecutive bytes in memory based on the PC value.</li>
<br>
<li> <strong>Control Unit </strong> : Control unit for determining the ALU operation and register write control for R-type instructions in a CPU. Based on the opcode, funct3, and funct7 inputs, it sets the alu_control output to specify the ALU operation (such as ADD, SUB, OR, AND, etc.) and the regwrite_control output to indicate whether a register should be written to.</li>
<br>
<li> <strong>Datapath </strong> : Uses alu_control & regWrite_control input of Control Unit to write the intermediate values before finally storing in Instruction memory. It also Instantiates ALU and REG_File.</li>
<br>
<li> <strong>ALU </strong> : ALU module, takes two operands of size 32-bits each and a 4-bit ALU_control as input (for performing operations based on it) and output is 32-bit ALU_result. If the ALU_result is zero, a ZERO FLAG is set. ALU functions  controlled by alu_control - 
  <ul>
<li>(0000) Bitwise-AND</li>
<li>(0001) Bitwise-OR</li>
<li>(0010) Add (A+B)</li>
<li>(0100) Subtract (A-B)</li>
<li>(1000) Set on less than</li>
<li>(0011) Shift left logical</li>
<li>(0101) Shift right logical</li>
<li>(0110) Multiply</li>
<li>(0111) Bitwise-XOR.</li>
  </ul>
</li>
<br>
<li> <strong>Register File module </strong> : A register file can read two registers and write in to one register. The RISC register file contains total of 32 registers each of size 32-bit. Hence 5-bits are used to specify the register numbers that are to be read or written.
  <ul>
<li>Register Read: outputs the contents of the register corresponding to read register numbers specified.</li>
<li>Register Write: Register writes are controlled by a control signal RegWrite.</li>  
  </ul>
The write should happen if RegWrite signal is made 1 and if there is positive edge of clock. The register file will always output the vaules corresponding to read register numbers.</li>
<br>
</ul>

#### Results :
Main work was focused on Integration and Initial Testing of our code. Then after a series of Testing and Debugging, we successfully simulated the single-core MIPS based RISC Microprocessor to get expected results. Below ae the simulation results:

<img src="https://github.com/DeepeshBansal/Microprocessor-IITISoC-24/blob/main/data/demo/results_png" width = 848 height = 400>

#### Disadvantages :
- Lacks parallelisation, So not very effective for some workloads.
- Slower execution speeds. 


### Approach-2 :
In this approach, we have explored the effectiveness of pipelining, and are implementing a 5-stage pipelinig for better results.

## References:
[1] M. N. Topiwala and N. Saraswathi, "Implementation of a 32-bit MIPS based RISC processor using Cadence," 2014 IEEE International Conference on Advanced Communications, Control and Computing Technologies, Ramanathapuram, India, 2014, pp. 979-983, doi: 10.1109/ICACCCT.2014.7019240. keywords: {Registers;Clocks;Switches;MIPS;5-stage pipeline;ASIC flow},

[2]
