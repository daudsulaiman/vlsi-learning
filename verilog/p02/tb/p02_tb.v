`timescale 1ns/1ps

module mux_tb;
reg [3:0]a;
reg [3:0]b;
reg sel;
wire [3:0]y;

mux dut(.a(a), .b(b), .sel(sel), .y(y));

integer i;
integer j;
integer k;

initial begin
    $dumpfile("sim/mux.vcd");
    $dumpvars(0, mux_tb);

    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            for (k = 0; k < 2; k = k + 1) begin

                a   = i;
                b   = j;
                sel = k;

                #10;

                $display(
                    "time=%0t | a=%b b=%b sel=%b | y=%b",
                    $time, a, b, sel, y
                );

            end
        end
    end

    $finish;
end

endmodule
