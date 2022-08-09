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

### ANNOTATE VARIANT SITES
ml -* Java/15.0.2
java -jar ~/snpEff/snpEff.jar Arabidopsis_thaliana -v arabidopsisThalianaJointGenotypes_variant_filtered_Chr$SLURM_ARRAY_TASK_ID.vcf.gz > arabidopsisThalianaJointGenotypes_variant_filtered_annotated_Chr$SLURM_ARRAY_TASK_ID.vcf

### SIFT OUT NONSYNONYMOUS SITES ###
#Extract sites with missense variants, but keep invariant sites too
echo Filtering out missense variants...
# ml -* Java/15.0.2
java -jar ~/snpEff/SnpSift.jar filter "( ANN[*].EFFECT has 'missense_variant' )" arabidopsisThalianaJointGenotypes_variant_filtered_annotated_Chr$SLURM_ARRAY_TASK_ID.vcf > arabidopsisThalianaJointGenotypes_missense_Chr$SLURM_ARRAY_TASK_ID.vcf

echo Compressing and indexing missense variants...
ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0
bgzip arabidopsisThalianaJointGenotypes_missense_Chr$SLURM_ARRAY_TASK_ID.vcf
tabix arabidopsisThalianaJointGenotypes_missense_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

# combine missense and invariant sites into one file for pixy
echo Combining missense and invariant sites...
ml -* GCC/10.2.0 BCFtools/1.11
bcftools concat \
--allow-overlaps \
arabidopsisThalianaJointGenotypes_missense_Chr$SLURM_ARRAY_TASK_ID.vcf.gz arabidopsisThalianaJointGenotypes_invariant_filtered_Chr$SLURM_ARRAY_TASK_ID.vcf.gz \
-O z -o arabidopsisThalianaJointGenotypes_missenseAndInvariant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

# index
echo Indexing combined file...
ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0
tabix arabidopsisThalianaJointGenotypes_missenseAndInvariant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

### SIFT OUT SYNONYMOUS SITES ###
#Extract sites with synonymous variants, but keep invariant sites too
echo Filtering out synonymous variants...
ml -* Java/15.0.2
java -jar ~/snpEff/SnpSift.jar filter "( ANN[*].EFFECT has 'synonymous_variant' )" arabidopsisThalianaJointGenotypes_variant_filtered_annotated_Chr$SLURM_ARRAY_TASK_ID.vcf > arabidopsisThalianaJointGenotypes_synonymous_Chr$SLURM_ARRAY_TASK_ID.vcf

echo Compressing and indexing synonymous variants... 
ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0
bgzip arabidopsisThalianaJointGenotypes_synonymous_Chr$SLURM_ARRAY_TASK_ID.vcf
tabix arabidopsisThalianaJointGenotypes_synonymous_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

# combine synonymous and invariant sites into one file for pixy
echo Combining synonymous and invariant sites...
ml -* GCC/10.2.0 BCFtools/1.11
bcftools concat \
--allow-overlaps \
arabidopsisThalianaJointGenotypes_synonymous_Chr$SLURM_ARRAY_TASK_ID.vcf.gz arabidopsisThalianaJointGenotypes_invariant_filtered_Chr$SLURM_ARRAY_TASK_ID.vcf.gz \
-O z -o arabidopsisThalianaJointGenotypes_synonymousAndInvariant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz

# index
echo Indexing combined file...
ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0
tabix arabidopsisThalianaJointGenotypes_synonymousAndInvariant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz
