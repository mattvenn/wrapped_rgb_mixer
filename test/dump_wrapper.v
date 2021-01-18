module dump();
    initial begin
        $dumpfile ("wrapper.vcd");
        $dumpvars (0, wrapper);
        #1;
    end
endmodule
