# 8-Bit FSM-Controlled Processor

**Name:** Prashansa Shrestha  
**Roll No.:** 079BCT061  

**Name:** Prajwal Kandel  
**Roll No.:** 079BCT060  

**Name:** Sunit Kumar Shrestha  
**Roll No.:** 079BCT088  

---

## Overview

This directory contains the implementation of a complete cycle-accurate **8-Bit Processor** constructed by integrating the custom Verilog/SystemVerilog modules designed in **Lab 2** (Control Unit, Register Bank, ALU, shifter, and adders) with a shared tri-state data bus and memory.

The processor architecture is **accumulator-based** for arithmetic and logic operations, allowing compact 1-byte instruction encodings for register-register calculations. It operates on a 16-bit address bus and an 8-bit bidirectional data bus.

---

## Architectural Components

1. **Control Unit ([control_unit.sv](file:///home/sunit/Documents/Code/fpga-assignments/processor/control_unit.sv)):** 
   - Uses a microcoded Finite State Machine (FSM) to cycle through the standard CPU execution phases.
   - Coordinates the memory enable, register writeback source, program counter, and ALU opcodes.
   - Restores and snapshot-evaluates the ALU flags for conditional jumps.
2. **Register Bank ([register_bank.sv](file:///home/sunit/Documents/Code/fpga-assignments/processor/register_bank.sv)):**
   - Implements 8 general-purpose registers ($R0$ to $R7$).
   - $R0$ functions as the accumulator.
   - Supports parallel operand reads on `alu_out[0]` and `alu_out[1]`, single-register writes, and single-cycle register swapping.
3. **ALU ([alu.v](file:///home/sunit/Documents/Code/fpga-assignments/processor/alu.v)):**
   - Combinational logic block executing addition, subtraction, shifting, logic operations, flag snapshot retrieval, and flag settings.
   - Tracks a 3-bit flag register `{Zero, Carry, Parity}`.
4. **Memory ([memory.sv](file:///home/sunit/Documents/Code/fpga-assignments/processor/memory.sv)):**
   - 64KB synchronous RAM module.
   - Utilizes high-impedance state (`'z`) configuration to safely release the shared bidirectional data bus when read operations are inactive.
5. **Top-Level CPU ([processor.sv](file:///home/sunit/Documents/Code/fpga-assignments/processor/processor.sv)):**
   - Structural module wiring the Control Unit, Register Bank, and ALU together.

---

## Instruction Set Architecture (ISA)

The processor supports variable-length instructions (1 to 3 bytes) depending on memory operands.

| Instruction Category | Opcode Byte Format (Binary) | Description | Bytes |
| :--- | :--- | :--- | :--- |
| **NOP** | `00_000_000` (`8'h00`) | No operation (internally executes `SWAP R0, R0`) | 1 |
| **SWAP R_x, R_y** | `00_xxx_yyy` | Exchanges contents of register $R_x$ and $R_y$ | 1 |
| **MEM2REG (Load)** | `010_1_0000` (`8'h50`) followed by `[Addr_Low, Addr_High]` | Loads value from 16-bit memory address into $R0$ (Accumulator) | 3 |
| **REG2MEM (Store)** | `010_0_0000` (`8'h40`) followed by `[Addr_Low, Addr_High]` | Stores value from $R0$ (Accumulator) to 16-bit memory address | 3 |
| **JMP (Unconditional)** | `011_000_00` (`8'h60`) followed by `[Addr_Low, Addr_High]` | Unconditional jump to 16-bit target address | 3 |
| **JC (Jump Carry)** | `011_001_00` (`8'h64`) followed by `[Addr_Low, Addr_High]` | Jump if Carry Flag is set | 3 |
| **JNC (Jump No Carry)** | `011_010_00` (`8'h68`) followed by `[Addr_Low, Addr_High]` | Jump if Carry Flag is clear | 3 |
| **JZ (Jump Zero)** | `011_011_00` (`8'h6c`) followed by `[Addr_Low, Addr_High]` | Jump if Zero Flag is set | 3 |
| **JNZ (Jump No Zero)** | `011_100_00` (`8'h70`) followed by `[Addr_Low, Addr_High]` | Jump if Zero Flag is clear | 3 |
| **ARITH (ALU Ops)** | `1_oooo_rrr` | $R0 \leftarrow R0 \text{ op } R_r$ (where `oooo` specifies ALU opcode) | 1 |

### ALU Opcodes (`oooo` field)
- `0001` : **ADD** ($R0 \leftarrow R0 + R_r$)
- `0010` : **SUB** ($R0 \leftarrow R0 - R_r$)
- `0011` : **INC** ($R0 \leftarrow R0 + 1$)
- `0100` : **DEC** ($R0 \leftarrow R0 - 1$)
- `0101` : **COMP** ($R0 \leftarrow \sim R0$)
- `0110` : **LSHIFT** ($R0 \leftarrow R0 \ll R_r[2:0]$)
- `0111` : **RSHIFT** ($R0 \leftarrow R0 \gg R_r[2:0]$)
- `1000` : **GETFLAG** (loads `{5'b0, Zero, Carry, Parity}` flags into $R0$)
- `1001` : **SETFLAG** (sets ALU flags from $R0[2:0]$)
- `1010` : **AND** ($R0 \leftarrow R0 \ \& \ R_r$)
- `1011` : **OR** ($R0 \leftarrow R0 \ \| \ R_r$)
- `1100` : **XOR** ($R0 \leftarrow R0 \ \wedge \ R_r$)

---

## FSM States

The Control Unit transitions through 5 major states to orchestrate data movement:

1. **FETCH:** Reads the opcode byte from memory at the current PC address, and increments the PC.
2. **DECODE:** Latch the instruction opcode, decode the operation type, and configure the next state.
3. **FETCH_ADDR:** For 3-byte instructions, sequentially fetches the lower and upper address bytes from memory.
4. **EXECUTE:** Triggers register bank swaps, initiates register-to-ALU operand feeding, or updates the PC for jump instructions.
5. **STORE:** Controls register bank write-enables, selects the target writeback source (ALU vs. Memory bus), and writes the result.

---

## Running the Simulation

Ensure you have [Icarus Verilog](http://iverilog.icarus.com/) and [GTKWave](http://gtkwave.sourceforge.net/) installed.

```bash
# Compile the processor and testbench
iverilog -g2012 -o processor_sim alu.v bit8_units.v control_unit.sv eight_bit_adder.v four_bit_adder.v full_adder.v half_adder.v memory.sv register_bank.sv shifter.v processor.sv processor_tb.sv

# Run the simulation
vvp processor_sim

# View the waveform simulation
gtkwave processor.vcd
```

---

## Verification

The testbench [processor_tb.sv](file:///home/sunit/Documents/Code/fpga-assignments/processor/processor_tb.sv) runs a test program validating the interaction of all modules:
1. **Load** data `10` (from memory address `0x0050`) into $R0$.
2. **Swap** $R0$ and $R1$ (leaves `10` in $R1$).
3. **Load** data `5` (from memory address `0x0051`) into $R0$.
4. **Swap** $R0$ and $R2$ (leaves `5` in $R2$).
5. **Swap** $R0$ and $R1$ (restores `10` to $R0$).
6. **Add** $R2$ to $R0$ (result `15` is stored in $R0$).
7. **Store** the addition result `15` from $R0$ into memory address `0x0052`.
8. **Get Flags** into $R0$ via `GETFLAG`. The even parity of `15` sets the Parity flag, yielding flag byte `8'h01` (Parity=1, Carry=0, Zero=0).
9. **Conditional Jump (JNZ)** to memory address `0x0015` if the Zero flag is clear. Since the Zero flag is `0`, the jump is successfully taken.
10. The instruction `SWAP R0, R3` (at `0x0011`) is skipped, leaving $R3$ at value `0`.
11. **Store** the flag register value `8'h01` from $R0$ into memory address `0x0053`.

### Simulation Output
```text
VCD info: dumpfile processor.vcd opened for output.
==================================================
Simulation finished. Final State Check:
Memory [0x0052] (Addition Result)  =  15 (Expected: 15)
Memory [0x0053] (Flags Saved)      = 00000001 (Expected: 00000001 - Parity=1, Carry=0, Zero=0)
Register R0 (Final Flags)           =   1 (Expected: 1)
Register R1                         =   0 (Expected: 0)
Register R2                         =   5 (Expected: 5)
Register R3 (Should be skipped)     =   0 (Expected: 0)
==================================================
TEST PASSED successfully!
```
All assertions in the testbench succeeded, verifying full structural and behavioral correctness.
