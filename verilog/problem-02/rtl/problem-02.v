module access(input system_on,
              input req_a,
              input req_b,
              input ready_a,
              input ready_b,
              input block_a,
              input block_b,
              output grant_a,
              output grant_b,
              output activity,
              output denied
              );

assign grant_a = system_on & req_a & ready_a &~block_a;
assign grant_b = system_on & req_b & ready_b & ~block_b;
assign activity = grant_a | grant_b;
assign denied   = (req_a & ~grant_a) | (req_b & ~grant_b);

endmodule