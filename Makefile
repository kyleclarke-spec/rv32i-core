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

# The source files each test needs.
SRCS_adder = rtl/adder.sv

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

clean::
	rm -rf sim_build results.xml dump.vcd
