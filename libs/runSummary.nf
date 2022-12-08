// show terminal screen
def createSummary(params, worflow, nextflow) {
    def summary = [:]
    def run_name = params.project
    if (!(workflow.runName ==~ /[a-z]+_[a-z]+/)) {
        run_name = workflow.runName
    }
    summary['Nextflow Version'] = "${nextflow.version}"
    summary['Run Name']         = run_name ?: workflow.runName
    summary['Index']            = params.index
    return summary
}

def formatSummary(summary) {
    def output = summary.collect { k,v -> "${k.padRight(17)}: $v" }.join("\n")
}

import groovy.json.JsonOutput
// object to json-format string
def obj_to_json(obj) {

    def json_str = JsonOutput.prettyPrint(JsonOutput.toJson(obj))
    return json_str
}
