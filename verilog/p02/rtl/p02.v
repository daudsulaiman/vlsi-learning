module mux (input [3:0] a,
            input [3:0] b,
            input sel,
            output [3:0] y
            );
assign y[3:0] = sel ? b : a;
endmodule
