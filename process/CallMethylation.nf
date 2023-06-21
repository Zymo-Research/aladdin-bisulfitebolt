// CallMethylation
params.base_quality         = 10
params.alignment_quality    = 20
params.minimum_read_depth   = 10
params.max_read_depth       = 8000

process CallMethylation {
    label "processHigh"
    publishDir "$params.outdir/CallMethylation", mode: 'copy'
    // add tag here : cluster size small/medium/large/xlarge 
    container = 'docker.io/xingaulag/aladdin-bsbolt:v0.0.1'

    input:
    path index
    tuple val(meta), path(bam)

    output:
    path "*.CGmap.gz"       , emit: CGmap
    // path "v_*.txt"          , emit: version
    path "*_report.txt"     , emit: report
    path "${meta.name}_CGmap_md5sum.txt", emit: md5sum

    script:
    """
    bsbolt CallMethylation -BQ ${params.base_quality} \
                            -DB $index \
                            -I ${meta.name}_rmdup.bam \
                            -MQ ${params.alignment_quality} \
                            -O ${meta.name} \
                            -ignore-ov \
                            -max ${params.max_read_depth} \
                            -min ${params.minimum_read_depth} \
                            -t $task.cpus > ${meta.name}_meth_report.txt
    
    md5sum ${meta.name}.CGmap.gz > ${meta.name}_CGmap_md5sum.txt

    """
}

// here -t is set at 8 :), so not 7 or 10 like other
