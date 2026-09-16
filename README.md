# RV32I Mini Core v1

这是我的第一颗 RISC-V 处理器核心：一个使用 Verilog 从零搭建的简化版 RV32I
单周期 CPU。项目以学习处理器数据通路、控制器设计和模块级验证为主要目标。

> 当前状态：第一版完整数据通路已经搭建完成，并已在 ModelSim 中完成模块级测试和
> 顶层联调。现在它还不是完整的 RV32I 实现，后续会继续补充指令、验证覆盖率和工程化支持。

## 当前进度

- [x] PC 寄存器
- [x] Next-PC Logic（`PC + 4` 与条件分支）
- [x] ALU：ADD、SUB、AND、OR、XOR
- [x] 32 × 32 位寄存器堆，保持 `x0 = 0`
- [x] I / S / B 型立即数生成
- [x] Main Decoder
- [x] ALU Decoder
- [x] Instruction Memory
- [x] Data Memory
- [x] 单周期顶层数据通路集成
- [x] 各基础模块 Testbench
- [x] Mini Core 顶层冒烟仿真
- [ ] 扩充到更完整的 RV32I 指令子集
- [ ] 为顶层测试加入自动结果检查
- [ ] 增加汇编程序与回归测试
- [ ] FPGA 上板验证

## 当前支持的指令

| 类型 | 指令 | 用途 |
| --- | --- | --- |
| R-type | `ADD`、`SUB`、`AND`、`OR`、`XOR` | 寄存器算术与逻辑运算 |
| I-type | `ADDI` | 立即数加法 |
| Load | `LW` | 从 Data Memory 读取并写回寄存器 |
| Store | `SW` | 将寄存器数据写入 Data Memory |
| Branch | `BEQ` | 相等时进行 PC 相对跳转 |

当前顶层测试程序 `programs/imem_test.hex` 已用于验证 `ADDI`、`ADD` 和 `SUB`
在完整数据通路中的执行过程；其他功能目前主要通过对应模块的 Testbench 验证。

## 数据通路

```text
                         ┌───────────────┐
                   ┌────▶│  Main Decoder │──── Control Signals
                   │     └───────────────┘
                   │
PC ─▶ Instruction Memory ─▶ Register File ─▶ ALU ─▶ Data Memory
│                  │              ▲          │             │
│                  ├─▶ ImmGen ─────┘          └──────┬──────┘
│                  └─▶ ALU Decoder                  │
│                                                   ▼
└──── Next-PC Logic ◀──── Branch / Zero       Write-Back MUX
```

完整连接关系位于 [`rtl/rv32i_core.v`](rtl/rv32i_core.v)。

## 项目结构

```text
RV32I_Mini_Core_v1/
├── rtl/                       # 可综合 Verilog RTL
│   ├── rv32i_core.v           # Mini Core 顶层
│   ├── pc_reg.v               # 程序计数器
│   ├── next_pc_logic.v        # 下一条 PC 选择逻辑
│   ├── instruction_memory.v   # 指令存储器
│   ├── data_memory.v          # 数据存储器
│   ├── regfile.v              # 通用寄存器堆
│   ├── imm_gen.v              # 立即数生成器
│   ├── main_decoder.v         # 主译码器
│   ├── alu_decoder.v          # ALU 译码器
│   └── alu.v                  # 算术逻辑单元
├── tb/                        # 模块级与顶层 Testbench
├── programs/
│   └── imem_test.hex          # 顶层仿真测试程序
├── sim/modelsim/              # ModelSim 仿真目录
├── notes/                     # 项目早期设计草稿
└── push_to_github.bat         # 一键提交并推送脚本
```

## 仿真

项目当前使用 ModelSim 进行仿真。以顶层联调为例，可将 `rtl/` 下的所有模块和
`tb/tb_rv32i_core.v` 加入工程，以 `tb_rv32i_core` 作为仿真顶层。

当前测试程序对应以下指令：

```asm
addi x1, x0, 5
addi x2, x0, 7
add  x3, x1, x2
sub  x4, x1, x2
```

预期结果：`x1 = 5`、`x2 = 7`、`x3 = 12`、`x4 = 0xFFFF_FFFE`。

## 学习笔记

详细的 FPGA、Verilog 与 RV32I 学习笔记已经迁移到独立仓库维护：

**[HaibaraTaffy/FPGA_note](https://github.com/HaibaraTaffy/FPGA_note/tree/main)**

本仓库专注于可运行的 RTL、Testbench 和测试程序；笔记仓库用于记录原理、设计过程、
波形分析以及学习中遇到的问题。

## 一键提交并推送

在 Windows 下双击 `push_to_github.bat`，输入本次提交说明并回车，脚本会自动执行：

1. `git add -A`
2. 有改动时创建 commit
3. 将 `main` 分支推送到 GitHub

也可以在终端中直接传入提交说明：

```bat
push_to_github.bat "补充 BEQ 顶层测试"
```

## 下一步

1. 把顶层 Testbench 改为自检式测试，自动判断寄存器与存储器结果。
2. 为 `LW`、`SW`、`BEQ` 增加完整数据通路测试程序。
3. 继续实现 RV32I 中的比较、移位、跳转和更多分支指令。
4. 加入非法指令处理与更明确的复位行为。
