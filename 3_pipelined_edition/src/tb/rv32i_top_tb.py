
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer
import numpy as np

@cocotb.test()
async def rv32i_top_smoke_test(dut):
    """Basic smoke test for rv32i_top"""

    # Start the clock: 10 ns period (5ns high, 5ns low)
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    # Apply reset: rst_n = 1 -> 0 -> 1 with 5 ns spacing
    dut.rst_n.value = 1
    await Timer(5, units="ns")
    dut.rst_n.value = 0
    await Timer(5, units="ns")
    dut.rst_n.value = 1

    # Let the design run for 10000 falling edges of clk
    for _ in range(100000):
        await FallingEdge(dut.clk)

    # Simulation ends
    dut._log.info("Simulation complete")
