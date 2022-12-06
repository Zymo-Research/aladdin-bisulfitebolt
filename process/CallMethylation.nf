// CallMethylation

process CallMethylation {
    label "processHigh"
    publishDir "$params.outdir/CallMethylation", mode: 'copy'
    // add tag here : cluster size small/medium/large/xlarge 
    container = 'docker.io/thamlee2601/nxf-bsbolt:v1.0.4'

    input:
    path index
    tuple val(meta), path(bam)

    output:
    path "*.CGmap.gz"       , emit: CGmap
    path "v_*.txt"          , emit: version
    path "*_report.txt"     , emit: report
    path "${meta.name}_CGmap_md5sum.txt", emit: md5sum

    script:
    """
    bsbolt CallMethylation -BQ 10 \
                            -DB $index \
                            -I ${meta.name}_rmdup.bam \
                            -MQ 20 \
                            -O ${meta.name} \
                            -ignore-ov \
                            -max 8000 \
                            -min 10 \
                            -t $task.cpus > ${meta.name}_meth_report.txt
    
    md5sum ${meta.name}.CGmap.gz > ${meta.name}_CGmap_md5sum.txt

    bsbolt -h | grep BiSulfite > v_bsbolt.txt
    """
}

// here -t is set at 8 :), so not 7 or 10 like other
