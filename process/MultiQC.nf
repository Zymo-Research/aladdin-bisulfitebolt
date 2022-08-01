// MultiQC

process MultiQC {
    publishDir "${params.publish_dir}/MultiQC", mode: 'copy'
    container "docker.io/xingaulag/pi-visualization:latest"
    
    input:
    val title
    path fastqc
    path bam
    path CGmap
    
    output:
    path "*.html"

    script:
    """
    multiqc -f . --title $title
    """
}