//alignment
params.publish_dir = './results'
params.index = ""
params.metadata = ""
params.title = ""

meta = Channel.from(file(params.metadata))
    .splitCsv(header:true)
    .map{ row-> tuple("$row.sample"), file("$row.read1"), file("$row.read2") }
    .set{sample_ch}

nextflow.enable.dsl = 2

include { FastQC } from ('./process/FastQC')
include { Align } from ('./process/Align')
include { CallMethylation } from ('./process/CallMethylation')
include { MultiQC } from ('./process/MultiQC')

workflow { 
    FastQC(sample_ch)
    Align(sample_ch, params.index)
    CallMethylation(sample_ch, params.index, Align.out.bam)
    MultiQC(params.title, FastQC.out.report.collect(), Align.out.bam, CallMethylation.out.CGmap)
    }