// FastQC

process FastQC {
    label "processLow"
    publishDir "$params.publish_dir/fastqc", mode: 'copy'
    // add tag here : cluster size small/medium/large/xlarge 
    container 'quay.io/biocontainers/fastqc:0.11.9--0'

    input:
    tuple val(sample), path(read1), path(read2)

    output:
    path "*_fastqc.{html,zip}"      , emit: report
    path "v_*.txt"                  , emit: version

    script:
    """
    fastqc --quiet $read1 $read2
    fastqc -v > v_Fastqc.txt
    """
}