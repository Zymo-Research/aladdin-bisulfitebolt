// MultiQC

process MultiQC {
    label "processLow"
    publishDir "$params.outdir/MultiQC", mode: 'copy'
    container = 'docker.io/xingaulag/bsbolt:latest'

    input:
    val project
    path mqcLogs
    path "multiqc_custom_plugins"
    
    output:
    path "*"
    path "*multiqc_report.html", emit: report
    path "multiqc_report_md5sum.txt", emit: md5sum

    script:
    """
    cd multiqc_custom_plugins/
    python setup.py develop
    cd ../
    multiqc -f . --title $params.project
    md5sum ${params.project}_multiqc_report.html > multiqc_report_md5sum.txt
    """
}