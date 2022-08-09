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

ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 GATK/4.1.4.1-Python-3.6.6
#gatk GenotypeGVCFs \
#   -R Athaliana_447_TAIR10.fa \
#   -V arabidopsisThalianaHaplotypeCallsCombined_Chr$SLURM_ARRAY_TASK_ID.g.vcf.gz \
#   -O arabidopsisThalianaJointGenotypes_Chr$SLURM_ARRAY_TASK_ID.vcf.gz \
#   -L Chr$SLURM_ARRAY_TASK_ID \
#   --include-non-variant-sites

gatk GenotypeGVCFs \
   -R Athaliana_447_TAIR10.fa \
   -V arabidopsisThalianaHaplotypeCallsCombined_Chr$SLURM_ARRAY_TASK_ID.g.vcf.gz \
   -O arabidopsisThalianaJointGenotypes_CDSonly_Chr$SLURM_ARRAY_TASK_ID.vcf.gz \
   -L arabidopsis_thaliana_CDS_Chr$SLURM_ARRAY_TASK_ID.bed \
   --include-non-variant-sites
