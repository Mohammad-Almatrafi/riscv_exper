NO_CSR_SYS = 1
PWD = $(shell pwd)
CORE_LOG_2_CSV  := python3 $(PWD)/scripts/core_log_to_trace_csv.py
SPIKE_LOG_2_CSV := python3 $(PWD)/scripts/spike_log_to_trace_csv.py
COMPARE         := python3 $(PWD)/scripts/instr_trace_compare.py
CHANGE_LD := cd scripts && python3 edit_ld.py
TRACER := 1
DATA_MEM_PATH := src/tb/data_mem.mem
TEXT_MEM_PATH := src/tb/text_mem.mem
ELF_FILE_PATH := work/bin/out_config_00000.riscv

LINT_SRCS:=src/HDL/utils/holy_core_pkg.sv\
src/HDL/utils/defines.sv\
src/HDL/utils/control_utils.sv\
src/HDL/utils/datapath_utils.sv\
src/HDL/utils/main_control.sv\
src/HDL/utils/memory.sv\
src/HDL/core.sv \
src/HDL/rv32i_top.sv

ifeq ($(TRACER), 1)
	TRACER_DEFINES = cd scripts && python3 tracer_defines.py 1
else
	TRACER_DEFINES = cd scripts && python3 tracer_defines.py 0
endif

ifeq ($(NO_CSR_SYS), 1)
	REMOVE_CSR_PROCS = cd scripts && python3 edit_makefile.py\
	cd scripts && python3 remove_csr.py ../work/asm/out_config_00000.S\
	cd scripts && python3 remove_csr.py ../work/asm/out_config_00000_template.S\
	cd scripts && python3 remove_csr.py ../work/common/crt.S\
	cd scripts && python3 remove_core_spec.py
else
	REMOVE_CSR_PROCS =
endif

.PHONY: gen_test test_run HDL_design_run clean gen_and_run 

gen_and_run: gen_test test_run

work:
	aapg setup

gen_test: work
	aapg gen
	$(TRACER_DEFINES)
	$(CHANGE_LD)
	$(REMOVE_CSR_PROCS)

logs_and_waves:
	mkdir -p logs_and_waves
output:
	mkdir -p output

.PHONY: gen_mem_files




gen_mem_files:
	riscv64-elf-objcopy --gap-fill=0xff --verilog-data-width 4 -O verilog -j .data $(ELF_FILE_PATH) temp.hex
	python3 scripts/objdump_format.py temp.hex
	mv temp.hex $(DATA_MEM_PATH)

	riscv64-elf-objcopy --verilog-data-width 4 --gap-fill=0xff -O verilog -j .text.init -j .text $(ELF_FILE_PATH) temp.hex
	python3 scripts/objdump_format.py temp.hex
	mv temp.hex $(TEXT_MEM_PATH)

test_run: logs_and_waves
	cd work && make
	python3 scripts/merge_spike_logs.py work/log/out_config_00000.log work/log/out_config_00000.dump > logs_and_waves/out_config_00000.log
	cp work/bin/out_config_00000.riscv ./logs_and_waves


HDL_design_run: gen_mem_files
	cd src/tb && make
	mv src/tb/dump.vcd src/tb/results.xml src/tb/mytrace_00000000.log ./logs_and_waves

.PHONY: log_to_csv compare
log_to_csv: output
	python3 scripts/ibex_log_to_trace_csv.py \
		--log ./logs_and_waves/mytrace_00000000.log \
		--csv output/core_trace.csv
	python3 scripts/spike_log_to_trace_csv.py \
		--log ./logs_and_waves/out_config_00000.log\
		--csv output/spike_trace.csv --full_trace

compare: output
	python3 scripts/instr_trace_compare.py --csv_file_1 output/core_trace.csv \
	--csv_file_2 output/spike_trace.csv \
	--csv_name_1 core --csv_name_2 spike



clean:
	rm -rf work logs_and_waves src/tb/sim_build \
		src/tb/__pycache__ src/tb/text_mem.mem \
		scripts/__pycache__ src/tb/data_mem.mem\
		output/



lint:
	verilator --top rv32i_top -Wall --lint-only $(LINT_SRCS) --Wno-DECLFILENAME
