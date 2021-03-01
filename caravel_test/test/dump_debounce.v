module dump();
    initial begin
        $dumpfile ("debounce.vcd");
        $dumpvars (0, debounce);
        #1;
    end
endmodule
