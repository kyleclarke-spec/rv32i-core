# rv32i-core
Single-cycle RV32I RISC-V core in SystemVerilog.

## Status
- [x] Toolchain and test flow (4-bit adder)
- [x] ALU
- [ ] Register file
- [ ] Control unit
- [ ] Branch unit
- [ ] Memories and load/store unit
- [ ] Single-cycle CPU
- [ ] Running compiled programs
- [ ] 5-stage pipeline
- [ ] FPGA build

## Requirements

- Linux or WSL
- Verilator 5.036 or newer
- Python 3.10 or newer
- Make

## Setup

```
python3-m venv.venv
source.venv/bin/activate
pip install -r requirements.txt
```
## Running tests
```
make TEST=adder
```
