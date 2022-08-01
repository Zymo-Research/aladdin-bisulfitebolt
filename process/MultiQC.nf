// MultiQC

process MultiQC {
    publishDir "$params.publish_dir/MultiQC", mode: 'copy'

    input:
    path fastqc
    tuple val(sample), path(bam)
    path CGmap
    
    output:
    path "*"

    script:
    """
    multiqc -f . --title $sample
    """
}