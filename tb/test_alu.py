# test alu.sv
# Checks every ALU operation against a Python model, using hand-picked
# edge cases plus thousands of random inputs

import random

import cocotb
from cocotb.triggers import Timer

MASK32 = 0xFFFF_FFFF #32 ones

# These numbers must match the alu_op_t enum in rtl/rv32i_pkg.sv
ALU_ADD = 0
ALU_SUB = 1
ALU_SLL = 2
ALU_SLT = 3
ALU_SLTU = 4
ALU_XOR = 5
ALU_SRL = 6
ALU_SRA = 7
ALU_OR = 8
ALU_AND = 9

OP_NAMES = {
    ALU_ADD: "ADD", ALU_SUB: "SUB", ALU_SLL: "SLL", ALU_SLT: "SLT",
    ALU_SLTU: "SLTU", ALU_XOR: "XOR", ALU_SRL: "SRL", ALU_SRA: "SRA",
    ALU_OR: "OR", ALU_AND: "AND",
}

def to_signed(x):
    """Interpret a 32-bit pattern as a signed (two's complement) integer."""
    return x - (1 << 32) if x & 0x8000_0000 else x


def alu_model(op, a, b):
    """What the ALU should output. a and b are unsigned 32-bit patterns."""
    shamt = b & 0x1F # Shift amount
    if op == ALU_ADD:
        return (a + b) & MASK32
    if op == ALU_SUB:
        return (a - b) & MASK32
    if op == ALU_SLL:
        return (a << shamt) & MASK32
    if op == ALU_SLT:
        return 1 if to_signed(a) < to_signed(b) else 0
    if op == ALU_SLTU:
        return 1 if a < b else 0
    if op == ALU_XOR:
        return a ^ b
    if op == ALU_SRL:
        return a >> shamt
    if op == ALU_SRA:
        return (to_signed(a) >> shamt) & MASK32
    if op == ALU_OR:
        return a | b
    if op == ALU_AND:
        return a & b
    raise ValueError(f"unkown op {op}")

async def check(dut, op, a, b):
    """Drive one set of inputs and compare the DUT to the model."""
    dut.op.value = op
    dut.a.value = a
    dut.b.value = b
    await Timer(1, "ns")
    got = int(dut.result.value)
    expected = alu_model(op, a, b)
    assert got == expected, (
        f"{OPNAMES[op]} a=0x{a:08x} b=0x{b:08x}: "
        f"expected 0x{expected:08x}, got 0x{got:08x}"
    )

EDGE_VALUES = [
    0x0000_0000, 0x0000_0001, 0x0000_0002, 0x0000_001F, 0x0000_0020,
    0x7FFF_FFFF, 0x8000_0000, 0x8000_0001, 0xFFFF_FFFE, 0xFFFF_FFFF,
]

@cocotb.test()
async def test_alu_edge_cases(dut):
    """Every op on every pair of edge values"""
    for op in OP_NAMES:
        for a in EDGE_VALUES:
            for b in EDGE_VALUES:
                await check(dut, op, a, b)

@cocotb.test()
async def test_alu_random(dut):
    """Random inputs for every op."""
    for _ in range(2000):
        op = random.choice(list(OP_NAMES))
        a = random.getrandbits(32)
        b = random.getrandbits(32)
        await check(dut, op, a, b)
