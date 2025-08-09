TEST_FILE:=

SRCS:=src/utils/holy_core_pkg.sv \
src/utils/control_utils.sv \
src/utils/datapath_utils.sv \
src/utils/defines.sv \
src/utils/main_control.sv \
src/utils/memory.sv \
src/core.sv \
src/rv32i_top.sv \
src/rv32i_top_tb.sv
src/LINT_SRCS:=utils/holy_core_pkg.sv \
src/utils/control_utils.sv \
src/utils/datapath_utils.sv \
src/utils/defines.sv \
src/utils/main_control.sv \
src/utils/memory.sv \
src/core.sv \
src/rv32i_top.sv


.PHONY: run build lint trace

mem_files:
	mkdir -p mem_files

build:
	mkdir -p build

wavedumps:
	mkdir -p wavedumps

run: build mem_files/text_mem.mem wavedumps
	cd mem_files && ../build/rv32i_top_tb.sim

compile: $(SRCS) build
	verilator --binary -I./utils $(SRCS) \
--top-module rv32i_top_tb --trace --timing --Wno-DECLFILENAME \
	-o ../build/rv32i_top_tb.sim

lint:
	verilator -Wall --lint-only $(LINT_SRCS) --Wno-DECLFILENAME

build_trace: build
	verilator --binary verification/tracer/ibex_pkg.sv verification/tracer/ibex_tracer_pkg.sv verification/tracer/ibex_tracer.sv \
--top-module ibex_tracer --trace --timing --Wno-DECLFILENAME --Wno-MULTIDRIVEN

trace:
	gtkwave wavedumps/wavedump.vcd

test: tests/$(TEST_FILE) mem_files
	riscv64-elf-as -mabi=ilp32 -march=rv32i tests/${TEST_FILE} -o build/${TEST_FILE}.o
	riscv64-elf-ld -mabi=ilp32 -march=rv32i -m elf32lriscv -nostdlib -T tests/linker.ld -o build/${TEST_FILE}.elf build/${TEST_FILE}.o

	riscv64-elf-objdump build/${TEST_FILE}.elf -D -S -M no-aliases -M numeric > build/${TEST_FILE}.dump

	riscv64-elf-objcopy --verilog-data-width 4 -O verilog -j .data build/${TEST_FILE}.elf temp.hex

	sed '1s/^/@/; s/ /\n/g' temp.hex > mem_files/data_mem.mem
	sed -i '1d' mem_files/data_mem.mem
	tr -d '\r' < mem_files/data_mem.mem > temp && mv temp mem_files/data_mem.mem

	riscv64-elf-objcopy --verilog-data-width 4 -O verilog -j .text build/${TEST_FILE}.elf temp.hex

	sed '1s/^/@/; s/ /\n/g' temp.hex > mem_files/text_mem.mem
	sed -i '1d' mem_files/text_mem.mem
	tr -d '\r' < mem_files/text_mem.mem > temp && mv temp mem_files/text_mem.mem
	rm temp.hex
	rm build/${TEST_FILE}.o
	rm build/${TEST_FILE}.elf

.PHONY: clean

clean:
	rm -rf build mem_files wavedumps obj_dir
