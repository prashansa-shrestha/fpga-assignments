`timescale 1ns/1ps

module full_adder_tb;

reg a,b,cin;
wire sum,carry;

full_adder uut(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .carry(carry)
);


initial begin
    $dumpfile("full_adder.vcd");
    $dumpvars(0,uut);


    a=0; b=0; cin=0; #100;
    a=0; b=0; cin=1; #100;
    a=0; b=1; cin=0; #100;
    a=0; b=1; cin=1; #100;
    a=1; b=0; cin=0; #100;
    a=1; b=0; cin=1; #100;
    a=1; b=1; cin=0; #100;
    a=1; b=1; cin=1; #100;

    $finish;

end

endmodule
