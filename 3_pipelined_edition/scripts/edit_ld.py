import sys
import re

file_line_list = []
check_data = 0
check_text = 0
ld_file = '../work/asm/out_config_00000.ld'
data_start_addr = "  . = 0x80400000;\n"
text_start_addr = "  . = 0x80000000;\n"

with open(ld_file, 'r') as f: 
    for line in f.readlines():

        if "text: test code section" in line:
            check_text = 1
            file_line_list.append(line)
        elif "data segment" in line:
            check_data = 1
            file_line_list.append(line)
        elif check_text == 1:
            file_line_list.append(text_start_addr)
            check_text = 0
        elif check_data == 1:
            file_line_list.append(data_start_addr)
            check_data = 0
        elif check_data != 1 and check_text != 1:
            file_line_list.append(line)

with open(ld_file, 'w') as f:
    for line in file_line_list:
        f.write(line)

