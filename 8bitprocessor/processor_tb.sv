// =============================================================
// Testbench for the 8-bit Processor
// Loads a test program into memory, resets the processor, and
// runs the simulation. Verifies ALU operations, register swaps,
// memory read/writes, and conditional jumps.
// =============================================================
`timescale 1ns / 1ps

module processor_tb;

  localparam AD_LINES = 16;
  localparam DATA_LINES = 8;

  logic clk;
  logic reset;
  wire [AD_LINES - 1 : 0] addr_bus;
  wire [DATA_LINES - 1 : 0] data_bus;
  logic mem_cs;
  logic mem_rd_wr_bar;

  // Clock generation: 10ns period (100MHz)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Instantiate Processor
  processor #(
      .AD_LINES(AD_LINES),
      .DATA_LINES(DATA_LINES)
  ) cpu (
      .clk(clk),
      .reset(reset),
      .addr_bus(addr_bus),
      .data_bus(data_bus),
      .mem_cs(mem_cs),
      .mem_rd_wr_bar(mem_rd_wr_bar)
  );

  // Instantiate Memory
  memory #(
      .AD_LINES(AD_LINES),
      .DATA_LINES(DATA_LINES)
  ) mem_inst (
      .clk(clk),
      .cs(mem_cs),
      .rd_wr_bar(mem_rd_wr_bar),
      .addr_bus(addr_bus),
      .data_bus(data_bus)
  );

  initial begin
    // Setup waveform dump
    $dumpfile("processor.vcd");
    $dumpvars(0, processor_tb);

    // Initialize Memory Array
    for (int i = 0; i < (1 << AD_LINES); i++) begin
      mem_inst.mem[i] = 8'h00;
    end

    // Initialize Register Bank Registers to 0
    for (int i = 0; i < 8; i++) begin
      cpu.reg_bank_inst.register[i] = 8'h00;
    end

    // ==========================================
    // Program Code:
    // ==========================================
    
    // Address 0x0000: MEM2REG (load from 0x0050 into R0)
    // Bytes: 0x50, 0x50, 0x00
    mem_inst.mem[16'h0000] = 8'h50;
    mem_inst.mem[16'h0001] = 8'h50;
    mem_inst.mem[16'h0002] = 8'h00;

    // Address 0x0003: SWAP R0, R1
    // Byte: 0x01 (00_000_001)
    mem_inst.mem[16'h0003] = 8'h01;

    // Address 0x0004: MEM2REG (load from 0x0051 into R0)
    // Bytes: 0x50, 0x51, 0x00
    mem_inst.mem[16'h0004] = 8'h50;
    mem_inst.mem[16'h0005] = 8'h51;
    mem_inst.mem[16'h0006] = 8'h00;

    // Address 0x0007: SWAP R0, R2
    // Byte: 0x02 (00_000_010)
    mem_inst.mem[16'h0007] = 8'h02;

    // Address 0x0008: SWAP R0, R1 (restore 0x0A to R0, leaving R1 = 0)
    // Byte: 0x01 (00_000_001)
    mem_inst.mem[16'h0008] = 8'h01;

    // Address 0x0009: ADD R2 (R0 <= R0 + R2 = 10 + 5 = 15)
    // Byte: 0x8a (1_0001_010)
    mem_inst.mem[16'h0009] = 8'h8a;

    // Address 0x000A: REG2MEM (store R0 to 0x0052)
    // Bytes: 0x40, 0x52, 0x00
    mem_inst.mem[16'h000A] = 8'h40;
    mem_inst.mem[16'h000B] = 8'h52;
    mem_inst.mem[16'h000C] = 8'h00;

    // Address 0x000D: GETFLAG (load flags {Zero, Carry, Parity} into R0)
    // Byte: 0xc0 (1_1000_000)
    mem_inst.mem[16'h000D] = 8'hc0;

    // Address 0x000E: JNZ to 0x0015 (Zero flag is clear, so jump is taken)
    // Bytes: 0x70, 0x15, 0x00
    mem_inst.mem[16'h000E] = 8'h70;
    mem_inst.mem[16'h000F] = 8'h15;
    mem_inst.mem[16'h0010] = 8'h00;

    // Address 0x0011: SWAP R0, R3 (This instruction should be skipped!)
    // Byte: 0x03 (00_000_011)
    mem_inst.mem[16'h0011] = 8'h03;

    // Address 0x0012: JMP to 0x0018 (Unconditional skip if jump fails)
    // Bytes: 0x60, 0x18, 0x00
    mem_inst.mem[16'h0012] = 8'h60;
    mem_inst.mem[16'h0013] = 8'h18;
    mem_inst.mem[16'h0014] = 8'h00;

    // Address 0x0015: REG2MEM (store R0 to 0x0053)
    // Bytes: 0x40, 0x53, 0x00
    mem_inst.mem[16'h0015] = 8'h40;
    mem_inst.mem[16'h0016] = 8'h53;
    mem_inst.mem[16'h0017] = 8'h00;

    // Address 0x0018: NOP
    mem_inst.mem[16'h0018] = 8'h00;

    // Address 0x0019: NOP
    mem_inst.mem[16'h0019] = 8'h00;

    // ==========================================
    // Program Data:
    // ==========================================
    mem_inst.mem[16'h0050] = 8'h0A; // Operand 1: 10
    mem_inst.mem[16'h0051] = 8'h05; // Operand 2: 5

    // ==========================================
    // Execution
    // ==========================================
    reset = 1;
    #20;
    reset = 0;

    // Let simulation run for enough clock cycles to finish execution
    #800;

    // Display final values
    $display("==================================================");
    $display("Simulation finished. Final State Check:");
    $display("Memory [0x0052] (Addition Result)  = %d (Expected: 15)", mem_inst.mem[16'h0052]);
    $display("Memory [0x0053] (Flags Saved)      = %b (Expected: 00000001 - Parity=1, Carry=0, Zero=0)", mem_inst.mem[16'h0053]);
    $display("Register R0 (Final Flags)           = %d (Expected: 1)", cpu.reg_bank_inst.register[0]);
    $display("Register R1                         = %d (Expected: 0)", cpu.reg_bank_inst.register[1]);
    $display("Register R2                         = %d (Expected: 5)", cpu.reg_bank_inst.register[2]);
    $display("Register R3 (Should be skipped)     = %d (Expected: 0)", cpu.reg_bank_inst.register[3]);
    $display("==================================================");

    // Assertions
    assert(mem_inst.mem[16'h0052] == 8'h0F) else $fatal(1, "Error: Add result is wrong!");
    assert(mem_inst.mem[16'h0053] == 8'h01) else $fatal(1, "Error: Flags are wrong!");
    assert(cpu.reg_bank_inst.register[3] == 8'h00) else $fatal(1, "Error: R3 was written (Jump failed or was not taken)!");

    $display("TEST PASSED successfully!");
    $finish;
  end

endmodule
