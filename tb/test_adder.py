# test_adder.py
# Test for the 4-bit adder: tries all 256 input pairs

import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def test_adder_all_inputs(dut):
    """Check every combination of two 4-bit inputs."""
    for a in range(16):
        for b in range(16):
            dut.a.value = a
            dut.b.value = b
            await Timer(1, "ns")
            got = int(dut.sum.value)
            expected = a + b
            assert got == expected, f"{a} + {b}: expected {expected}, got {got}"
