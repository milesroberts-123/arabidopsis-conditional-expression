#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=500M
#SBATCH --array=0-964
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Load modules
ml -* Salmon/1.2.1

# salmon mapping
while read -u 3 -r SRA; do
if [ -f "$(echo $SRA)_1_trim.fastq.gz" ]; then
	#For paired-end data
	salmon quant -i salmon_index -l A -p $SLURM_CPUS_PER_TASK -1 $(echo $SRA)_1_trim.fastq.gz -2 $(echo $SRA)_2_trim.fastq.gz --validateMappings --output $(echo $SRA)_mapped
else
	#For single-end data
	salmon quant -i salmon_index -l A -p $SLURM_CPUS_PER_TASK -r $(echo $SRA)_trim.fastq.gz --validateMappings --output $(echo $SRA)_mapped
fi
done 3<rnaSra_split$SLURM_ARRAY_TASK_ID
