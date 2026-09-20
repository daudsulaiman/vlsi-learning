`timescale 1ns/1ps


module mux_tb;
reg a;
reg b;
reg sel;
wire y;

mux dut(
    .a(a),
    .b(b),
    .sel(sel),
    .y(y)
);


initial begin
    $dumpfile("sim/mux.vcd");
    $dumpvars(0, mux_tb);

    $monitor("time=%0t | a=%b b=%b sel=%b | y=%b", $time, a, b, sel, y);

    a = 0; b = 0; sel = 0; #10;
    a = 0; b = 0; sel = 1; #10;
    a = 0; b = 1; sel = 0; #10;
    a = 0; b = 1; sel = 1; #10;
    a = 1; b = 0; sel = 0; #10;
    a = 1; b = 0; sel = 1; #10;
    a = 1; b = 1; sel = 0; #10;
    a = 1; b = 1; sel = 1; #10;
    $finish;
end
endmodule
