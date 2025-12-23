# Experiment 10 - Single Cycle Processor Comprehensive Application

## Overview
This implementation extends Experiment 9's single-cycle processor with:
1. **Peripheral I/O support** - Reading from 16-bit switches mapped to address 0x4000
2. **Variable shift instructions** - SLLV (shift left logical variable) and SRLV (shift right logical variable)
3. **Debug interface** - Already implemented in Experiment 9

## Key Changes

### 1. Top Module (top.v)
- Added `switch_value[15:0]` input port for 16-bit switch peripheral
- Added multiplexer to select between memory data and peripheral data:
  - Address range 0x0000-0x3FFF: Data memory
  - Address range 0x4000-0xFFFFFFFF: Peripheral space (0x4000 = switch input)

### 2. ALU Module (alu.v)
- Extended `op` control signal from 3-bit to 4-bit
- Added two new operations:
  - `4'b1000`: SLLV - Shift left logical variable (b << a[4:0])
  - `4'b1001`: SRLV - Shift right logical variable (b >> a[4:0])

### 3. ALU Decoder (aludec.v)
- Extended `alucontrol` output from 3-bit to 4-bit
- Added decoding for new instructions:
  - funct `6'b000100`: SLLV
  - funct `6'b000110`: SRLV

### 4. Controller and Datapath
- Updated `alucontrol` signal width from 3-bit to 4-bit throughout all modules

## Instruction Set

### Supported Instructions
- **R-Type**: add, sub, and, or, slt, sllv, srlv
- **I-Type**: lw, sw, addi, beq
- **J-Type**: j

### New Instructions

#### SLLV (Shift Left Logical Variable)
```assembly
sllv $rd, $rt, $rs
```
- Opcode: 000000 (R-Type)
- Funct: 000100
- Operation: $rd = $rt << $rs[4:0]

#### SRLV (Shift Right Logical Variable)
```assembly
srlv $rd, $rt, $rs
```
- Opcode: 000000 (R-Type)
- Funct: 000110
- Operation: $rd = $rt >> $rs[4:0]

## Memory Map

| Address Range | Description |
|--------------|-------------|
| 0x0000-0x3FFF | Data Memory (16KB) |
| 0x4000 | Switch Input Peripheral (16-bit) |
| 0x4001-0xFFFFFFFF | Reserved for future peripherals |

## Test Programs

### 1. Simple Switch Test (test_switch.asm)
Continuously reads switch value and stores in $1 register:
```assembly
loop:
    lw $1, 0x4000($0)    # Read switch value
    j loop               # Infinite loop
```

### 2. Shift Instruction Test (test_shifts.asm)
Tests the SLLV and SRLV instructions with known values.

### 3. Calculator Program (calculator.asm)
Implements a simple calculator using the switch input:
- **Bits [15:14]**: Operation selector
  - 00: Addition
  - 01: Subtraction
  - 10: Multiplication (using repeated addition)
  - 11: Division (using repeated subtraction)
- **Bits [13:7]**: Operand A (7 bits)
- **Bits [6:0]**: Operand B (7 bits)
- **Results**: Stored in $4 and $8 for easy debugging

## Debug Interface

### Register File Debug Port
- **Input**: `ra_dbg[4:0]` - Connected to 5 buttons/switches
- **Output**: `rd_dbg[31:0]` - Connected to 7-segment display (shows lower 16 bits)

Use the debug switches to select which register (0-31) to display on the 7-segment display.

## Board Implementation Notes

### Pin Connections (for Basys3)
- **sw_dbg[4:0]**: 5 buttons for register selection
- **switch_value[15:0]**: 16 DIP switches for peripheral input
- **seg[6:0]**: 7-segment display segments
- **ans[3:0]**: 7-segment display digit select

### Verification Steps
1. Load the simple switch test program
2. Toggle switches and verify the value appears in $1 register
3. Use debug buttons to select register $1
4. Verify the 7-segment display shows the switch values

5. Load the calculator program
6. Set switches to test different operations:
   - Example: Set bits [15:14]=00, [13:7]=5, [6:0]=3 for 5+3
   - Use debug buttons to view $4 and $8 (should show result 8)

## Converting Assembly to COE Files

To use these assembly programs in the processor:
1. Assemble the code in MARS simulator
2. Export machine code as hexadecimal
3. Create a COE file with the format:
```
memory_initialization_radix=16;
memory_initialization_vector=
<instruction_hex_1>,
<instruction_hex_2>,
...
<instruction_hex_n>;
```
4. Use the COE file to initialize the instruction memory IP core

## Implementation Checklist
- [x] Modified top.v for peripheral I/O support
- [x] Extended ALU to support SLLV and SRLV
- [x] Updated ALU decoder for new instructions
- [x] Extended alucontrol signal width to 4-bit
- [x] Created test programs (switch test, shift test, calculator)
- [x] Register debug interface (already implemented in Experiment 9)

## Notes
- The shift amount is limited to 5 bits (0-31 positions) as per MIPS specification
- Multiplication and division in the calculator use software implementation (repeated add/sub)
- For better performance, hardware multiplier/divider could be added in future experiments
