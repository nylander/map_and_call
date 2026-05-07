
process freebayes{
    tag "freebayes_${region_id}"
    conda "${moduleDir}/environment.yml"

    //publishDir "${params.outdir}/sample_vcfs", mode: 'copy'

    input:
    tuple path(cram), path(crai), path(reference), path(reference_indices), val(region_id), val(regions), val(pops)

    output:
    tuple val(region_id), path("freebayes.region-${region_id}.vcf.gz"), path("freebayes.region-${region_id}.vcf.gz.csi"), emit: vcf
    
    script:
    """
    # Create popfile from the Groovy-generated string
    
    echo -e "${pops.join('\n')}" | sed 's/=/\t/' > freebayes_popfile.txt

    # freebayes uses 0-based coordinates, so we need to convert the regions from 1-based to 0-based
    chrom=\$(echo ${regions} | cut -d: -f1)
    start=\$(echo ${regions} | cut -d: -f2 | cut -d- -f1)
    end=\$(echo ${regions} | cut -d: -f2 | cut -d- -f2)
    start_0_based=\$((start - 1))
    regions_0_based="\${chrom}:\${start_0_based}-\${end}"

    freebayes -f ${reference} -r \${regions_0_based} --populations freebayes_popfile.txt --min-mapping-quality ${params.min_mapqual} --min-base-quality ${params.min_basequal} --ploidy ${params.ploidy} ${cram} | bgzip - > freebayes.region-${region_id}.vcf.gz
    bcftools index freebayes.region-${region_id}.vcf.gz
    """

    stub:
    """
    touch freebayes.region-${region_id}.vcf.gz
    touch freebayes.region-${region_id}.vcf.gz.csi

    """

}