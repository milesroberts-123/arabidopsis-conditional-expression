#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=25G
#SBATCH --array=1-5
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

### FILTER VARIANT SITES ###
ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 GATK/4.1.4.1-Python-3.6.6

#Label variants with the filters they don't pass
gatk VariantFiltration \
-R Athaliana_447_TAIR10.fa \
-O arabidopsisThalianaJointGenotypes_variant_annot_Chr$SLURM_ARRAY_TASK_ID.vcf.gz \
-V arabidopsisThalianaJointGenotypes_variant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz \
--filter-name "QD2" \
--filter-expression "QD < 2.0" \
--filter-name "QUAL30" \
--filter-expression "QUAL < 30.0" \
--filter-name "MQ40" \
--filter-expression "MQ < 40.00" \
--filter-name "FS60" \
--filter-expression "FS > 60.0" \
--filter-name "HaplotypeScore13" \
--filter-expression "HaplotypeScore > 13.0" \
--filter-name "MQRankSum" \
--filter-expression "MQRankSum < -12.5" \
--filter-name "ReadPosRankSum" \
--filter-expression "ReadPosRankSum < -8.0" \

# Remove variants that don't pass GATK filters, indels, variants with lots of missing calls, and non-genic variants
ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0
vcftools --gzvcf arabidopsisThalianaJointGenotypes_variant_annot_Chr$SLURM_ARRAY_TASK_ID.vcf.gz \
--remove-filtered-all \
--remove-indels \
--min-meanDP 10 \
--max-meanDP 75 \
--min-alleles 2 \
--max-alleles 2 \
--max-missing 0.8 \
--recode \
--recode-INFO-all \
--stdout | bgzip -c > arabidopsisThalianaJointGenotypes_variant_filtered_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

# index filtered variants
tabix arabidopsisThalianaJointGenotypes_variant_filtered_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

### FILTER INVARIANT SITES ###
# Remove invariant sites with a high quality score, because QUAL scores indiciate confidence of there being variation at a site
ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 GATK/4.1.4.1-Python-3.6.6
gatk VariantFiltration \
-R Athaliana_447_TAIR10.fa \
-O arabidopsisThalianaJointGenotypes_invariant_annot_Chr$SLURM_ARRAY_TASK_ID.vcf.gz \
-V arabidopsisThalianaJointGenotypes_invariant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz \
--filter-name "QUALabove100" \
--filter-expression "QUAL > 100.0" \

ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0
vcftools --gzvcf arabidopsisThalianaJointGenotypes_invariant_annot_Chr$SLURM_ARRAY_TASK_ID.vcf.gz \
--remove-filtered-all \
--min-meanDP 10 \
--max-meanDP 75 \
--max-missing 0.8 \
--recode \
--recode-INFO-all \
--stdout | bgzip -c > arabidopsisThalianaJointGenotypes_invariant_filtered_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

# index invariant sites
tabix arabidopsisThalianaJointGenotypes_invariant_filtered_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

### COMBINE FILTERED INVARIANT AND VARIANT SITES ###
# combine the two VCFs using bcftools concat
ml -* GCC/10.2.0 BCFtools/1.11
bcftools concat \
--allow-overlaps \
arabidopsisThalianaJointGenotypes_variant_filtered_Chr$SLURM_ARRAY_TASK_ID.vcf.gz arabidopsisThalianaJointGenotypes_invariant_filtered_Chr$SLURM_ARRAY_TASK_ID.vcf.gz \
-O z -o arabidopsisThalianaJointGenotypes_variantAndInvariant_filtered_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0
tabix arabidopsisThalianaJointGenotypes_variantAndInvariant_filtered_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

### ALLELE COUNTS FOR ALL SITES ###
# Will be used to calculate watterson's theta and Tajima's D
vcftools --gzvcf arabidopsisThalianaJointGenotypes_variant_filtered_Chr$SLURM_ARRAY_TASK_ID.vcf.gz --counts2 --out arabidopsisThalianaJointGenotypes_variant_filtered_Chr$SLURM_ARRAY_TASK_ID
