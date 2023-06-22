#!/usr/bin/env python
from __future__ import print_function
from collections import OrderedDict
import re

regexes = OrderedDict()

regexes["BiSulfite pipeline"] = ["v_pipeline.txt", r"(\S+)"]
regexes["Nextflow"] = ["v_nextflow.txt", r"(\S+)"]
regexes["FastQC"] = ["v_fastqc.txt", r"FastQC v(\S+)"]
regexes["Cutadapt"] = ["v_Cutadapt.txt", r"(\S+)"]
regexes["BiSulfite Bolt"] = ["v_bsbolt.txt", r"BiSulfite Bolt v(\S+)"]
regexes["Samtools"] = ["v_samtools.txt", r"samtools (\S+)"]

results = OrderedDict()

# Search each file using its regex
for k, v in regexes.items():
    try:
        with open(v[0], encoding="ISO-8859-1") as x:
            versions = x.read()
            match = re.search(v[1], versions)
            if match:
                results[k] = "v{}".format(match.group(1))
    except IOError:
        results[k] = False

# Dump to YAML
print(
    """
id: 'software_versions'
section_name: 'Software Versions'
plot_type: 'html'
description: 'Software versions are collected at run time from the software output.'
data: |
    <dl class="dl-horizontal">
"""
)
for k, v in results.items():
    # Only display versions of softwares that were actually used.
    if v:
        print("        <dt>{}</dt><dd><samp>{}</samp></dd>".format(k, v))
print("    </dl>")

# Write out regexes as csv file:
with open("software_versions.csv", "w") as f:
    for k, v in results.items():
        if v:
            f.write("{}\t{}\n".format(k, v))
