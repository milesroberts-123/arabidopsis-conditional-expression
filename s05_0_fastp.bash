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

# trim adapters, low quality bases
while read -u 3 -r SRA; do
if [ -f "$(echo $SRA)_1.fastq.gz" ]; then
	#For paired-end data
	~/fastp --dont_eval_duplication --thread $SLURM_CPUS_PER_TASK -q 20 -l 25 -h $SRA.html -j $(echo $SRA)_fastp.json -i $(echo $SRA)_1.fastq.gz -I $(echo $SRA)_2.fastq.gz -o $(echo $SRA)_1_trim.fastq.gz -O $(echo $SRA)_2_trim.fastq.gz
	#rm (echo $SRA)_1.fastq.gz $(echo $SRA)_2.fastq.gz
else
	#For single-end data
	~/fastp --dont_eval_duplication --thread $SLURM_CPUS_PER_TASK -q 20 -l 25 -h $SRA.html -j $(echo $SRA)_fastp.json -i $(echo $SRA).fastq.gz -o $(echo $SRA)_trim.fastq.gz
	#rm $(echo $SRA).fastq.gz
fi
done 3<rnaSra_split$SLURM_ARRAY_TASK_ID
