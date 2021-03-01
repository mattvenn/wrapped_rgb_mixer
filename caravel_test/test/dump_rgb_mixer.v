module dump();
    initial begin
        $dumpfile ("rgb_mixer.vcd");
        $dumpvars (0, rgb_mixer);
        #1;
    end
endmodule
