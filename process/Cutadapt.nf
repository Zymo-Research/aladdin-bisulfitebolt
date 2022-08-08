// Cutadapt

process Cutadapt {
    label "processMedium"
    publishDir "${params.publish_dir}/Cutadapt", mode: 'copy'
    container = 'quay.io/biocontainers/cutadapt:3.4--py37h73a75cf_1'

    input:
    tuple val(sample), path(read1), path(read2)


    output:
    tuple val(sample), path("*_ca_{R1,R2}.fastq")   , emit: trimmed
    path('*.log')                                   , emit: log
    path "v_*.txt"                                  , emit: version

    script:
    """
    cutadapt -m 1 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -j 7 -o ${sample}_ca_R1.fastq -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -p ${sample}_ca_R2.fastq $read1 $read2 > ${sample}.cutadapt.log


    cutadapt --version > v_Cutadapt.txt
    """
}
