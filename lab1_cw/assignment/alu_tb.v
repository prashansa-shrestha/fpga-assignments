module alu_8bit_tb;

reg [7:0] a,b;
reg [2:0] sel;

wire [7:0] out;
wire c_out;

alu_8bit prashansa(
    .a(a), .b(b),
    .sel(sel),
    .out(out),
    .c_out(c_out)
);

initial begin

    $dumpfile("alu.vcd");
    $dumpvars(0,prashansa);

    a=8'h1c;
    b=8'h09;

    sel=3'b000; // add
    #100;

    sel=3'b001; // sub
    #100;

    sel=3'b010; // and
    #100;

    sel=3'b011; // or
    #100;

    sel=3'b100; // xor
    #100;

    sel=3'b101; // not a
    #100;

    sel=3'b110; // nand
    #100;

    sel=3'b111; // nor
    #100;

    // $finish;

end
endmodule