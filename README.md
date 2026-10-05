# RV32I Mini Core

本仓库用于保存 RV32I Mini Core 不同 Microarchitecture 版本。

## Version

```text
v2_single_cycle
Single-Cycle v2 冻结版本

v3_five_stage_pipeline
Five-Stage Pipeline CPU 开发版本
```

## Directory

```text
RV32I_Mini_Core_v1/
├── v2_single_cycle/
│   ├── rtl/
│   ├── tb/
│   ├── programs/
│   ├── sim/
│   └── README.md
│
├── v3_five_stage_pipeline/
│   ├── rtl/
│   ├── tb/
│   ├── programs/
│   └── sim/
│
├── .gitignore
└── push_to_github.bat
```

## Usage

进入需要使用的版本目录后再运行 ModelSim 命令。

```powershell
cd v2_single_cycle
```

或者：

```powershell
cd v3_five_stage_pipeline
```

`v2_single_cycle` 保持为稳定 Reference。

新的 Pipeline RTL 与验证内容只在 `v3_five_stage_pipeline` 中开发。
