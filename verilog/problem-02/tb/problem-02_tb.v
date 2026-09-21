`timescale 1ns/1ps

module access_tb;
reg system_on;
reg req_a;
reg req_b;
reg ready_a;
reg ready_b;
reg block_a;
reg block_b;
wire grant_a;
wire grant_b;
wire activity;
wire denied;


access dut(.system_on(system_on),
           .req_a(req_a),
           .req_b(req_b),
           .ready_a(ready_a),
           .ready_b(ready_b),
           .block_a(block_a),
           .block_b(block_b),
           .grant_a(grant_a),
           .grant_b(grant_b),
           .activity(activity),
           .denied(denied)
           );

integer i;

initial begin
    $dumpfile("sim/problem-02.vcd");
    $dumpvars(0, access_tb);

    $monitor(
        "time=%0t | system_on=%b req_a=%b req_b=%b ready_a=%b ready_b=%b block_a=%b block_b=%b | grant_a=%b grant_b=%b activity=%b denied=%b",
        $time,
        system_on, req_a, req_b,
        ready_a, ready_b,
        block_a, block_b,
        grant_a, grant_b,
        activity, denied
    );

    for (i = 0; i < 128; i = i + 1) begin
        {system_on, req_a, req_b,
         ready_a, ready_b,
         block_a, block_b} = i;

        #10;
    end

    $finish;
end
endmodule