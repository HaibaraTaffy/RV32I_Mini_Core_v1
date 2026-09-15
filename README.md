# RV32I Mini Core Learning

我的第一颗 RISC-V RV32I 处理器核心。

## 目录结构

```text
rv32i-mini-core-learning/
├── README.md
├── notes/
│   └── 00 RV32I Mini Core/
│       ├── 总体设计.md
│       └── 01 PC与Next-PC Logic.md
├── rtl/
│   ├── pc_reg.v
│   ├── alu.v
│   ├── regfile.v
│   ├── imm_gen.v
│   └── control.v
├── tb/
│   ├── tb_pc_reg.v
│   ├── tb_alu.v
│   └── tb_regfile.v
├── sim/
│   └── modelsim/
└── push_to_github.bat
```

## 一键提交并推送

双击 `push_to_github.bat`，输入本次提交说明并回车。脚本会依次执行：

1. 暂存当前项目的全部改动；
2. 有改动时创建 Git commit；
3. 推送 `main` 分支到 GitHub。

首次推送时，Git/Git Credential Manager 可能会要求登录 GitHub。GitHub 的 HTTPS
认证需要使用浏览器登录或 Personal Access Token，不能使用账户密码。

也可以在终端中直接传入提交说明：

```bat
push_to_github.bat "完成取指模块"
```

## 计划

- [ ] 明确 RV32I 单周期或多周期微架构
- [ ] 程序计数器与取指单元
- [ ] 指令译码与立即数生成
- [ ] 寄存器堆
- [ ] ALU
- [ ] Load/Store 单元
- [ ] 分支与跳转
- [ ] 控制与状态处理
- [ ] 指令级 Testbench 与回归测试
