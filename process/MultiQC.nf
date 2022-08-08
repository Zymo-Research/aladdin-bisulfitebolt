// MultiQC

process MultiQC {
    label "processLow"
    publishDir "$params.publish_dir/MultiQC", mode: 'copy'
    container = 'docker.io/ewels/multiqc:latest'

    input:
    val project
    path fastqc
    path log
    path matrix
    path ch_multiqc_files
    path parse
    
    output:
    path "*"

    script:
    """
    multiqc -f . --title $params.project
    """
}