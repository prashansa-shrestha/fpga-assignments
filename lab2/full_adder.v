module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output carry
);

wire s1;
wire c1;
wire c2;

half_adder ha1(
    .a(a),
    .b(b),
    .carry(c1),
    .sum(s1)
);

half_adder ha2(
    .a(s1),
    .b(cin),
    .carry(c2),
    .sum(sum)
);

assign carry=c1|c2;

endmodule
