module mux_8(
    input  [7:0] I0,
    input  [7:0] I1,
    input  [7:0] I2,
    input  [7:0] I3,
    input  [7:0] I4,
    input  [7:0] I5,
    input  [7:0] I6,
    input  [7:0] I7,
    input  [2:0] Sel,
    output [7:0] O
);
assign O = (Sel == 3'b000) ? I0 :
           (Sel == 3'b001) ? I1 :
           (Sel == 3'b010) ? I2 :
           (Sel == 3'b011) ? I3 :
           (Sel == 3'b100) ? I4 :
           (Sel == 3'b101) ? I5 :
           (Sel == 3'b110) ? I6 :
                             I7;
endmodule