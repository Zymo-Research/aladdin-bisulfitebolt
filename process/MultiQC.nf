// MultiQC

process MultiQC {
    publishDir "$params.publish_dir/MultiQC", mode: 'copy'
    container = 'docker.io/ewels/multiqc:latest'

    input:
    path fastqc
    tuple val(sample), path(log)
    tuple val(sample), path(bam)
    path CGmap
    path matrix
    
    output:
    path "*"

    script:
    """
    multiqc -f . --title $sample
    """
}