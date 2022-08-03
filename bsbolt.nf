// Add nextflow shebang line to the top of the file:
// #!/usr/bin/env nextflow

nextflow.enable.dsl = 2

//alignment
params.publish_dir = './results'
params.index = ""
params.metadata = ""

meta = Channel.from(file(params.metadata))
                .splitCsv(header:true)
                .map{ row-> tuple("$row.sample"), file("$row.read1"), file("$row.read2") }
                .set{sample_ch}


include { FastQC }              from ('./process/FastQC')
include { Cutadapt }            from ('./process/Cutadapt')
include { Align }               from ('./process/Align')
include { CallMethylation }     from ('./process/CallMethylation')
include { MatrixBuilding }      from ('./process/MatrixBuilding')
include { MultiQC }             from ('./process/MultiQC')

workflow { 
    FastQC(sample_ch)
    Cutadapt(sample_ch)
    Align(Cutadapt.out.ca_read1,Cutadapt.out.ca_read2, params.index)
    CallMethylation(params.index, Align.out.bam)
    MatrixBuilding(CallMethylation.out.CGmap.collect())
    MultiQC(FastQC.out.report.collect(), Cutadapt.out.log.collect(), Align.out.bam, CallMethylation.out.CGmap, MatrixBuilding.out.matrix)
    }
