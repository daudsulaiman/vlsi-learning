module send(input request,
            input link_ready, 
            input local_mode, 
            input blocked, 
            output send_allowed
            );

assign send_allowed = (link_ready | local_mode) & request & ~blocked;
endmodule