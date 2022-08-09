#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=50G
#SBATCH --array=1-5
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Load VCF tools
ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0

### SEPARATE VARIANT AND INVARIANT STIES ###
# invariant and variants sites must be filtered seperately becasuse QUAL scores aren't always given to invariant sites
# only invariant sites
vcftools --gzvcf arabidopsisThalianaJointGenotypes_CDSonly_Chr$SLURM_ARRAY_TASK_ID.vcf.gz \
--max-maf 0 \
--recode --stdout | bgzip -c > arabidopsisThalianaJointGenotypes_invariant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

tabix arabidopsisThalianaJointGenotypes_invariant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

# only variant sites
vcftools --gzvcf arabidopsisThalianaJointGenotypes_CDSonly_Chr$SLURM_ARRAY_TASK_ID.vcf.gz \
--mac 1 \
--recode --stdout | bgzip -c > arabidopsisThalianaJointGenotypes_variant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

tabix arabidopsisThalianaJointGenotypes_variant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

### STATISTICS FOR INDIVIDUALS ###
VCF="arabidopsisThalianaJointGenotypes_CDSonly_Chr$SLURM_ARRAY_TASK_ID.vcf.gz"
OUT="arabidopsisThalianaJointGenotypes_CDSonly_Chr$SLURM_ARRAY_TASK_ID"
echo Calculating statistics for $VCF and storing in $OUT...

# mean depth per individual
vcftools --gzvcf $VCF --depth --out $OUT

# proportion missing data per individual
# vcftools --gzvcf $VCF --missing-indv --out $OUT

# heterozygosity and inbreeding coefficient per individual
# vcftools --gzvcf $VCF --het --out $OUT

### STATISTICS FOR VARIANT SITES ### 
VARIANT_VCF="arabidopsisThalianaJointGenotypes_variant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz"
OUT="arabidopsisThalianaJointGenotypes_variant_Chr$SLURM_ARRAY_TASK_ID"
echo Calculating statistics for $VARIANT_VCF and storing in $OUT...

# allele frequencies
# vcftools --gzvcf $VARIANT_VCF --freq2 --out $OUT

# site mean depth
vcftools --gzvcf $VARIANT_VCF --site-mean-depth --out $OUT

# site quality
vcftools --gzvcf $VARIANT_VCF --site-quality --out $OUT

# proportion missing data per site
vcftools --gzvcf $VARIANT_VCF --missing-site --out $OUT

# hardy weinberg equilibrium test p-values per site
# vcftools --gzvcf $VARIANT_VCF --hardy --out $OUT

### STATISTICS FOR INVARIANT SITES ###
INVARIANT_VCF="arabidopsisThalianaJointGenotypes_invariant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz"
OUT="arabidopsisThalianaJointGenotypes_invariant_Chr$SLURM_ARRAY_TASK_ID"
echo Calculating statistics for $INVARIANT_VCF and storing in $OUT...

# site mean depth
vcftools --gzvcf $INVARIANT_VCF --site-mean-depth --out $OUT

# site quality
vcftools --gzvcf $INVARIANT_VCF --site-quality --out $OUT

# proportion missing data per site
vcftools --gzvcf $INVARIANT_VCF --missing-site --out $OUT

