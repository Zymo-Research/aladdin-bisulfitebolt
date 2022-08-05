// MultiQC

process MultiQC {
    label "processLow"
    publishDir "$params.publish_dir/MultiQC", mode: 'copy'
    container = 'docker.io/ewels/multiqc:latest'

    input:
    val project
    path fastqc
    path log
    tuple val(sample), path(bam)
    path align
    path matrix
    
    output:
    path "*"

    script:
    """
    multiqc -f . --title $params.project
    """
}