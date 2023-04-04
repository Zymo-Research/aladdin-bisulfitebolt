#!/usr/bin/env python
""" MultiQC module to parse output from Composition """
from __future__ import print_function
from collections import OrderedDict
import logging
from multiqc import config
from multiqc.modules.base_module import BaseMultiqcModule
import re
# Initialise the logger
log = logging.getLogger(__name__)

class MultiqcModule(BaseMultiqcModule):
    def __init__(self):
        # Initialise the parent object
        super(MultiqcModule, self).__init__(
            name="Cutadapt General Stats",
            anchor="cutadapt",
            href="",
            info=""
        )

        self.cutadapt_data = dict()
        
        for f in self.find_log_files("cutadapt", filehandles=True):
          self.parse_data(f)

        self.cutadapt_data = self.ignore_samples(self.cutadapt_data)
    
       
        if len(self.cutadapt_data) == 0:
            raise UserWarning

        log.info("Found {} reports".format(len(self.cutadapt_data)))

        self.write_data_file(self.cutadapt_data, "multiqc_cutdapt_GS")

        self.add_GS()
       
    def parse_data(self,f):
        """Go through log file looking for cutadapt output"""
        fh = f['f']
        regexes = {
            "bp_processed": "Total basepairs processed:\s*([\d,]+) bp",
            "bp_written": "Total written \(filtered\):\s*([\d,]+) bp",
            "quality_trimmed": "Quality-trimmed:\s*([\d,]+) bp",
            "r_processed": "Total reads processed:\s*([\d,]+)",
            "pairs_processed": "Total read pairs processed:\s*([\d,]+)",
            "r_with_adapters": "Reads with adapters:\s*([\d,]+)",
            "r1_with_adapters": "Read 1 with adapter:\s*([\d,]+)",
            "r2_with_adapters": "Read 2 with adapter:\s*([\d,]+)",
            "r_too_short": "Reads that were too short:\s*([\d,]+)",
            "pairs_too_short": "Pairs that were too short:\s*([\d,]+)",
            "r_too_long": "Reads that were too long:\s*([\d,]+)",
            "pairs_too_long": "Pairs that were too long:\s*([\d,]+)",
            "r_too_many_N": "Reads with too many N:\s*([\d,]+)",
            "pairs_too_many_N": "Pairs with too many N:\s*([\d,]+)",
            "r_written": "Reads written \(passing filters\):\s*([\d,]+)",
            "pairs_written": "Pairs written \(passing filters\):\s*([\d,]+)",
        }
        s_name = f["fn"].replace(".cutadapt.log","")
        self.cutadapt_data[s_name] = dict()
        for l in fh:
            for k, r in regexes.items():
                match = re.search(r, l)
                if match:
                    self.cutadapt_data[s_name][k] = int(match.group(1).replace(",", ""))


        # Calculate a few extra numbers of our own
        for s_name, d in self.cutadapt_data.items():
            # Percent trimmed
            if "bp_processed" in d and "bp_written" in d:
                self.cutadapt_data[s_name]["percent_trimmed"] = (
                    float(d["bp_processed"] - d["bp_written"]) / d["bp_processed"]
                ) * 100
            elif "bp_processed" in d and "bp_trimmed" in d:
                self.cutadapt_data[s_name]["percent_trimmed"] = (
                    (float(d.get("bp_trimmed", 0)) + float(d.get("quality_trimmed", 0))) / d["bp_processed"]
                ) * 100

    def add_GS(self):
        headers = {}
        headers["percent_trimmed"] = {
            "title": "% BP Trimmed",
            "description": "% Total Base Pairs trimmed",
            "max": 100,
            "min": 0,
            "suffix": "%",
            "scale": "RdYlBu-rev",
        }
        self.general_stats_addcols(self.cutadapt_data, headers)
   