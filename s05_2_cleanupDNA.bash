#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=3:00:00
#SBATCH --mem-per-cpu=200M
#SBATCH --array=0-567
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

# trim adapters, low quality bases
while read -u 3 -r SRA; do
if [ -f "$(echo $SRA)_1.fastq.gz" ]; then
        #For paired-end data
        rm $(echo $SRA)_1.fastq.gz $(echo $SRA)_2.fastq.gz
else
        #For single-end data
        rm $(echo $SRA).fastq.gz
fi
done 3<dnaSra_split$SLURM_ARRAY_TASK_ID