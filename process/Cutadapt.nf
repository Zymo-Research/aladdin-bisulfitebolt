// Cutadapt
params.adapter_first_read   = "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA"
params.adapter_second_read  = "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"
params.minimum_length       = 1
params.cores                = 7

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
    cutadapt -m ${params.minimum_length} -a ${params.adapter_first_read} -j ${params.cores} -o ${meta.name}_ca_R1.fastq -A ${params.adapter_second_read} \
    -p ${meta.name}_ca_R2.fastq ${reads[0]} ${reads[1]} > ${meta.name}.cutadapt.log
    cutadapt --version > v_Cutadapt.txt
    """
}
