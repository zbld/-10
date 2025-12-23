# 实验10 快速开始指南 / Experiment 10 Quick Start Guide

## 中文版 (Chinese Version)

### 已完成的工作
1. ✅ 修改 top.v 添加 16 位拨码开关输入
2. ✅ 实现外设地址映射 (0x4000 = 拨码开关)
3. ✅ 添加 SLLV 和 SRLV 移位指令
4. ✅ 扩展 ALU 控制信号到 4 位
5. ✅ 创建测试程序和 COE 文件
6. ✅ 更新仿真测试平台

### 如何使用

#### 步骤 1: 查看文档
- **实验10说明.md** - 中文详细说明（包含示例）
- **EXPERIMENT10_README.md** - 英文详细说明
- **CHANGES_SUMMARY.txt** - 所有修改的详细清单

#### 步骤 2: 选择测试程序
在 `/tmp/experiment10/` 目录下有三个测试程序：
- `test_switch.asm` - 简单拨码开关测试
- `test_shifts.asm` - 移位指令测试  
- `calculator.asm` - 完整计算器程序

对应的 COE 文件：
- `test_switch.coe`
- `test_shifts.coe`

#### 步骤 3: 在 MARS 中编译计算器程序
1. 在 MARS 中打开 `calculator.asm`
2. 点击 Assemble
3. 使用 Tools → Dump Memory 导出机器码
4. 转换为 COE 格式

#### 步骤 4: 在 Vivado 中更新指令存储器
1. 打开 Vivado 项目
2. 找到 imem IP 核
3. 更新 COE 文件
4. 重新生成

#### 步骤 5: 综合和实现
1. Run Synthesis
2. Run Implementation  
3. Generate Bitstream

#### 步骤 6: 上板测试
1. 连接 Basys3 开发板
2. Program Device
3. 测试拨码开关和计算器功能

### 计算器使用示例

拨码开关编码：`[15:14]=操作, [13:7]=A, [6:0]=B`

| 操作 | 开关[15:14] | 示例 | 拨码开关值 | 结果 |
|------|-------------|------|------------|------|
| 5+3  | 00 (加法)   | A=5, B=3 | 0x00A3 | 8 |
| 10-4 | 01 (减法)   | A=10, B=4 | 0x4284 | 6 |
| 6×7  | 10 (乘法)   | A=6, B=7 | 0x8307 | 42 |
| 20÷4 | 11 (除法)   | A=20, B=4 | 0xCA04 | 5 |

查看结果：使用按钮选择寄存器 $4 或 $8，在七段数码管上显示。

---

## English Version

### Completed Work
1. ✅ Modified top.v to add 16-bit switch input
2. ✅ Implemented peripheral address mapping (0x4000 = switches)
3. ✅ Added SLLV and SRLV shift instructions
4. ✅ Extended ALU control signal to 4 bits
5. ✅ Created test programs and COE files
6. ✅ Updated simulation testbench

### How to Use

#### Step 1: Review Documentation
- **实验10说明.md** - Detailed Chinese documentation with examples
- **EXPERIMENT10_README.md** - Detailed English documentation
- **CHANGES_SUMMARY.txt** - Detailed list of all changes

#### Step 2: Choose Test Program
Three test programs available in `/tmp/experiment10/`:
- `test_switch.asm` - Simple switch reading test
- `test_shifts.asm` - Shift instruction test
- `calculator.asm` - Full calculator implementation

Corresponding COE files:
- `test_switch.coe`
- `test_shifts.coe`

#### Step 3: Compile Calculator in MARS
1. Open `calculator.asm` in MARS
2. Click Assemble
3. Use Tools → Dump Memory to export machine code
4. Convert to COE format

#### Step 4: Update Instruction Memory in Vivado
1. Open Vivado project
2. Locate imem IP core
3. Update COE file
4. Regenerate

#### Step 5: Synthesize and Implement
1. Run Synthesis
2. Run Implementation
3. Generate Bitstream

#### Step 6: Test on Board
1. Connect Basys3 board
2. Program Device
3. Test switch and calculator functionality

### Calculator Usage Examples

Switch encoding: `[15:14]=operation, [13:7]=A, [6:0]=B`

| Operation | Switches[15:14] | Example | Switch Value | Result |
|-----------|-----------------|---------|--------------|--------|
| 5+3       | 00 (add)        | A=5, B=3 | 0x00A3 | 8 |
| 10-4      | 01 (sub)        | A=10, B=4 | 0x4284 | 6 |
| 6×7       | 10 (mul)        | A=6, B=7 | 0x8307 | 42 |
| 20÷4      | 11 (div)        | A=20, B=4 | 0xCA04 | 5 |

View result: Use buttons to select register $4 or $8, displayed on 7-segment display.

---

## 文件结构 / File Structure

```
/home/runner/work/-10/-10/
├── sy10git.srcs/sources_1/new/
│   ├── top.v              ← Modified: Added switch input & peripheral I/O
│   ├── alu.v              ← Modified: Added SLLV/SRLV operations
│   ├── aludec.v           ← Modified: Added instruction decoding
│   ├── controller.v       ← Modified: Extended alucontrol to 4-bit
│   ├── datapath.v         ← Modified: Extended alucontrol to 4-bit
│   ├── mips.v             ← Modified: Extended alucontrol to 4-bit
│   └── ... (other files)
├── sy10git.srcs/sim_1/new/
│   └── testbench.v        ← Modified: Added new ports
├── EXPERIMENT10_README.md     ← English documentation
├── 实验10说明.md              ← Chinese documentation
├── IMPLEMENTATION_SUMMARY.md  ← Implementation summary
├── CHANGES_SUMMARY.txt        ← Detailed changes list
└── /tmp/experiment10/
    ├── test_switch.asm    ← Assembly: Switch test
    ├── test_shifts.asm    ← Assembly: Shift test
    ├── calculator.asm     ← Assembly: Calculator
    ├── test_switch.coe    ← COE: Switch test
    └── test_shifts.coe    ← COE: Shift test
```

---

## 新增指令 / New Instructions

### SLLV - 变量逻辑左移 / Shift Left Logical Variable
```assembly
sllv $rd, $rt, $rs    # $rd = $rt << $rs[4:0]
```

### SRLV - 变量逻辑右移 / Shift Right Logical Variable
```assembly
srlv $rd, $rt, $rs    # $rd = $rt >> $rs[4:0]
```

---

## 支持 / Support

如有问题，请查看详细文档：
- 中文：实验10说明.md
- English: EXPERIMENT10_README.md

For questions, please refer to detailed documentation:
- Chinese: 实验10说明.md
- English: EXPERIMENT10_README.md
