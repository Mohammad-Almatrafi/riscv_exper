import sys
import re

# Usage: python merge_spike_logs.py instr.log commit.log > merged.log

if len(sys.argv) != 3:
    print("Usage: python merge_spike_logs.py instr.log commit.log > merged.log")
    sys.exit(1)

instr_file = sys.argv[1]
commit_file = sys.argv[2]

with open(instr_file, 'r') as f:
    instr_lines = f.readlines()

with open(commit_file, 'r') as f:
    commit_lines = f.readlines()

for i in range(len(instr_lines)):
    print(f"{instr_lines[i].strip()}\n{commit_lines[i].strip()}")

