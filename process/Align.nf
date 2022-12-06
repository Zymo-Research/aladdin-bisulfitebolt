// Alignment

process Align {
    label "processHigh"
    publishDir "$params.outdir/Align", mode: 'copy'
    // add tag here : cluster size small/medium/large/xlarge 
    container = 'docker.io/thamlee2601/nxf-bsbolt:v1.0.4'

    input:
    tuple val(meta), path(trimmed)
    path index

    output:
    tuple val(meta), path("*_rmdup.bam"), path("*.bai")  , emit: bam
    path("*_rmdup.bam"), emit: bamloca
    //tuple val(meta), path("*.rmdup.bam") , emit: bam
    path "v_*.txt"                                  , emit: version
    path "*_report.txt"                             , emit: report
    path "${meta.name}_bam_md5sum.txt", emit: md5sum

    script:
    """
    bsbolt Align -DB $index \
                -F1 ${meta.name}_ca_R1.fastq \
                -F2 ${meta.name}_ca_R2.fastq \
                -O ${meta.name} > ${meta.name}_align_report.txt

    samtools fixmate -p -m ${meta.name}.bam ${meta.name}.fixmates.bam
    samtools sort -@ $task.cpus -O BAM -o ${meta.name}.sorted.bam ${meta.name}.fixmates.bam
    samtools markdup ${meta.name}.sorted.bam ${meta.name}_rmdup.bam
    samtools index ${meta.name}_rmdup.bam
    md5sum ${meta.name}_rmdup.bam > ${meta.name}_bam_md5sum.txt

    bsbolt -h | grep BiSulfite > v_bsbolt.txt
    samtools --version > v_samtools.txt

    """
}
// bsbolt align was run with -T 10, whilse samtools sort run with -@ 7 :), suggest to maintain consistency via $task.cpus
// Probably need some documentation later about what params did what ?
