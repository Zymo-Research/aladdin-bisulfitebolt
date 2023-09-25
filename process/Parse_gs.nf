// MultiQC

process Parse_GS {
    publishDir "$params.outdir/gs_table", mode: 'copy'
    container = 'docker.io/bioinforpi/aladdin-bsbolt:v1.0.0'
    
    input:
    path(align)
    path(meth)
    
    output:
    path "*_gs_mqc.txt" , emit: report

    script:
    """
    parse_bsbolt.py $align
    parse_bsbolt.py $meth

    """
}