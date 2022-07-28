//alignment
params.publish_dir = './results'
params.index = "$baseDir/index/"
params.read1 = "$baseDir/test_data/DogWolf00108_ca_R1.fastq"
params.read2 = "$baseDir/test_data/DogWolf00108_ca_R2.fastq"
params.sample = 'DogWolf00108'
params.title = ""

nextflow.enable.dsl = 2

include { FastQC } from ('./process/FastQC')
include { Align } from ('./process/Align')
include { CallMethylation } from ('./process/CallMethylation')
include { MultiQC } from ('./process/MultiQC')

workflow { 
    FastQC(params.sample, params.read1, params.read2)
    Align(params.sample, params.index, params.read1, params.read2)
    CallMethylation(params.sample, arams.index, Align.out.bam)
    MultiQC(params.title, FastQC.out.report, Align.out.bam, CallMethylation.out.CGmap)
    }