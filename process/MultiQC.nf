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
    path "multiqc_custom_plugins"
    path ch_multiqc_files
    
    output:
    path "*"

    script:
    """
    cd multiqc_custom_plugins/
    python setup.py develop
    cd ../
    multiqc -f . --title $params.project
    """
}