#!/usr/bin/env python
import pandas as pd
import sys
import re
from tabulate import tabulate

usage = """parse_bsbolt.py ${sample}_report.txt"""
if len(sys.argv) != 2:
    exit("Usage: " + usage )

f = open(sys.argv[1], 'r')

filename  = sys.argv[1]
s_name = ''
for i in range(len(filename)):
    s_name += filename[i]
    if filename[i+1] == '_':
        break

regexes = {
            "Methylated C in CpG context"   : "Methylated / Total Observed CpG Cytosines:\s*(\d+)",
            "Methylated C in CH context"    : "Methylated / Total Observed CH Cytosines:\s*(\d+)",
            }

array_header = ['sample','cpg','ch']
array = [s_name]
mqc_fn = s_name + '_gs_mqc.txt'
with open(mqc_fn, 'a') as fi:
    print("# plot_type: 'generalstats'", file = fi)
    for l in f:
        l.strip('\n\r')
        for k, r in regexes.items():
            match = re.search(r, l)
            if match:
                value = float(match.group(1))
                array += [value]
    array_final = [array_header, array ]
    fi.write(tabulate(array_final, tablefmt="plain"))