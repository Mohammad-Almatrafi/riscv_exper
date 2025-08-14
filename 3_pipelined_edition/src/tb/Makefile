# Makefile

# defaults
SIM ?= verilator
TOPLEVEL_LANG ?= verilog
EXTRA_ARGS += --trace --trace-structs
SIM_ARGS="+ibex_tracer_file_base=mytrace"
PLUSARGS += +vcd

WAVES = 1
PWD = $(shell pwd)

VERILOG_SOURCES += $(PWD)/../HDL/utils/holy_core_pkg.sv
VERILOG_SOURCES += $(PWD)/../HDL/utils/control_utils.sv
VERILOG_SOURCES += $(PWD)/../HDL/utils/datapath_utils.sv
VERILOG_SOURCES += $(PWD)/../HDL/utils/defines.sv
VERILOG_SOURCES += $(PWD)/../HDL/utils/main_control.sv
VERILOG_SOURCES += $(PWD)/../HDL/utils/memory.sv

VERILOG_SOURCES += $(PWD)/../tracer/ibex_pkg.sv
VERILOG_SOURCES += $(PWD)/../tracer/ibex_tracer_pkg.sv
VERILOG_SOURCES += $(PWD)/../tracer/ibex_tracer.sv

VERILOG_SOURCES += $(PWD)/../HDL/core.sv 
VERILOG_SOURCES += $(PWD)/../HDL/rv32i_top.sv
VERILOG_SOURCES += $(PWD)/rv32i_top_wrapper.sv

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = rv32i_top_wrapper

# MODULE is the basename of the Python test file
MODULE = rv32i_top_tb

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim

