// FastQC

process FastQC {
    publishDir "${params.publish_dir}/fastqc", mode: 'copy'

    input:
    val sample
    path read1
    path read2

    output:
    path "*_fastqc.{html,zip}", emit: report
    path "v_*.txt", emit: version

    script:
    """
    fastqc --quiet $read1
    fastqc --quiet $read2
    fastqc -v > v_Fastqc.txt
    """
}