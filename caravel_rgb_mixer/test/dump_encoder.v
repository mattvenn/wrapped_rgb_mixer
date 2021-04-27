module dump();
    initial begin
        $dumpfile ("encoder.vcd");
        $dumpvars (0, encoder);
        #1;
    end
endmodule
