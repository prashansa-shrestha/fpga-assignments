// defining an eight bit alu

module alu_8bit(
    input [7:0] a,b,
    input [2:0] sel,
    output [7:0] out,
    output c_out
);

// internal networks
wire [7:0] sum_res, b_xor, and_res, or_res, xor_res, not_res, nand_res, nor_res;
wire add_cout;

// sel=000 add, sel=001 sub (uses 2's complement via cin)
assign b_xor = (sel==3'b001) ? ~b : b;

fulladd8 alu_adder(
    .a(a),
    .b(b_xor),
    .c_in(sel[0]),
    .sum(sum_res),
    .c_out(add_cout)
);

assign and_res  = a & b;
assign or_res   = a | b;
assign xor_res  = a ^ b;
assign not_res  = ~a;
assign nand_res = ~(a & b);
assign nor_res  = ~(a | b);

mux_8 alu_mux(
    .I0(sum_res),
    .I1(sum_res),
    .I2(and_res),
    .I3(or_res),
    .I4(xor_res),
    .I5(not_res),
    .I6(nand_res),
    .I7(nor_res),
    .Sel(sel),
    .O(out)
);

assign c_out = (sel==3'b000 || sel==3'b001) ? add_cout : 1'b0;

endmodule