// #!/usr/bin/env nextflow

nextflow.enable.dsl = 2

//alignment
params.outdir = './results'
params.index = ""
params.design = ""
params.project = ""

def mqcPlugins = Channel.fromPath("${baseDir}/assets/multiqc_plugins/", checkIfExists: true)

include { setup_channel } from ('./libs/setup_channel')
include { createSummary; formatSummary; obj_to_json } from './libs/runSummary'

/*
 * COLLECT SUMMARY & LOG
 */

def summary = createSummary(params, workflow, nextflow)
log.info formatSummary(summary)
// Let's also save the summary to a file
def workflowLogFile="${params.outdir}/workflow.log"
def ch_workflow_log=Channel
                    .value(obj_to_json(summary))
                    .collectFile(name: workflowLogFile)

/*
========================================================================================
    CONFIG FILES
========================================================================================
*/

ch_multiqc_config        = file("$projectDir/assets/multiqc_config.yaml", checkIfExists: true)

bsb_index = setup_channel(params.index, "BSB index", true, "")
design = setup_channel(params.design, "design CSV file", true, "")
comparisons = setup_channel(params.comparisons, "comparison CSV file", false, "all pairwise comparisons will be carried out.")

//meta = Channel.from(file(params.design))
//                .splitCsv(header:true)
//               .map{ row-> tuple("$row.sample"), file("$row.read_1"), file("$row.read_2") }
//               .set{sample_ch}

include { parse_design }        from ('./libs/parse_design')
include { Check_design }        from ('./process/Check_design') addParams(
    ignore_R1: params.ignore_R1
)
include { FastQC }              from ('./process/FastQC')
include { Cutadapt }            from ('./process/Cutadapt')
include { Align }               from ('./process/Align')
include { CallMethylation }     from ('./process/CallMethylation')
include { MatrixBuilding }      from ('./process/MatrixBuilding')
include { Parse_GS }            from ('./process/Parse_gs')
include { MultiQC }             from ('./process/MultiQC')
include { Summarize_downloads } from ('./process/Summarize_downloads') addParams(
    publish_dir: "${params.outdir}/download_data"
)
include { Software_versions } from ('./process/Software_versions') addParams(
    publish_dir: "${params.outdir}/pipeline_info",
    pipeline_version: workflow.manifest.version,
    nextflow_version: workflow.nextflow.version
)

workflow { 
    // Check design file and set up channels
    Check_design(design, comparisons.ifEmpty([]))
    Check_design.out.checked_design
        .splitCsv( header: true )
        .map { parse_design(it, params.ignore_R1) }
        .set { reads } // Channel of [meta, reads]
    FastQC(reads)
    Cutadapt(reads)
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
    // Software versions
    versions = FastQC.out.version.first()
                   .mix(Cutadapt.out.version.first(), 
                        Align.out.version.first())
    Software_versions(versions.flatten().collect())
    Channel.empty()
        .mix(Channel
                 .value(Summary.multiqc(params, workflow, nextflow))
                 .collectFile(name: "workflow_summary_mqc.yaml"),
            FastQC.out.report.collect(), 
            Cutadapt.out.log.collect(), 
            MatrixBuilding.out.matrix, 
            ch_multiqc_files, 
            Parse_GS.out.report.collect(),
            Software_versions.out.report.collect()
            )
        .collect()
        .set { mqcLogs }

    MultiQC(params.project, mqcLogs, mqcPlugins)
    // Gather locations of files to download

    bam_locations    = Align.out.bamloca.map { "${params.outdir}/Align/" + it.getName() }
    gcmap_locations  = CallMethylation.out.CGmap.map { "${params.outdir}/CallMethylation/" + it.getName() }  
    matrix_locations = MatrixBuilding.out.matrix.map { "${params.outdir}/MatrixBuilding/" + it.getName() }                        
    report_locations = MultiQC.out.report.map { "${params.outdir}/MultiQC/" + it.getName() }
    bam_locations
        .mix(gcmap_locations, matrix_locations, report_locations)
        .collectFile(name: "${params.outdir}/download_data/file_locations.txt", newLine: true )
        .set { locations }

    // Save md5sum into one file
    Align.out.md5sum
        .mix(CallMethylation.out.md5sum, MatrixBuilding.out.md5sum, MultiQC.out.md5sum)
        .collectFile(name: "${params.outdir}/download_data/md5sum.txt", sort: { it.getName() } )
        .set { md5sums }

    // Parse the list of files for downloading into a JSON file
    Summarize_downloads( locations, md5sums, Check_design.out.checked_design )
    
    }
