// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`timescale 1 ns / 1 ps

module rgb_mixer_tb;
    initial begin
        $dumpfile ("rgb_mixer.vcd");
        $dumpvars (0, rgb_mixer_tb);
        #1;
    end

    reg clk;
    reg RSTB;
    reg power1, power2;
    reg power3, power4;

    // GL design loses the reset signal name, also doesn't keep la1_data_in
    wire design_reset = uut.mprj.la_data_in[32];

    wire gpio;
    wire [37:0] mprj_io;

    ///// convenience signals that match what the cocotb test modules are looking for
    wire pwm0_out = mprj_io[14];
    wire pwm1_out = mprj_io[15];
    wire pwm2_out = mprj_io[16];

    wire enc0_a, enc0_b, enc1_a, enc1_b, enc2_a, enc2_b;

    assign mprj_io[ 8] = enc0_a;
    assign mprj_io[ 9] = enc0_b;
    assign mprj_io[10] = enc1_a;
    assign mprj_io[11] = enc1_b;
    assign mprj_io[12] = enc2_a;
    assign mprj_io[13] = enc2_b;
    /////
    

    wire flash_csb;
    wire flash_clk;
    wire flash_io0;
    wire flash_io1;

    wire VDD3V3 = power1;
    wire VDD1V8 = power2;
    wire USER_VDD3V3 = power3;
    wire USER_VDD1V8 = power4;
    wire VSS = 1'b0;

    caravel uut (
        .vddio    (VDD3V3),
        .vssio    (VSS),
        .vdda     (VDD3V3),
        .vssa     (VSS),
        .vccd     (VDD1V8),
        .vssd     (VSS),
        .vdda1    (USER_VDD3V3),
        .vdda2    (USER_VDD3V3),
        .vssa1    (VSS),
        .vssa2    (VSS),
        .vccd1    (USER_VDD1V8),
        .vccd2    (USER_VDD1V8),
        .vssd1    (VSS),
        .vssd2    (VSS),
        .clock    (clk),
        .gpio     (gpio),
        .mprj_io  (mprj_io),
        .flash_csb(flash_csb),
        .flash_clk(flash_clk),
        .flash_io0(flash_io0),
        .flash_io1(flash_io1),
        .resetb   (RSTB)
    );

    spiflash #(
        .FILENAME("rgb_mixer.hex")
    ) spiflash (
        .csb(flash_csb),
        .clk(flash_clk),
        .io0(flash_io0),
        .io1(flash_io1),
        .io2(),         // not used
        .io3()          // not used
    );

endmodule
`default_nettype wire
