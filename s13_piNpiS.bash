#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=1G
#SBATCH --array=1-5
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Load VCFtools to use tabix
conda activate pixy
ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 VCFtools/0.1.15-Perl-5.28.0

#Measure pi looking at all sites
pixy --stats pi --n_cores $SLURM_CPUS_PER_TASK --vcf arabidopsisThalianaJointGenotypes_variantAndInvariant_filtered_Chr$SLURM_ARRAY_TASK_ID.vcf.gz --populations arabidopsisThalianaPopulations.txt --bed_file arabidopsis_thaliana_genes_overlapping_Chr$SLURM_ARRAY_TASK_ID.bed --output_prefix pixy_allSites_Chr$SLURM_ARRAY_TASK_ID

#Measure pi using only missense and invariant sites
pixy --stats pi --n_cores $SLURM_CPUS_PER_TASK --vcf arabidopsisThalianaJointGenotypes_missenseAndInvariant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz --populations arabidopsisThalianaPopulations.txt --bed_file arabidopsis_thaliana_genes_overlapping_Chr$SLURM_ARRAY_TASK_ID.bed --output_prefix pixy_missenseAndInvariant_Chr$SLURM_ARRAY_TASK_ID

#Measure pi using only synonymous and invariant sites
pixy --stats pi --n_cores $SLURM_CPUS_PER_TASK --vcf arabidopsisThalianaJointGenotypes_synonymousAndInvariant_Chr$SLURM_ARRAY_TASK_ID.vcf.gz --populations arabidopsisThalianaPopulations.txt --bed_file arabidopsis_thaliana_genes_overlapping_Chr$SLURM_ARRAY_TASK_ID.bed --output_prefix pixy_synonymousAndInvariant_Chr$SLURM_ARRAY_TASK_ID