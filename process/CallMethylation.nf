// CallMethylation

process CallMethylation {
    label "processHigh"
    publishDir "$params.publish_dir/CallMethylation", mode: 'copy'
    // add tag here : cluster size small/medium/large/xlarge 
    container = 'docker.io/thamlee2601/nxf-bsbolt:v1.0.4'

    input:
    path index
    tuple val(sample), path(bam)

    output:
    path "*.CGmap.gz"       , emit: CGmap
    path "v_*.txt"          , emit: version
    path "*_report.txt"     , emit: report

    script:
    """
    bsbolt CallMethylation -BQ 10 \
                            -DB $index \
                            -I ${bam} \
                            -MQ 20 \
                            -O ${sample} \
                            -ignore-ov \
                            -max 8000 \
                            -min 10 \
                            -t $task.cpus > ${sample}_meth_report.txt
    bsbolt -h | grep BiSulfite > v_bsbolt.txt
    """
}

// here -t is set at 8 :), so not 7 or 10 like other
