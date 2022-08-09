#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --array=0-567
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Load modules
ml -* SRA-Toolkit/2.10.7-centos_linux64

#Run download script
./s03_download_rename_sra.bash -s dnaSra_split$(echo $SLURM_ARRAY_TASK_ID)
