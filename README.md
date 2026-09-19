# RV32I Mini Core

这是我的第一颗 RISC-V 处理器核心

项目使用 Verilog 从零搭建一颗简化的 **RV32I Single-Cycle CPU — RV32I 单周期处理器**

项目主要用于学习和理解：

* RISC-V ISA 与 Microarchitecture 的关系
* Processor State
* Datapath
* Control
* Instruction Decode
* ALU
* Register File
* Immediate Generator
* Memory Access
* Write Back
* Branch 与 Jump
* Next-PC Logic
* Single-Cycle CPU 的完整执行过程

当前 Single-Cycle CPU 学习阶段已经完成

> 当前版本并不是完整 RV32I ISA 实现
> 而是实现了一组用于学习 Single-Cycle Microarchitecture 的 RV32I 指令子集

---

## 当前状态

当前已经完成：

* [x] PC Register
* [x] Instruction Memory
* [x] Register File
* [x] Immediate Generator
* [x] ALU
* [x] Main Decoder
* [x] ALU Decoder
* [x] Data Memory
* [x] Write-Back Datapath
* [x] Branch Control
* [x] JAL
* [x] JALR
* [x] Next-PC Logic
* [x] Single-Cycle Top-Level Datapath
* [x] 各基础模块 Testbench
* [x] Instruction Expansion 模块级验证
* [x] CPU-Level Full Program Test
* [x] Single-Cycle v2 Regression Test

当前 Single-Cycle v2 作为稳定学习版本冻结

后续学习将从 Single-Cycle CPU 转向：

```text
Multi-Cycle CPU
        ↓
Pipeline CPU
        ↓
Hazard / Forwarding / Stall / Flush
        ↓
Memory Hierarchy / Cache
        ↓
Processor Performance
        ↓
SIMD / Vector
        ↓
AI Accelerator Architecture
```

---

## 当前支持的指令

当前共实现 18 条指令

### R-type Arithmetic / Logic

| Instruction | Function    |
| ----------- | ----------- |
| `ADD`       | 加法          |
| `SUB`       | 减法          |
| `AND`       | 按位与         |
| `OR`        | 按位或         |
| `XOR`       | 按位异或        |
| `SLL`       | 逻辑左移        |
| `SLT`       | Signed 小于比较 |
| `SRL`       | 逻辑右移        |
| `SRA`       | 算术右移        |

### I-type

| Instruction | Function     |
| ----------- | ------------ |
| `ADDI`      | Immediate 加法 |

### Load / Store

| Instruction | Function              |
| ----------- | --------------------- |
| `LW`        | 从 Data Memory 读取 Word |
| `SW`        | 向 Data Memory 写入 Word |

### Branch

| Instruction | Function       |
| ----------- | -------------- |
| `BEQ`       | 相等时跳转          |
| `BNE`       | 不相等时跳转         |
| `BLT`       | Signed 小于时跳转   |
| `BGE`       | Signed 大于等于时跳转 |

### Jump

| Instruction | Function                            |
| ----------- | ----------------------------------- |
| `JAL`       | PC Relative Jump 并保存 `PC + 4`       |
| `JALR`      | Register Indirect Jump 并保存 `PC + 4` |

---

## Single-Cycle Microarchitecture

当前处理器采用 Single-Cycle Microarchitecture

一条 Instruction 所需要的全部组合逻辑工作必须在一个 Clock Cycle 内完成

在 Clock Rising Edge 更新 Processor State

主要 Architectural State：

```text
PC Register

Register File

Data Memory
```

主要 Combinational Logic：

```text
Instruction Memory

Main Decoder

ALU Decoder

Immediate Generator

ALU

ALUSrc MUX

Write-Back MUX

Branch Condition Logic

Next-PC Logic
```

整体关系可以简化为：

```text
                Current State
                     │
          ┌──────────┼──────────┐
          │          │          │
          PC     Register File  Data Memory
          │          │
          ▼          ▼
     ┌─────────────────────────────┐
     │                             │
     │     Combinational Logic     │
     │                             │
     │   Instruction Memory        │
     │   Decoder                   │
     │   Immediate Generator       │
     │   MUX                       │
     │   ALU                       │
     │   Memory Read               │
     │   Branch / Jump Logic       │
     │   Write-Back Logic          │
     │                             │
     └──────────────┬──────────────┘
                    │
                    ▼
                Next State
```

