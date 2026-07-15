// =============================================================
// Top-level 8-bit Processor Module
// Connects the Control Unit, Register Bank, and ALU together.
// =============================================================

module processor #(
    parameter int AD_LINES   = 16,
    parameter int DATA_LINES = 8
) (
    input logic clk,
    input logic reset,
    
    // External Memory Interface
    output logic [AD_LINES - 1 : 0] addr_bus,
    inout wire [DATA_LINES - 1 : 0] data_bus,
    output logic mem_cs,
    output logic mem_rd_wr_bar
);

  // Interconnecting control and data signals
  wire [2:0] reg_sel[1:0];
  wire reg_alu_db_bar;
  wire reg_rd_wr_bar;
  wire swp;
  wire reg_cs;
  wire [3:0] alu_sel;

  // Interconnecting data buses
  wire [DATA_LINES - 1 : 0] alu_input;
  wire [DATA_LINES - 1 : 0] alu_out[1:0];
  wire [DATA_LINES - 1 : 0] acc_out;

  // Instantiate Control Unit
  control_unit #(
      .AD_LINES(AD_LINES),
      .DATA_LINES(DATA_LINES)
  ) cu_inst (
      .clk(clk),
      .reset(reset),
      .acc_in(acc_out),
      .addr_bus(addr_bus),
      .data_bus(data_bus),
      .mem_cs(mem_cs),
      .mem_rd_wr_bar(mem_rd_wr_bar),
      .reg_sel(reg_sel),
      .reg_alu_db_bar(reg_alu_db_bar),
      .reg_rd_wr_bar(reg_rd_wr_bar),
      .swp(swp),
      .reg_cs(reg_cs),
      .alu_sel(alu_sel)
  );

  // Instantiate Register Bank
  register_bank #(
      .NO_REGISTERS(8),
      .DATA_LINES(DATA_LINES)
  ) reg_bank_inst (
      .clk(clk),
      .data_bus(data_bus),
      .alu_db_bar(reg_alu_db_bar),
      .rd_wr_bar(reg_rd_wr_bar),
      .swp(swp),
      .reg_sel(reg_sel),
      .cs(reg_cs),
      .alu_input(alu_input),
      .alu_out(alu_out),
      .acc_out(acc_out)
  );

  // Instantiate ALU
  ALU alu_inst (
      .opcode(alu_sel),
      .clk(clk),
      .reset(reset),
      .operand1(alu_out[0]),
      .operand2(alu_out[1]),
      .result(alu_input)
  );

endmodule
