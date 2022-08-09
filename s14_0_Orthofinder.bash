#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

# Run orthofinder on A. thaliana and A. lyrata proteins, only primary transcript of each protein
# ml -* GCC/8.3.0 OpenMPI/3.1.4 OrthoFinder/2.5.4-Python-3.7.4
~/OrthoFinder/orthofinder -f proteinSeq/ -t $SLURM_CPUS_PER_TASK

