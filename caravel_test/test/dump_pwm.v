module dump();
    initial begin
        $dumpfile ("pwm.vcd");
        $dumpvars (0, pwm);
        #1;
    end
endmodule
