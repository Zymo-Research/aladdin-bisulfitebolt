process MatrixBuilding {
    publishDir "${params.publish_dir}/MatrixBuilding", mode: 'copy'
    container = 'docker.io/thamlee2601/bsbolt:v1.0.3'
    
    input:
    path CGmap

    output:
    path "CGmap_matrix.txt"    , emit: matrix
    path "v_bsbolt.txt"     , emit: version

    script:
    """
    #cp DogWolf00108.CGmap.gz DogWolf00108_2.CGmap.gz
    ls *.CGmap.gz > CGmap_list.txt
    bsbolt AggregateMatrix -F CGmap_list.txt -O CGmap_matrix.txt
    bsbolt -h | grep BiSulfite > v_bsbolt.txt
    """
}