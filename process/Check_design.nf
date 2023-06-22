params.ignore_R1 = false

// Sanity check design file
process Check_design {
    tag "$design"
    container = 'docker.io/xingaulag/aladdin-bsbolt:v0.0.2'
    
    input:
    path design
    path comparisons

    output:
    path "checked_${design}", emit: checked_design

    script:
    comparison_file = params.comparisons ? "-c $comparisons" : ''
    ignorer1 = params.ignore_R1 ? "--ignore_r1" : "--no_ignore_r1"
    """
    check_design.py $comparison_file $ignorer1 $design
    """
}