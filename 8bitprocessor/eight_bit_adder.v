// defining an eight bit adder

module fulladd8(
    input [7:0] a,b,
    input c_in,
    output [7:0] sum,
    output c_out
);

wire c0;

fulladd4 fa40 (
    .a(a[3:0]),
    .b(b[3:0]),
    .c_in(c_in),
    .sum(sum[3:0]),
    .c_out(c0)
);

fulladd4 fa41(
    .a(a[7:4]),
    .b(b[7:4]),
    .c_in(c0),
    .sum(sum[7:4]),
    .c_out(c_out)
);

endmodule
