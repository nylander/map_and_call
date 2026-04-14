# map_and_varcall

Mapping and variant calling pipeline developed to handle everything from raw fastq read input files, to filtered SNPs and indels ready for analysis. The pipeline is built using Nextflow and handles all dependencies internally using conda environments. It was designed specifically for smooth running on the Dardel (the compute cluster currently most frequenctly used at the Swedish Museum of Natural History), but should be easy enough to adapt to other environments.

# Quick start on dardel

1. Clone the repository to a suitable place in your dardel project, and navigate to the directory:

    git clone XZY
    cd map_and_call

2. Prepare an input samplesheet with one row per sequence pair, and four columns:
    datatype;sample_id;fastq1.fq.gz;fastq2.fq.gz,
    where datatype is either 1 for modern sequencing data, or 2 for historical dna (expecting shorter reads and more damage). If one sample was sequenced more than once (several lanes or libraries), simply add multiple rows for the same sample_id, with the different fastq files, and the pipeline will handle merging per sample after mapping. An example of a samplesheet row:
    1;Sample1;reads/Sample1_lane1_R1.fastq.gz;reads/Sample1_lane1_R2.fastq.gz

3. Edit the relevant parameters in the dardel_wrapper.sh slurm script:
    - Project ID to use for submitting jobs to slurm
    - Path to the reference genome (could be gzipped) to be used for mapping and variant calling
    - Optionally give the output a more informative name than "output"
    - (A bunch of more "advanced" parameters are customizable in the nextflow.config file)

4. Submit the pipeline to slurm using the dardel_wrapper.sh script:

    sbatch dardel_wrapper.sh