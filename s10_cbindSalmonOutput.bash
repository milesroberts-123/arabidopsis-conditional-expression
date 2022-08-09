#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=10
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

ml -* GCC/8.3.0 OpenMPI/3.1.4 R/4.1.0
Rscript s09_cbindSalmonOutput.R $SLURM_CPUS_PER_TASK
