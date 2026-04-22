// Process to concatenate readpairs stemming from the same library, prior to deduplication.

process concat_reads {
    tag "$sample_id"
    conda "${moduleDir}/environment.yml"

    input:
    tuple val(sample_id), val(lane), val(library), path(forward_reads), path(reverse_reads)
    
    output:
    tuple val(sample_id), val(lane), val(library), path("${sample_id}_${lane}_${library}_concat_R1.fastq.gz"), path("${sample_id}_${lane}_${library}_concat_R2.fastq.gz"), emit: dedup_reads

    script:
    """
    cat ${forward_reads} > ${sample_id}_${lane}_${library}_concat_R1.fastq.gz
    cat ${reverse_reads} > ${sample_id}_${lane}_${library}_concat_R2.fastq.gz
    """

    stub:
    """
    touch ${sample_id}_${lane}_${library}_concat_R1.fastq.gz
    touch ${sample_id}_${lane}_${library}_concat_R2.fastq.gz
    """
}