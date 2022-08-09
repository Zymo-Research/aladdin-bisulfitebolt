// Alignment

process Align {
    label "processHigh"
    publishDir "$params.publish_dir/align", mode: 'copy'
    // add tag here : cluster size small/medium/large/xlarge 
    container = 'docker.io/thamlee2601/nxf-bsbolt:v1.0.4'

    input:
    tuple val(sample), path(trimmed)
    path index

    output:
    tuple val(sample), path("*.sorted.{bam,bai}")   , emit: bam
    path "v_*.txt"                                  , emit: version
    path "*_report.txt"                             , emit: report

    script:
    """
    bsbolt Align -A 1 -B 4 -CP 0.5 -CT 5 -D 0.5 \
                    -DB $index \
                    -DR 0.95 -E 1,1 \
                    -F1 ${sample}_ca_R1.fastq \
                    -F2 ${sample}_ca_R2.fastq \
                    -INDEL 6,6 -L 30,30 -O $sample \
                    -OT 2 -SP 0.1 -T 10 -U 17 -XA 100,200 -c 50 -d 100 -k 25 \
                    -m 50 -r 1.5 -t $task.cpus -w 100 -y 20 > ${sample}_align_report.txt

    samtools fixmate -p -m ${sample}.bam ${sample}.fixmates.bam
    samtools sort -@ $task.cpus -O BAM -o ${sample}.sorted.bam ${sample}.fixmates.bam
    samtools markdup ${sample}.sorted.bam ${sample}.dup.bam
    samtools index ${sample}.dup.bam

    bsbolt -h | grep BiSulfite > v_bsbolt.txt
    samtools --version > v_samtools.txt

    """
}
// bsbolt align was run with -T 10, whilse samtools sort run with -@ 7 :), suggest to maintain consistency via $task.cpus
// Probably need some documentation later about what params did what ?
