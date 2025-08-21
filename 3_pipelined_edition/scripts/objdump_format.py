import sys
import re

file_line_list = []


with open(sys.argv[1], 'r') as f:
    for line in f.readlines():
        if "@" not in line:
            line_stripped = line.strip()
            file_line_list.extend(line_stripped.split(" "))

with open(f'{sys.argv[1]}', 'w') as f:
    # for line in file_line_list:
    for i in range(len(file_line_list)):
        f.write(f"{file_line_list[i]}\n")

