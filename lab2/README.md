# Control Unit for an 8-Bit Processor

**Name:** Prashansa Shrestha
**Roll No.:** 079BCT061

## Overview

## Supported Instructions

- **SWAP** – exchange two registers
- **Arithmetic/Logic** (via ALU with R0): ADD, SUB, INC, DEC, COMP, LSHIFT, RSHIFT, AND, OR, XOR, GETFLAG, SETFLAG
- **Memory**: MEM2REG, REG2MEM (16-bit address, sent as two bytes after the opcode)
- **Jumps**: JMP, JC, JNC, JZ, JNZ (also use a 16-bit address)
- **NOP**

Full opcode table is in the code comments / report.

## FSM States

| State | What it does |
|---|---|
| FETCH | Get instruction from memory, increment PC |
| DECODE | Figure out instruction type |
| FETCH_ADDR | Grab address bytes (memory/jump instructions only) |
| EXECUTE | Do the actual operation |
| STORE | Write result back to register/memory |

## Running the Simulation

```bash
iverilog -g2012 -o cpu_sim control_unit.sv register_bank.sv memory.sv alu.v 8bitadder.v shifter.v cu_tb.sv
vvp cpu_sim
gtkwave control_unit.vcd
```

## Verification

Tested with a SystemVerilog testbench in GTKWave — checked instruction fetch/decode, register swap, ALU ops, memory read/write, jumps, and correct FSM transitions.

## Conclusion

The control unit correctly fetches, decodes, and executes all supported instructions and generates the right control signals across states. Good hands-on practice with FSM design and processor control logic.