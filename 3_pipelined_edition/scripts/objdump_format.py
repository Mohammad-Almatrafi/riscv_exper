import sys
import re

file_line_list = []


with open(sys.argv[1], 'r') as f:
    for line in f.readlines():
        if "@" in line:
            continue
        else:
            line_striped = line.strip()
            file_line_list.extend(line_striped.split(" "))

with open(f'{sys.argv[1]}', 'w') as f:
    for line in file_line_list:
        f.write(f"{line}\n")

