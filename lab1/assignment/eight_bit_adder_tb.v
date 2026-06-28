module eight_bit_adder_tb;

reg [7:0] a,b;
reg c_in;

wire [7:0] sum;
wire c_out;

fulladd8 prashansa(
    .a(a), .b(b),
    .c_in(c_in),
    .sum(sum),
    .c_out(c_out)
);

initial begin

    $dumpfile("eight_bit_adder.vcd");
    $dumpvars(0,prashansa);

    a=8'h5f;
    b=8'ha2;

    c_in=1;

    #100;

end
endmodule
