
linker_options = "LINKER_OPTIONS := -static -nostdlib -nostartfiles -lgcc -T \n"
target = "TARGET ?= elf\n"
# spike_command = "\tspike --log  $@ --isa=$(SPIKE_ISA) +signature=$@.sign $<\n"

makefile = "../work/Makefile"

line_list = []

with open(makefile, 'r') as f:
    for line in f.readlines():
        if("unknown" in line):
            line_list.append(target)
        elif("-lm" in line):
            line_list.append(linker_options)
        # elif "--log-commits" in line:
        #     line_list.append(spike_command)
        else:
            line_list.append(line)

with open(makefile, 'w') as f:
    for line in line_list:
        f.write(line)



