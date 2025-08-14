import sys
import re

file_line_list = []
defines_path = "../src/HDL/utils/defines.sv"
defines = ["`define tracer\n"]
tracer = int(sys.argv[1])

with open(defines_path, 'w') as f:
    for line in defines:
        if(tracer == 1):
            f.write(line)
    f.write("\n\n")
