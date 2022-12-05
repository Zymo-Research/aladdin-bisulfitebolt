// MultiQC

process MultiQC {
    label "processLow"
    publishDir "$params.publish_dir/MultiQC", mode: 'copy'
    container = 'docker.io/xingaulag/bsbolt:latest'

    input:
    val project
    path fastqc
    path log
    path matrix
    path ch_multiqc_files
    path parse
    path "multiqc_custom_plugins"
    
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