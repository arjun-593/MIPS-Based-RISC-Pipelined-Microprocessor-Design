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
- [Approach-1](https://github.com/arjun-593/Microprocessor-IITISoC-24/blob/main/data/demo/png) - Foundation Approach( Designed a single-core MIPS based RISC Microprocessor)
- [Approach-2]() - Pipelined the existing design by bringing neseccary changes to existing modules and architecture.

### Approach-1 :
In this approach, we implemented a top level Pocessor file and it's testbench processor_tb to simulate our design. Our design consisted of Reg_files, Arithmetic Logical Unit, Datapath, Control Unit, Instruction Fetch Unit, Instruction_Memory with data stored. We started with implementing Direct Register Addressing mode.

<img src="https://github.com/arjun-593/Microprocessor-IITISoC-24/blob/main/data/demo/png" width = 848 height = 480>
