# RISC-V-Mult-Cycle
## Supported ISA:
- RV32I (without lui、auipc、ecall、ebreak)
## Reference Material:
- 《COD》(RISC-V version)
- [RISCV_CARD.pdf (sfu.ca)](https://www.cs.sfu.ca/~ashriram/Courses/CS295/assets/notebooks/RISCV/RISCV_CARD.pdf)
- [Online RISC-V Assembler (lucasteske.dev)](https://riscvasm.lucasteske.dev/#)
- [Invisiphantom/RISC-V-Mult-Cycle (github.com)](https://github.com/Invisiphantom/RISC-V-Mult-Cycle)

## Environment(with profile below):
- WSL2-Ubuntu22.04
- VS Code
- Core VS  Code Extensions:
WSL、Code Runner、TerosHDL
- Icarus Verilog
- GTKWave

## Contained Files:
- WSL-Verilog.code-profile (My VSCode verilog-workspace profile)
- ROM.txt (Binary RISC-V Instructions that will be read into InstructionMemory.v verilog module)
- arch.v
- arch_tb.v
- PC.v
- InstructionMemory.v
- PC4Add.v
- ShiftLeft1.v
- PCAdd.v
- BranchJudge.v
- Control.v
- Registers.v
- ImmGen.v
- ALUControl.v
- ALU.v
- DataMemory.v
- IF_ID.v
- ID_EX.v
- EX_MEM.v
- MEM_WB.v
- ForwardingUnit.v
- ForwardMux.v
- HazardUnit.v

## SVG
- **arch.v**
  

![image](https://raw.githubusercontent.com/Invisiphantom/RISC-V-Pipeline/main/SVG/arch.svg)
---
- **Control.v**
  

![image](https://raw.githubusercontent.com/Invisiphantom/RISC-V-Pipeline/main/SVG/Control.svg)
---
- **ALUControl.v**
  

![image](https://raw.githubusercontent.com/Invisiphantom/RISC-V-Pipeline/main/SVG/ALUControl.svg)
---
- **ALU.v**
  

![image](https://raw.githubusercontent.com/Invisiphantom/RISC-V-Pipeline/main/SVG/ALU.svg)
---
- **Registers.v**
  

![image](https://raw.githubusercontent.com/Invisiphantom/RISC-V-Pipeline/main/SVG/Registers.svg)
---
- **BranchJudge.v**
  

![image](https://raw.githubusercontent.com/Invisiphantom/RISC-V-Pipeline/main/SVG/BranchJudge.svg)
---
- **IF_ID.v**
  

![image](https://raw.githubusercontent.com/Invisiphantom/RISC-V-Pipeline/main/SVG/IF_ID.svg)
---
- **ID_EX.v**
  

![image](https://raw.githubusercontent.com/Invisiphantom/RISC-V-Pipeline/main/SVG/ID_EX.svg)
---
- **EX_MEM.v**
  

![image](https://raw.githubusercontent.com/Invisiphantom/RISC-V-Pipeline/main/SVG/EX_MEM.svg)
---
- **ForwardingUnit.v**
  

![image](https://raw.githubusercontent.com/Invisiphantom/RISC-V-Pipeline/main/SVG/ForwardingUnit.svg)
---
- **HazardUnit.v**
  

![image](https://raw.githubusercontent.com/Invisiphantom/RISC-V-Pipeline/main/SVG/HazardUnit.svg)