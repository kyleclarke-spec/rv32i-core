# Makefile for rv32i-core
#
# make				run the default test(TEST=adder)
# make TEST=adder	run one module's test
# make TEST=adderr WAVES=1   also save a waveform to dump.vcd
# make clean 		delete everything the imulator generated

SIM ?= verilator
TOPLEVEL_LANG = verilog
TEST ?= adder
WAVES ?= 0

# Every test, in the order the book builds them.
TESTS = adder alu

# The source files each test needs. Packages must come first.
PKG = rtl/rv32i_pkg.sv

SRCS_adder = rtl/adder.sv
SRCS_alu = $(PKG) rtl/alu.sv

ifeq ($(SRCS_$(TEST)),)
  $(error Unkown TEST '$(TEST)')
endif

VERILOG_SOURCES = $(addprefix $(CURDIR)/,$(SRCS_$(TEST)))
COCOTB_TOPLEVEL = $(TEST)
COCOTB_TEST_MODULES = test_$(TEST)
SIM_BUILD = sim_build/$(TEST)
export PYTHONPATH := $(CURDIR)/tb:$(PYTHONPATH)

ifeq ($(WAVES),1)
	VERILATOR_TRACE = 1
	SIM_BUILD := sim_build/$(TEST)_waves
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

.PHONY: test-all

test-all:
	@for t in $(TESTS); do \
		$(MAKE) --no-print-directory TEST=$$t || exit 1; \
	done

clean::
	rm -rf sim_build results.xml dump.vcd
