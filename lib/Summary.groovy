class Summary {
// Settings to show in MultiQC report
    private static def createMap(params, workflow, nextflow) {
        def summary = [:]
        summary['Genome']                    = params.genome
        summary['Adapter first read']        = params.adapter_first_read
        summary['Adapter second read']       = params.adapter_second_read
        summary['Alignment quality']         = params.alignment_quality
        summary['Base quality']              = params.base_quality 
        summary['Minimum read depth']        = params.minimum_read_depth 
        return summary
    }

    private static String multiqc(summary) {
        String items = summary
            .collect { k,v -> "<dt>$k</dt><dd><samp>${v ?: '<span style=\"color:#999999;\">N/A</a>'}</samp></dd>" }
            .join('\n'.padRight(5))
        String yaml = "id: 'summary'\n"
        yaml += "section_name: 'Workflow Summary'\n"
        yaml += "description: ' This information is collected when the pipeline is started.'\n"

        yaml += "plot_type: 'html'\n"
        yaml += "data: |\n"
        yaml += "  <dl class=\"dl-horizontal\" style=\"padding:19px\">\n"
        yaml += "    ${items}\n"
        yaml += "  </dl>"
    }

    private static String multiqc(params, workflow, nextflow) {
        def summary = createMap(params, workflow, nextflow)
        multiqc(summary)
    }
}