---

## Datapath

Instruction 从 Instruction Memory 取出后会同时提供给不同模块

```text
Instruction
    │
    ├── Opcode
    │      ↓
    │   Main Decoder
    │
    ├── funct3 / funct7
    │      ↓
    │   ALU Decoder
    │
    ├── rs1 / rs2 / rd
    │      ↓
    │   Register File
    │
    └── Immediate Bits
           ↓
        ImmGen
```

主要数据通路：

```text
PC
↓
Instruction Memory
↓
Instruction
↓
Register File
↓
ALUSrc MUX
↓
ALU
↓
Data Memory
↓
Write-Back MUX
↓
Register File
```

同时存在独立的 Next-PC Path：

```text
PC + 4

PC + Immediate

RF[rs1] + Immediate
        ↓
Next-PC Logic
        ↓
next_pc
        ↓
PC Register
```

---

## Write-Back

当前 Write-Back MUX 支持三种数据来源

```text
result_src = 00
→ ALU Result

result_src = 01
→ Memory Read Data

result_src = 10
→ PC + 4
```

主要对应：

```text
Arithmetic / Logic
→ ALU Result

LW
→ Memory Read Data

JAL / JALR
→ PC + 4
```

---

## Branch 与 Jump

当前支持：

```text
BEQ
BNE
BLT
BGE
JAL
JALR
```

Branch Target：

```text
PC + Immediate
```

JAL Target：

```text
PC + J-type Immediate
```

JALR Target：

```text
RF[rs1] + I-type Immediate
```

JALR 最终地址最低位强制清零：

```text
jalr_target = {alu_result[31:1]  1'b0}
```

---

## Memory

### Instruction Memory

当前 Instruction Memory：

```text
256 × 32 bit
```

输入为 32-bit Byte Address

内部使用：

```text
word_index = address[9:2]
```

Instruction Memory 使用组合读取

CPU Runtime 期间只读

未使用位置初始化为：

```verilog
32'h0000_0013
```

也就是：

```text
ADDI x0 x0 0
```

---

### Data Memory

当前 Data Memory：

```text
256 × 32 bit
```

特点：

```text
组合读取

Rising Edge 写入
```

地址同样使用 Word Index

---

## 项目结构

```text
RV32I_Mini_Core_v1/
│
├── rtl/
│   ├── rv32i_core.v
│   ├── pc_reg.v
│   ├── instruction_memory.v
│   ├── regfile.v
│   ├── imm_gen.v
│   ├── main_decoder.v
│   ├── alu_decoder.v
│   ├── alu.v
│   ├── data_memory.v
│   └── next_pc_logic.v
│
├── tb/
│   ├── tb_pc_reg.v
│   ├── tb_instruction_memory.v
│   ├── tb_regfile.v
│   ├── tb_imm_gen.v
│   ├── tb_main_decoder.v
│   ├── tb_alu_decoder.v
│   ├── tb_alu.v
│   ├── tb_data_memory.v
│   ├── tb_next_pc_logic.v
│   └── tb_rv32i_core.v
│
├── programs/
│   ├── imem_test.hex
│   └── full_program_test.hex
│
├── sim/
│   └── modelsim/
│       ├── cpu_wave.do
│       └── 使用方法.md
│
├── .gitignore
├── README.md
└── push_to_github.bat
```

---

## Verification

当前项目采用 ModelSim 进行 Functional Simulation

验证分为两个层级

### Module-Level Verification

各独立模块均使用对应 Testbench 进行功能验证

包括：

```text
PC Register

Instruction Memory

Register File

Immediate Generator

Main Decoder

ALU Decoder

ALU

Data Memory

Next-PC Logic
```

---

### CPU-Level Regression Test

完整 CPU 使用：

```text
programs/full_program_test.hex
```

进行整机 Regression Test

Test Program 同时覆盖原有指令和后续扩展指令

```text
ADD
SUB
AND
OR
XOR

ADDI

LW
SW

BEQ

SLL
SLT
SRL
SRA

BNE
BLT
BGE

JAL
JALR
```

同时验证：

