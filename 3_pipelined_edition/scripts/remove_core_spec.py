import sys
import re

file_line_list = []
check = 0
common_file = '../work/common/crt.S'
count = 0

with open(common_file, 'r') as f: 
    for line in f.readlines():
        if check == 1:
            count += 1
        if "now, assume only 1 core" in line:
            count += 1
            check = 1
        if count > 3 or count == 0:
            file_line_list.append(line)


with open(common_file, 'w') as f:
    for line in file_line_list:
        f.write(line)

