# 01 PC 与 Next-PC Logic

## 功能目标

> TODO：描述 PC 寄存器、顺序执行、分支和跳转时的更新规则。

## 接口设计

> TODO：记录输入、输出、位宽和复位值。

## Next-PC 选择

```text
顺序执行：next_pc = pc + 4
分支跳转：next_pc = branch_target
JAL：     next_pc = jal_target
JALR：    next_pc = jalr_target
```

## 验证要点

- [ ] 复位后 PC 等于约定的起始地址
- [ ] 正常执行时每周期加 4
- [ ] 分支成立与不成立
- [ ] JAL 与 JALR 目标地址
- [ ] JALR 结果最低位清零

