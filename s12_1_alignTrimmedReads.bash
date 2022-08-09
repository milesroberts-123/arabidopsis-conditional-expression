#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --array=0-567
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

while read -u 3 -r SRA; do

echo Aligning reads...
ml -* GCC/5.4.0-2.26 OpenMPI/1.10.3 BWA/0.7.17

if [ -f "$(echo $SRA)_1_trim.fastq.gz" ]; then
  # Paired end reads
  bwa mem -R $(echo "@RG\tID:$SRA\tSM:$SRA") -t $SLURM_CPUS_PER_TASK Athaliana_447_TAIR10.fa $(echo $SRA)_1_trim.fastq.gz $(echo $SRA)_2_trim.fastq.gz > $(echo $SRA).sam
else
  # Single end reads
  bwa mem -R $(echo "@RG\tID:$SRA\tSM:$SRA") -t $SLURM_CPUS_PER_TASK Athaliana_447_TAIR10.fa $(echo $SRA)_trim.fastq.gz > $(echo $SRA).sam
fi

# Convert to bam format and sort result
echo Converting to BAM and sorting...
ml -* GCC/9.3.0 SAMtools/1.11
samtools view -@ $SLURM_CPUS_PER_TASK -bS $(echo $SRA).sam > $(echo $SRA).bam
samtools sort -@ $SLURM_CPUS_PER_TASK -o $(echo $SRA)_sorted.bam -O BAM $(echo $SRA).bam

#Mark optical duplicates
echo Marking duplicates...
ml -* picard/2.22.1-Java-11
java -jar $EBROOTPICARD/picard.jar MarkDuplicates \
      I=$(echo $SRA)_sorted.bam \
      O=$(echo $SRA)_sorted_markedDups.bam \
      M=$(echo $SRA)_markedDupMetrics.txt

#Index final alignment file
ml -* GCC/9.3.0 SAMtools/1.11
samtools index $(echo $SRA)_sorted_markedDups.bam

# remove intermediate files
echo Cleaning up intermediate files...
rm $(echo $SRA).sam $(echo $SRA).bam $(echo $SRA)_sorted.bam

done 3<dnaSra_split$(echo $SLURM_ARRAY_TASK_ID)

