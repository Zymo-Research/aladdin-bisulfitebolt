process Cutadapt {
    publishDir "${params.publish_dir}/Cutadapt", mode: 'copy'
    container = 'quay.io/biocontainers/cutadapt:3.4--py37h73a75cf_1'

    input:
    path read1
    path read2

    output:
    path('DogWolf00108_ca_R1.fastq'), emit: read1
    path('DogWolf00108_ca_R2.fastq'), emit: read2

    script:
    """
    cutadapt -m 1 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -j 7 -o DogWolf00108_ca_R1.fastq -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -p DogWolf00108_ca_R2.fastq $read1 $read2


    cutadapt --version > v_Cutadapt.txt
    """
}
