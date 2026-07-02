// =============================================================
// bit8adder / bit8subtractor
// Thin wrappers around fulladd8 (from eight_bit_adder.v) that
// expose the port names expected by alu.v:
//   bit8adder      : a, b, sum,  cin, cout
//   bit8subtractor : a, b, diff, cin, cout
//
// Subtraction is done via two's complement: a - b = a + (~b) + 1
// alu.v already passes cin=1'b1 for subtract/decrement, so we
// just need to invert b here and feed it into fulladd8.
// =============================================================

module bit8adder (
    input  [7:0] a, b,
    input        cin,
    output [7:0] sum,
    output       cout
);

  fulladd8 adder_core (
      .a(a),
      .b(b),
      .c_in(cin),
      .sum(sum),
      .c_out(cout)
  );

endmodule


module bit8subtractor (
    input  [7:0] a, b,
    input        cin,
    output [7:0] diff,
    output       cout
);

  fulladd8 sub_core (
      .a(a),
      .b(~b),
      .c_in(cin),
      .sum(diff),
      .c_out(cout)
  );

endmodule
