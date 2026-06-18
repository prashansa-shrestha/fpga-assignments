module four_bit_adder_tb;

// input
reg [3:0] a,b;
reg c_in;

//output
wire [3:0] sum;
wire c_out;

fulladd4 prashansa(
    .a(a),.b(b),
    .c_in(c_in),
    .sum(sum),
    .c_out(c_out)
);

initial begin
    $dumpfile("four_bit_adder.vcd");
    $dumpvars(0,prashansa);

    a=4'h4;
    b=4'h9;
    c_in=1;

    #100;

end
endmodule
    
