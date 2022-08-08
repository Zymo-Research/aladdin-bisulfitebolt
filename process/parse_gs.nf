// MultiQC

process Parse_GS {
    label "processLow"
    publishDir "$params.publish_dir/gs_table", mode: 'copy'

    container = 'docker.io/thamlee2601/nxf-bsbolt:v1.0.4'


    input:
    path(align)
    path(meth)
    
    output:
    path "*_gs_mqc.txt" , emit: report

    script:
    """
    python3 $baseDir/bin/parse_bsbolt.py $align
    python3 $baseDir/bin/parse_bsbolt.py $meth

    """
}