// FastQC before trimming
process FastQC {
    tag "${meta.name}"
    label "processLow"
    publishDir "$params.outdir/Fastqc", mode: 'copy'
    container 'quay.io/biocontainers/fastqc:0.11.9--0'

    input:
    tuple val(meta), path(reads)

    output:
    path '*_fastqc.{zip,html}', emit: report
    path 'v_fastqc.txt', emit: version

    script:
    if (meta.single_end) {
        """
        fastqc --version &> v_fastqc.txt
        [ ! -f  ${meta.name}_R1.fastq.gz ] && ln -s $reads ${meta.name}_R1.fastq.gz
        fastqc --quiet --threads $task.cpus ${meta.name}_R1.fastq.gz
        """
    } else {
        """
        fastqc --version &> v_fastqc.txt
        [ ! -f  ${meta.name}_R1.fastq.gz ] && ln -s ${reads[0]} ${meta.name}_R1.fastq.gz
        [ ! -f  ${meta.name}_R2.fastq.gz ] && ln -s ${reads[1]} ${meta.name}_R2.fastq.gz
        fastqc --quiet --threads $task.cpus ${meta.name}_R1.fastq.gz
        fastqc --quiet --threads $task.cpus ${meta.name}_R2.fastq.gz
        """
    }
}