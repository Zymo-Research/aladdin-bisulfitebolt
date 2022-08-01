// Alignment


process Align {
    publishDir "${params.publish_dir}/align", mode: 'copy'
    container = 'docker.io/thamlee2601/bsbolt:v1.0.3'

    input:
    val sample
    path index
    path read1
    path read2

    output:
    path "*.sorted.{bam,bai}", emit: bam
    path "v_*.txt", emit: version

    script:
    """
    bsbolt Align -A 1 -B 4 -CP 0.5 -CT 5 -D 0.5 \
        -DB $index \
        -DR 0.95 -E 1,1 \
        -F1 $read1 \
        -F2 $read2 \
        -INDEL 6,6 -L 30,30 -O $sample \
        -OT 2 -SP 0.1 -T 10 -U 17 -XA 100,200 -c 50 -d 100 -k 25 \
        -m 50 -r 1.5 -t 7 -w 100 -y 20

    samtools fixmate -p -m ${sample}.bam ${sample}.fixmates.bam
    samtools sort -@ 7 -O BAM -o ${sample}.sorted.bam ${sample}.fixmates.bam
    samtools markdup ${sample}.sorted.bam ${sample}.dup.bam
    samtools index ${sample}.dup.bam

    bsbolt -h | grep BiSulfite > v_bsbolt.txt
    samtools --version > v_samtools.txt

    """
}
