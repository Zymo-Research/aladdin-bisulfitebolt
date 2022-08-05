// MatrixBuilding

process MatrixBuilding {
    label "processLow"
    publishDir "${params.publish_dir}/MatrixBuilding", mode: 'copy'
    container = 'docker.io/thamlee2601/nxf-bsbolt:v1.0.4'
    
    input:
    path CGmap

    output:
    path "CGmap_matrix.txt"     , emit: matrix
    path "v_bsbolt.txt"         , emit: version

    script:
    """
    ls *.CGmap.gz > CGmap_list.txt
    bsbolt AggregateMatrix -F CGmap_list.txt -O CGmap_matrix.txt
    bsbolt -h | grep BiSulfite > v_bsbolt.txt
    """
}