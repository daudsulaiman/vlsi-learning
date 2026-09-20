module mux(input a, input b, input sel, output y);
assign y = (b&sel) | (a&(~sel));
endmodule
