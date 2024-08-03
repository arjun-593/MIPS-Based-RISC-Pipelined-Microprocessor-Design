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
32 bit Program Counter, NO flag registers, very few addressing modes and assuming memory word size is 32 bits.

### Registers

32 Registers of 32 bit each. Register 0 is always read as zero and loads to it have no effect.

#### List of Instructions (Only a subset of the actual MIPS32 Instruction set have been executed)

Load and Store Instructions:

	LW  R2, 124(R8)      //R2 = Mem[R8+124]
	
	SW R5, -10(R42)      //Mem[R42-10] = R5


Arithmetic and Logic Functions on Register Operands: 

	ADD R1, R2, R3    //R1 = R2+R3

	ADD R1, R2, R0    //R1 = R2+0

	SUB R1, R2, R3    //R1 = R2-R3

	AND R1, R2, R3    //R1 = R2 & R3

	OR R1, R2, R3     //R1 = R2 | R3

	MUL R1, R2, R3    //R1 = R2*R3

	SLT R1, R2, R3    //IF R2 < R3, R1 = 1 ; else R1 = 0

	
Arithmetic and Logic Functions on Immediate Operands: 

	ADDI R1, R2, 34    //R1 = R2 + 34

	SUBI R1, R2, 42    //R1 = R2 - 42

	SLTI R1, R2, 16    // IF R2 < 16, R1 = 1; else R1 = 0


Branch Instructions:

	BEQZ R1, LOOP    //Branch to LOOP if R1 == 0

	BNEQZ R2, LOOP   //Branch to LOOP if R2 != 0

Jump Instructions have not been added.

Miscellaneous Instruction
	
	HLT    //HALT execution


### INSTRUCTION ENCODING


R- type, I-type and Jump-type (not included)


1. R-type

		
	|31-26 | 25-21 |20-16 |	15-11 |	11-0|
	| --- | --- | --- | --- | --- |
	|OPCODE| SOURCE Register 1| SOURCE Register 2| Destination Register | -empty-|                         
	
	<br />
	
	| Instruction | Code|
	| --- |---|
	| ADD | 000000 |  
	| SUB | 000001 |
	| AND | 000010 | 
	| OR | 000011 |
	| SLT | 000100 |
	| MUL | 000101 |
	| HLT | 111111 |
	
  	<br />
	
--> SUB R5, R12, R25
		
|000001|01100|11001|00101|00000000000|
|---|---|---|---|---|
|SUB|R12|R25|R5|empty|

<br />		
	
	
 2. I-type
 
 <br />
 
|31-26|	25-21| 20-16| 15-0|
|---|---|---|---|
|OPCODE| Source Register–1| Destination Register| 16 bit immediate Data|

<br />

|Instruction|Code|
|---|---|
|LW|001000|
|SW|001001|
|ADDI|001010|
|SUBI|001011|
|SLTI|001100|
|BNEQZ|	001101|
|BEQZ|	001110|


<br />

--> LW R20, 84(R9)
	
|001000	|01001	|10100	|0000000001010100|
|---|---|---|---|
|LW	|R9	|R20	|Offset|

<br />

--> BEQZ R25, Label

|001110|11001|00000|YYYYYYYYYYYYYYYY|
|---|---|---|---|
|BEQZ|R25|Unused|Offset|
		
--> HERE Offset = Number of Instructions we Need to go back +1

<br />
		
#### INSTRUCTION CYCLE

We divide the instruction cycle into 5 steps:
	 
   1. IF: Instruction Fetch : Here the instruction pointed to by the PC is fetched from the memory and also the next value of PC is computed.
	For the branch instruction, the new value of PC may be the target address. So PC is not updated in this stage; the new value is stored in a register NPC.
	
	
   2. ID: Instruction Decode : The instruction already fetched in IF is decoded. 
	        Decoding is done in parallel with reading the register operands rs and rt, the two source registers.
	        Similarly, the immediate data are sign extended.
		
		
   3. EX: Execution/ Effective Address Calculation : ALU is used to perform some calculation. ALU operates on the operands that have already been made ready in the 	last step.
   
   
   4. MEM: Memory Access : The only instructions that make use of this step are LOAD , STORE, and BRANCH.
	        LOAD and STORE access the memory. BRANCH updates the PC depending upon the outcome of the branch condition.
	    
	    
   5. WB: Register Write Back : The Result is written back in the register file. The result may come from ALU or memory System by load system. 

