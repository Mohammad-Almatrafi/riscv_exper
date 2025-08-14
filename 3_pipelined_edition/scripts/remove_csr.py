import sys
import re

file_line_list = []


with open(sys.argv[1], 'r') as f:
    for line in f.readlines():
        if "csr" not in line:
            file_line_list.append(line)

with open(f'{sys.argv[1]}', 'w') as f:
    for line in file_line_list:
        f.write(line)


