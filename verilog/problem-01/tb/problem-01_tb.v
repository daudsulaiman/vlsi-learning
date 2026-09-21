`timescale 1ns/1ps

module send_tb;
reg request;
reg link_ready;
reg local_mode;
reg blocked;
wire send_allowed;

send dut(.request(request),
         .link_ready(link_ready),
         .local_mode(local_mode),
         .blocked(blocked),
         .send_allowed(send_allowed)
         );

initial begin
    $dumpfile("sim/problem-01.vcd");
    $dumpvars(0, send_tb);

    $monitor("time=%0t | request=%b link_ready=%b local_mode=%b  blocked =%b| send_allowed=%b", $time, request, link_ready, local_mode, blocked, send_allowed);

    request = 0; link_ready = 0; local_mode = 0; blocked = 0; #10;
    request = 0; link_ready = 0; local_mode = 0; blocked = 1; #10;
    request = 0; link_ready = 0; local_mode = 1; blocked = 0; #10;
    request = 0; link_ready = 0; local_mode = 1; blocked = 1; #10;
    request = 0; link_ready = 1; local_mode = 0; blocked = 0; #10;
    request = 0; link_ready = 1; local_mode = 0; blocked = 1; #10;
    request = 0; link_ready = 1; local_mode = 1; blocked = 0; #10;
    request = 0; link_ready = 1; local_mode = 1; blocked = 1; #10;
    request = 1; link_ready = 0; local_mode = 0; blocked = 0; #10;
    request = 1; link_ready = 0; local_mode = 0; blocked = 1; #10;
    request = 1; link_ready = 0; local_mode = 1; blocked = 0; #10;
    request = 1; link_ready = 0; local_mode = 1; blocked = 1; #10;
    request = 1; link_ready = 1; local_mode = 0; blocked = 0; #10;
    request = 1; link_ready = 1; local_mode = 0; blocked = 1; #10;
    request = 1; link_ready = 1; local_mode = 1; blocked = 0; #10;
    request = 1; link_ready = 1; local_mode = 1; blocked = 1; #10;
    $finish;
end
endmodule