#### SAMPLE PROGRAM 1

To add 10, 20 and 25 and store it in a register

	1. ADDI R1, R0, 10;     //Store 10 in R1
	2. ADDI R2, R0, 20;    //Store 20 in R2
	3. ADDI R3, R0, 25;     //Store 25 in R3
	4. OR R7, R7, R7        --dummy instructions to avoid hazards
	5. OR R7, R7, R7        --dummy 
	6. ADD R4, R1, R2     //Add R1 and R2 and store in R4
	7. OR R7, R7, R7         --dummy
	8. ADD R5, R4, R3     // Add R4 and R3 and store in R5
	9. HLT
	
#### OUTPUT WAVEFORM:

![waveform](https://github.com/arjun-593/MIPS-Based-RISC-Pipelined-Microprocessor-Design/blob/main/data/demo/test1.png)

#### SAMPLE PROGRAM 2

To load the contents from a given memory address, add 45 to it and store it in the next memory location.
	
	1. ADDI  R1, R0, 120    //Store 120 in R1
	2. OR R3, R3, R3          //Dummy
	3. LW R2, 0(R1)           //Load R2 with Mem[R1]
	4. OR R3, R3, R3         //Dummy
	5. ADDI R2, R2, 45     //Add 45 to R2
	6. OR R3, R3, R3        //Dummy
	7. SW R2, 1(R1)         //Store the result of R2 in Mem[R1+1]
	8. HLT


### OUTPUT WAVEFORM:

![wave2](https://github.com/arjun-593/MIPS-Based-RISC-Pipelined-Microprocessor-Design/blob/main/data/demo/test2.png)


## References:
[1] M. N. Topiwala and N. Saraswathi, "Implementation of a 32-bit MIPS based RISC processor using Cadence," 2014 IEEE International Conference on Advanced Communications, Control and Computing Technologies, Ramanathapuram, India, 2014, pp. 979-983, doi: 10.1109/ICACCCT.2014.7019240. keywords: {Registers;Clocks;Switches;MIPS;5-stage pipeline;ASIC flow},

[2] S. S. Khairullah, "Realization of a 16-bit MIPS RISC pipeline processor," 2022 International Congress on Human-Computer Interaction, Optimization and Robotic Applications (HORA), Ankara, Turkey, 2022, pp. 1-6, doi: 10.1109/HORA55278.2022.9799944. keywords: {Human computer interaction;Reduced instruction set computing;VHDL;Pipelines;Personal digital devices;Logic gates;Hardware;pipeline;embedded;Harvard;fetch;combinational;sequential;implementation},

[3] A. E. Phangestu, I. T. Mujiono, M. I. Kom and S. Ahmad Zaini, "Five-Stage Pipelined 32-Bit RISC-V Base Integer Instruction Set Architecture Soft Microprocessor Core in VHDL," 2022 International Seminar on Intelligent Technology and Its Applications (ISITIA), Surabaya, Indonesia, 2022, pp. 304-309, doi: 10.1109/ISITIA56226.2022.9855292. keywords: {Seminars;VHDL;Microprocessors;Instruction sets;Pipelines;Licenses;Table lookup;RISC-V;RV32I;FPGA;VHDL;soft processor core;five-stage pipeline},

[4] COA Lectures by IITKGP, GateSmahers, Unacademy Pipelining - COA 

[5] S. M. Bhagat and S. U. Bhandari, "Design and Analysis of 16-bit RISC Processor," 2018 Fourth International Conference on Computing Communication Control and Automation (ICCUBEA), Pune, India, 2018, pp. 1-4, doi: 10.1109/ICCUBEA.2018.8697859. keywords: {Registers;Reduced instruction set computing;Computer architecture;Process control;Hardware design languages;Load modeling;RISC;Load/Store architecture;Von Neumann architecture},


