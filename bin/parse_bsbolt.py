#!/usr/bin/env python
import pandas as pd
import os
import sys
import re
from tabulate import tabulate
tabulate.PRESERVE_WHITESPACE = True

usage = """parse_bsbolt.py samples"""

regexes = {
            "'%Methylated_C_in_CpG_context'"    : "Methylated / Total Observed CpG Cytosines:\s*(\d+)",
            "'Total_Reads'"                     : "Total Reads:\s*(\d+)",
            "%Mappability"                       : "Mappability:\s*(\d+)"
            }
array_header = ['sample']
array = []
for i in range(1,len(sys.argv)):
    f = open(sys.argv[i], 'r')
    filename = sys.argv[i].split(os.sep)[-1]
    s_name = ''
    for i in range(len(filename)):
        s_name += filename[i]
        if filename[i+1] == '_':
            if filename[i+2] == 'a':
                method = 'align'
            else: 
                method = 'meth'
            break

    mqc_fn = method + "_gs_mqc.txt"
    array_s = [s_name]
    for l in f:
        l.strip('\n\r')
        for k, r in regexes.items():
            match = re.search(r, l)
            if match:
                value = float(match.group(1))
                array_s += [float(value)]
                array_header += [(k)]
    array += [array_s]

with open(mqc_fn, 'a+') as fi:
    print("# plot_type: 'generalstats'", file = fi)
    array_final = array
    fi.write(tabulate(array_final, headers = array_header, tablefmt="plain", disable_numparse=True, floatfmt=".4f"))
