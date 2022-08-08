// #!/usr/bin/env nextflow

nextflow.enable.dsl = 2

//alignment
params.publish_dir = './results'
params.index = ""
params.metadata = ""
params.project = "Test"


include { setup_channel } from ('./libs/setup_channel')
/*
========================================================================================
    CONFIG FILES
========================================================================================
*/

ch_multiqc_config        = file("$projectDir/assets/multiqc_config.yaml", checkIfExists: true)

bsb_index = setup_channel(params.index, "BSB index", true, "")

meta = Channel.from(file(params.metadata))
                .splitCsv(header:true)
                .map{ row-> tuple("$row.sample"), file("$row.read1"), file("$row.read2") }
                .set{sample_ch}


include { FastQC }              from ('./process/FastQC')
include { Cutadapt }            from ('./process/Cutadapt')
include { Align }               from ('./process/Align')
include { CallMethylation }     from ('./process/CallMethylation')
include { MatrixBuilding }      from ('./process/MatrixBuilding')
include { Parse_GS }            from ('./process/parse_gs')
include { MultiQC }             from ('./process/MultiQC')

workflow { 
    FastQC(sample_ch)
    Cutadapt(sample_ch)
    Align(Cutadapt.out.trimmed, bsb_index.collect())
    CallMethylation(bsb_index.collect(), Align.out.bam)
    Parse_GS(Align.out.report.collect(), CallMethylation.out.report.collect())
    MatrixBuilding(CallMethylation.out.CGmap.collect())

    //
    // MODULE: MultiQC
    //
    if (!params.skip_multiqc) {
        ch_multiqc_files = Channel.empty()
        ch_multiqc_files = ch_multiqc_files.mix(Channel.from(ch_multiqc_config))
    }
    MultiQC(params.project, FastQC.out.report.collect(), Cutadapt.out.log.collect(), MatrixBuilding.out.matrix, ch_multiqc_files, Parse_GS.out.report.collect())
    }
