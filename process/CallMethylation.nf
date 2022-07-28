// CallMethylation

process CallMethylation {
    publishDir "${params.publish_dir}/CallMethylation", mode: 'copy'

    input:
    val sample
    path index
    path bam

    output:
    path "*", emit: CGmap
    path "v_*.txt", emit: version

    script:
    """
    bsbolt CallMethylation -BQ 10 -DB $index \
    -I $bam -MQ  20 -O $sample \
    -ignore-ov -max 8000 -min 10 -t 8

    bsbolt -h | grep BiSulfite > v_bsbolt.txt
    """
}