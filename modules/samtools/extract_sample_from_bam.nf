process extract_sample_from_bam {
    tag "$bam"
    label 'process_low'
    conda "${moduleDir}/environment.yml"

    input:
    path bam

    output:
    stdout emit: sample_id

    script:
    """
    # Extract sample ID from BAM read group (SM tag)
    samtools view -H ${bam} | grep '^@RG' | head -n 1 | sed 's/.*SM:\\([^\\t]*\\).*/\\1/' | tr -d '\\n'
    """

    stub:
    """
    echo -n "SAMPLE_${bam.baseName}"
    """
}

