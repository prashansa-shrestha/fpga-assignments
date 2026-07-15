
module processor(input a,b, output c,s);
	assign s = a ^ b;   // sum bit
	assign c = a & b;   // carry-out bit
endmodule  