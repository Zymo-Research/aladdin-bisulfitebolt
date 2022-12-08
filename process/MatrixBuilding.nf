// MatrixBuilding

process MatrixBuilding {
    label "processLow"
    publishDir "${params.outdir}/MatrixBuilding", mode: 'copy'
    container = 'docker.io/thamlee2601/nxf-bsbolt:v1.0.4'

    input:
    path CGmap

    output:
    path "CGmap_matrix.txt"     , emit: matrix
    // path "v_bsbolt.txt"         , emit: version
    path "Matrix_CGmap_md5sum.txt", emit: md5sum

    script:
    """
    ls *.CGmap.gz > CGmap_list.txt
    bsbolt AggregateMatrix -F CGmap_list.txt -O CGmap_matrix.txt
    md5sum CGmap_matrix.txt > Matrix_CGmap_md5sum.txt
    """
}