```text
Arithmetic / Logic

Signed Compare

Shift Amount Low 5 bit

Load / Store

Branch Taken

Branch Not Taken

Skipped Instruction

JAL Target

JAL PC + 4 Write Back

JALR Register Target

JALR Target bit[0] Clear

JALR PC + 4 Write Back
```

Single-Cycle v2 CPU-Level Regression Test 已在 ModelSim 中完成

---

## ModelSim 仿真

在项目根目录编译 RTL：

```tcl
vlog rtl/pc_reg.v
vlog rtl/instruction_memory.v
vlog rtl/regfile.v
vlog rtl/imm_gen.v
vlog rtl/main_decoder.v
vlog rtl/alu_decoder.v
vlog rtl/alu.v
vlog rtl/data_memory.v
vlog rtl/next_pc_logic.v
vlog rtl/rv32i_core.v
vlog tb/tb_rv32i_core.v
```

启动 CPU-Level Simulation：

```tcl
vsim -gui -voptargs=+acc work.tb_rv32i_core
```

加载波形：

```tcl
do sim/modelsim/cpu_wave.do
```

运行：

```tcl
run -all
```

---

## Waveform

`sim/modelsim/cpu_wave.do` 已按照功能划分主要观察信号

```text
Clock and Fetch

Instruction Fields

Main Control

Register File and ALU

Memory and Write Back

Next-PC Control
```

CPU-Level Test 主要通过波形观察：

```text
PC

Instruction

Control Signals

Register File Read Data

ALU Result

Memory Data

Write-Back Data

Branch Target

JALR Target

next_pc
```

---

## Version

Single-Cycle CPU 使用 Git Tag 保存稳定学习节点

```text
single-cycle-v1
```

代表第一版基础 Single-Cycle CPU

当前完成：

```text
Single-Cycle v2
```

Single-Cycle v2 在 v1 基础上加入：

```text
SLL
SLT
SRL
SRA

BNE
BLT
BGE

JAL
JALR
```

并完成统一 CPU-Level Regression Test

冻结后对应 Tag：

```text
single-cycle-v2
```

---

## 项目定位

这个项目的目的不是追求立即实现完整的 RV32I ISA

当前版本的主要目标已经完成：

```text
理解 Instruction 如何进入 CPU

理解 Decode 如何产生 Control

理解 Register File 如何提供 Operand

理解 ALU 如何完成 Execute

理解 Load / Store 如何访问 Memory

理解 Write Back 如何更新 Register File

理解 Branch / Jump 如何改变 PC

理解 State 与 Combinational Logic 的区别

理解 Single-Cycle Microarchitecture
```

因此 Single-Cycle v2 冻结后不再继续单纯堆叠更多 RV32I Instruction

后续重点转向 Processor Microarchitecture

---

## 后续学习路线

```text
Single-Cycle CPU
        ↓
Multi-Cycle CPU
        ↓
Pipeline CPU
        ↓
Data Hazard
        ↓
Forwarding
        ↓
Load-Use Hazard
        ↓
Stall
        ↓
Control Hazard
        ↓
Flush
        ↓
Memory Hierarchy
        ↓
Cache
        ↓
Bandwidth / Latency / Data Movement
        ↓
SIMD / Vector
        ↓
MAC / GEMM
        ↓
PE
        ↓
PE Array
        ↓
Systolic Array
        ↓
Dataflow
        ↓
On-Chip Buffer / Data Reuse / Tiling
        ↓
Quantization
        ↓
AI Processor / NPU Architecture
```

---

## 学习笔记

FPGA  数字电路  计算机组成  RISC-V 以及后续 AI Processor 学习笔记维护在独立仓库：

**HaibaraTaffy/FPGA_note**

CPU 实践相关笔记位于：

```text
计组/
└── 10 RISC-V/
    └── RV32I Mini Core/
```

当前代码仓库主要保存：

```text
RTL

Testbench

Test Program

Simulation Script
```

学习原理与课程笔记独立维护

---

## 一键提交

Windows 下可以使用：

```text
push_to_github.bat
```

进行 Commit 与 Push

也可以：

```bat
push_to_github.bat "commit message"
```

Single-Cycle v2 冻结完成后建立：

```bash
git tag single-cycle-v2
git push origin single-cycle-v2
```

从此 `single-cycle-v2` 作为当前 Single-Cycle Microarchitecture 的稳定参考版本
