#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=32G
#SBATCH --array=1-5
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

ml -* GCC/8.3.0 BEDTools/2.29.2
bedtools coverage -counts -a arabidopsis_thaliana_genes_overlapping_Chr$SLURM_ARRAY_TASK_ID.bed -b arabidopsisThalianaJointGenotypes_missense_Chr$SLURM_ARRAY_TASK_ID.vcf.gz > arabidopsis_thaliana_nonsynonymousCountsByGene_Chr$SLURM_ARRAY_TASK_ID.bed

bedtools coverage -counts -a arabidopsis_thaliana_genes_overlapping_Chr$SLURM_ARRAY_TASK_ID.bed -b arabidopsisThalianaJointGenotypes_synonymous_Chr$SLURM_ARRAY_TASK_ID.vcf.gz > arabidopsis_thaliana_synonymousCountsByGene_Chr$SLURM_ARRAY_TASK_ID.bed