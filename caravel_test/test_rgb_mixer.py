import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
import random
from test.test_encoder import Encoder

clocks_per_phase = 10


# takes ~60 seconds on my PC
@cocotb.test()
async def test_start(dut):
    clock = Clock(dut.clock, 25, units="ns")
    cocotb.fork(clock.start())
    
    dut.RSTB <= 0
    dut.power1 <= 0;
    dut.power2 <= 0;
    dut.power3 <= 0;
    dut.power4 <= 0;

    await ClockCycles(dut.clock, 8)
    dut.power1 <= 1;
    await ClockCycles(dut.clock, 8)
    dut.power2 <= 1;
    await ClockCycles(dut.clock, 8)
    dut.power3 <= 1;
    await ClockCycles(dut.clock, 8)
    dut.power4 <= 1;

    await ClockCycles(dut.clock, 80)
    dut.RSTB <= 1

    # wait for the project to become active
    await RisingEdge(dut.uut.mprj.proj_0.active)

async def run_encoder_test(encoder, dut_enc, max_count):
    for i in range(clocks_per_phase * 2 * max_count):
        await encoder.update(1)

    # let noisy transition finish, otherwise can get an extra count
    for i in range(10):
        await encoder.update(0)
    
    assert(dut_enc == max_count)

@cocotb.test()
async def test_all(dut):
    clock = Clock(dut.clock, 25, units="ns")
    encoder0 = Encoder(dut.clock, dut.mprj_io[ 8], dut.mprj_io[ 9], clocks_per_phase = clocks_per_phase, noise_cycles = clocks_per_phase / 4)
    encoder1 = Encoder(dut.clock, dut.mprj_io[10], dut.mprj_io[11], clocks_per_phase = clocks_per_phase, noise_cycles = clocks_per_phase / 4)
    encoder2 = Encoder(dut.clock, dut.mprj_io[12], dut.mprj_io[13], clocks_per_phase = clocks_per_phase, noise_cycles = clocks_per_phase / 4)

    cocotb.fork(clock.start())

    # wait for the reset signal
    await RisingEdge(dut.uut.mprj.proj_0.rgb_mixer0.reset)
    await FallingEdge(dut.uut.mprj.proj_0.rgb_mixer0.reset)

    assert dut.uut.mprj.proj_0.rgb_mixer0.enc0 == 0
    assert dut.uut.mprj.proj_0.rgb_mixer0.enc1 == 0
    assert dut.uut.mprj.proj_0.rgb_mixer0.enc2 == 0

    # pwm should all be low at start
    assert dut.pwm0_out == 0
    assert dut.pwm1_out == 0
    assert dut.pwm1_out == 0

    # do 3 ramps for each encoder 
    max_count = 255
    await run_encoder_test(encoder0, dut.uut.mprj.proj_0.rgb_mixer0.enc0, max_count)
    await run_encoder_test(encoder1, dut.uut.mprj.proj_0.rgb_mixer0.enc1, max_count)
    await run_encoder_test(encoder2, dut.uut.mprj.proj_0.rgb_mixer0.enc2, max_count)

    # sync to pwm
    await RisingEdge(dut.pwm0_out)
    # pwm should all be on for max_count 
    for i in range(max_count): 
        assert dut.pwm0_out == 1
        assert dut.pwm1_out == 1
        assert dut.pwm2_out == 1
        await ClockCycles(dut.clock, 1)
