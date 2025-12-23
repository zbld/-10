# Experiment 10 Implementation Summary

## Completed Tasks

All required modifications for Experiment 10 have been successfully implemented:

### ✅ 1. Peripheral I/O Support (外设输入输出支持)

**Modified Files:**
- `sy10git.srcs/sources_1/new/top.v`

**Changes:**
- Added `switch_value[15:0]` input port for 16-bit DIP switches
- Implemented memory-mapped I/O with multiplexer:
  - Address 0x0000-0x3FFF: Data memory access
  - Address 0x4000-0xFFFFFFFF: Peripheral space (0x4000 = switch input)
- Added `readdata_mem` wire to separate memory data from peripheral data
- Multiplexer logic: `readdata = (dataadr[14] == 1'b0) ? readdata_mem : {16'b0, switch_value}`

### ✅ 2. Register File Debug Interface (寄存器堆调试接口)

**Status:** Already implemented in Experiment 9

**Features:**
- Debug read port with `ra_dbg[4:0]` address input (connected to buttons)
- Debug data output `rd_dbg[31:0]` (connected to 7-segment display)
- Allows runtime inspection of any of the 32 registers

### ✅ 3. Variable Shift Instructions (左移、右移指令)

**Modified Files:**
- `sy10git.srcs/sources_1/new/alu.v`
- `sy10git.srcs/sources_1/new/aludec.v`
- `sy10git.srcs/sources_1/new/controller.v`
- `sy10git.srcs/sources_1/new/datapath.v`
- `sy10git.srcs/sources_1/new/mips.v`

**New Instructions:**
1. **SLLV** (Shift Left Logical Variable)
   - Funct code: `6'b000100`
   - ALU control: `4'b1000`
   - Operation: `$rd = $rt << $rs[4:0]`

2. **SRLV** (Shift Right Logical Variable)
   - Funct code: `6'b000110`
   - ALU control: `4'b1001`
   - Operation: `$rd = $rt >> $rs[4:0]`

**Technical Details:**
- Extended `alucontrol` signal from 3-bit to 4-bit throughout the design
- ALU now supports 10 operations (including the 2 new shift operations)
- Backward compatible with all existing instructions

### ✅ 4. Test Programs and Documentation

**Created Assembly Programs:**
1. `test_switch.asm` - Simple switch reading test
2. `test_shifts.asm` - SLLV/SRLV instruction verification
3. `calculator.asm` - Full calculator implementation

**Created COE Files:**
1. `test_switch.coe` - Machine code for switch test
2. `test_shifts.coe` - Machine code for shift test

**Created Documentation:**
1. `EXPERIMENT10_README.md` - Complete English documentation
2. `实验10说明.md` - Complete Chinese documentation with examples

### ✅ 5. Updated Testbench

**Modified Files:**
- `sy10git.srcs/sim_1/new/testbench.v`

**Changes:**
- Added `sw_dbg[4:0]` register for debug register selection
- Added `switch_value[15:0]` register for peripheral input simulation
- Added `ans[3:0]` and `seg[6:0]` outputs for 7-segment display
- Updated port connections to match new top module interface

## Calculator Implementation Details

The calculator program reads from address 0x4000 (switch peripheral):

**Input Format:**
```
Bits [15:14]: Operation selector
  00 = Addition
  01 = Subtraction  
  10 = Multiplication (via repeated addition)
  11 = Division (via repeated subtraction)
  
Bits [13:7]: Operand A (7-bit unsigned, 0-127)
Bits [6:0]: Operand B (7-bit unsigned, 0-127)
```

**Output:**
- Result stored in registers `$4` and `$8`
- Can be viewed on 7-segment display using debug buttons

**Example Usage:**
- To calculate 5 + 3:
  - Set switches to 0x00A3 (00_0000101_0000011)
  - Select register $4 or $8 with debug buttons
  - Display shows 8

## Hardware Verification Steps

1. **Load COE file** into instruction memory (imem) IP core
2. **Synthesize and implement** the design in Vivado
3. **Generate bitstream** and program Basys3 board
4. **Test switch reading:**
   - Load `test_switch.coe`
   - Toggle switches
   - Select register $1 with buttons
   - Verify value on 7-segment display
5. **Test calculator:**
   - Load calculator program COE
   - Set switches for different operations
   - Verify results in $4 and $8

## Modified Code Statistics

- **6 Verilog files modified** (top.v, alu.v, aludec.v, controller.v, datapath.v, mips.v)
- **1 testbench updated** (testbench.v)
- **3 assembly programs created**
- **2 COE files generated**
- **2 documentation files created**

## Key Features

✓ Memory-mapped I/O for peripheral access
✓ 16-bit switch input support  
✓ Variable shift operations (SLLV/SRLV)
✓ Extended ALU with 4-bit control signal
✓ Register debug interface (from Exp 9)
✓ Calculator with add/sub/mul/div operations
✓ Comprehensive documentation in English and Chinese
✓ Test programs and COE files ready for FPGA deployment

## Next Steps for Student

1. Review the documentation files for detailed implementation
2. Use MARS simulator to modify or create new assembly programs
3. Generate COE files from MARS machine code output
4. Load COE files into Vivado instruction memory IP
5. Synthesize, implement, and test on Basys3 board
6. Verify all operations work correctly on hardware
7. Document results in lab report

## Files to Review

- `/EXPERIMENT10_README.md` - English documentation
- `/实验10说明.md` - Chinese documentation with examples
- Source files in `sy10git.srcs/sources_1/new/`
- Assembly programs in `/tmp/experiment10/` (for reference)

All requirements from the problem statement have been successfully implemented!
