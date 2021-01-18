import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles

from project2_1.test.encoder import Encoder

@cocotb.test()
async def test_wrapper(dut):
    clock = Clock(dut.wb_clk_i, 10, units="ns")
    cocotb.fork(clock.start())

    clocks_per_phase = 5
    encoder = Encoder(dut.wb_clk_i, dut.io_in[8], dut.io_in[9], clocks_per_phase = clocks_per_phase, noise_cycles = 0)

    dut.wb_rst_i <= 1
    await ClockCycles(dut.wb_clk_i, 5)
    dut.wb_rst_i <= 0
    dut.la_data_in <= 0

    # count up with encoder with project inactive
    for i in range(clocks_per_phase * 2 *  255):
        await encoder.update(1)

    # pause
    await ClockCycles(dut.wb_clk_i, 100)

    # activate project
    dut.active <= 1

    # reset it
    dut.la_data_in <= 1 << 0
    await ClockCycles(dut.wb_clk_i, 1)
    dut.la_data_in <= 0 << 0
    await ClockCycles(dut.wb_clk_i, 1)

    # count up with encoder while project is active
    for i in range(clocks_per_phase * 2 *  255):
        await encoder.update(1)

    await ClockCycles(dut.wb_clk_i, 1000)
