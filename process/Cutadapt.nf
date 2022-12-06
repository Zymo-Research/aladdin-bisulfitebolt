// Cutadapt

process Cutadapt {
    label "processMedium"
    publishDir "${params.outdir}/Cutadapt", mode: 'copy'
    container = 'quay.io/biocontainers/cutadapt:3.4--py37h73a75cf_1'

    input:
    tuple val(meta), path(reads)


    output:
    tuple val(meta), path("*_ca_{R1,R2}.fastq")   , emit: trimmed
    path('*.log')                                   , emit: log
    path "v_*.txt"                                  , emit: version

    script:
    """
    cutadapt -m 1 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -j 7 -o ${meta.name}_ca_R1.fastq -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT \
    -p ${meta.name}_ca_R2.fastq ${reads[0]} ${reads[1]} > ${meta.name}.cutadapt.log


    cutadapt --version > v_Cutadapt.txt
    """
}
