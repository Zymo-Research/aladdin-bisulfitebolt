// Gather software versions
params.publish_dir = "pipeline_info"

process Software_versions {
    label 'no_cache'
    publishDir "${params.publish_dir}", mode: 'copy',
        saveAs: { it == "software_versions.csv" ? it : null }
    container = 'docker.io/xingaulag/aladdin-bsbolt:v0.0.1'
    
    input:
    path version_files

    output:
    path 'software_versions_mqc.yaml', emit: report
    path 'software_versions.csv'

    script:
    """
    echo $params.pipeline_version > v_pipeline.txt
    echo $params.nextflow_version > v_nextflow.txt
    software_versions.py > software_versions_mqc.yaml
    """
}