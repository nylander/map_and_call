process callability_filter {
    tag "vcf_depth_filter_sample"
    conda "${moduleDir}/environment.yml"
    label "thin_medium"

    input:
    tuple val(region_id), val(region), path(vcf), path(csi), val(sample), path(callable_regions)

    output:
    tuple val(region_id), val(sample), path("${sample}_${region_id}.dp.filtered.vcf.gz"), path("${sample}_${region_id}.dp.filtered.vcf.gz.*"), emit: vcf

    script:
    def chrom = region.split(":")[0]
    def startpos = region.split(":")[1].split("-")[0].toInteger() - 1
    def endpos = region.split(":")[1].split("-")[1].toInteger()
    """
    # extract only the focal sample
    bcftools view -s ${sample} -Oz -o ${sample}_${region_id}.vcf.gz ${vcf}
    bcftools index ${sample}_${region_id}.vcf.gz
    # grab the callable regions from the specific region
    echo -e ${chrom}"\t"${startpos}"\t"${endpos} > tmp.${sample}.${region_id}.bed
    bedtools intersect -a ${callable_regions} -b tmp.${sample}.${region_id}.bed > tmp.${sample}.${region_id}.callable.bed

    # keep only genotypes that are within the callable regions
    bcftools view -R tmp.${sample}.${region_id}.callable.bed -Oz -o ${sample}_${region_id}.dp.filtered.vcf.gz ${sample}_${region_id}.vcf.gz
    bcftools index ${sample}_${region_id}.dp.filtered.vcf.gz
    
    """

    stub:
    """
    touch ${sample}_${region_id}.dp.filtered.vcf.gz
    touch ${sample}_${region_id}.dp.filtered.vcf.gz.csi
    """
}
