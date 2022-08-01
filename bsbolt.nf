//alignment
params.publish_dir = './results'
params.index = "$baseDir/index/"
params.read1 = "$baseDir/test_data/DogWolf00108_S84_R1_trimmed.fastq.gz"
params.read2 = "$baseDir/test_data/DogWolf00108_S84_R2_trimmed.fastq.gz"
params.sample = 'DogWolf00108'
params.title = ""

nextflow.enable.dsl = 2

include { FastQC } from ('./process/FastQC')
include { Cutadapt } from ('./process/Cutadapt')
include { Align } from ('./process/Align')
include { CallMethylation } from ('./process/CallMethylation')
include { MultiQC } from ('./process/MultiQC')

workflow { 
    FastQC(params.sample, params.read1, params.read2)
    Cutadapt(params.read1, params.read2)
    Align(params.sample, params.index, Cutadapt.out.read1, Cutadapt.out.read2)
    CallMethylation(params.sample, params.index, Align.out.bam)
    MultiQC(params.title, FastQC.out.report, Align.out.bam, CallMethylation.out.CGmap)
    }
