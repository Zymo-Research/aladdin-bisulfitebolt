# nxf-bisulfitebolt Nextflow Pipeline

This is a bioinformatics analysis pipeline used for analyzing bisulfite sequencing data. The pipeline is built with Nextflow and [BS Bolt](https://github.com/NuttyLogic/BSBolt) suite. 

## Analysis components

The pipeline includes the following analyes:

1. Trimming input sequencing reads using [Cutadapt](https://cutadapt.readthedocs.io/en/stable/).

2. Evaluating reads quality after trimming using [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/).

3. Aligning trimmed reads and create methylation matrix using [BS Bolt](https://github.com/NuttyLogic/BSBolt).

4. Generating a [MultiQC](http://multiqc.info/) report with all important metrics.

## Generating Index
We generate the index before running the pipelie. 
Here are the parameters: RRBS Index, MSPI Cut Format, 40bp Lower Fragment Bound, and 400bp Upper Fragment Bound.
```
python3 -m bsbolt Index -G hg38_selected.fa -DB DB_indexFull_test -rrbs -rrbs-cut-format C-CGG -rrbs-lower 40 -rrbs-upper 400
```

## Quick Start

To run the pipeline, clone the _**dev**_ branch and run the following command:

```bash
nextflow run bsbolt.nf --index /path/to/index/genome/ \
                        --project project_name \
                        --metadata /path/to/metadata.csv \
                        2&>1 | tee headnode.log
```

The metadata CSV file must have the following format. 
```
group,sample,read_1,read_2
Control,Sample1,s3://mybucket/this_is_s1_R1.fastq.gz,s3://mybucket/this_is_s1_R2.fastq.gz
Control,Sample2,s3://mybucket/this_is_s2_R1.fastq.gz,s3://mybucket/this_is_s2_R2.fastq.gz
Experiment,Sample3,s3://mybucket/that_is_s3_R1.fastq.gz,
Experiment,Sample4,s3://mybucket/that_be_s4_R1.fastq.gz,
```
