#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=5G
#SBATCH --array=0-567
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

while read -u 3 -r SRA; do

#Call haplotypes
ml -* GCC/7.3.0-2.30 OpenMPI/3.1.1 GATK/4.1.4.1-Python-3.6.6
echo Calling haplotypes...
gatk HaplotypeCaller \
-R Athaliana_447_TAIR10.fa \
-I $(echo $SRA)_sorted_markedDups.bam \
-O $(echo $SRA).g.vcf.gz \
-L arabidopsis_thaliana_CDS.bed \
-ERC GVCF \
--sample-ploidy 2 \
--heterozygosity 0.001 \
--indel-heterozygosity 0.001 \
--min-base-quality-score 20

# give samples more convenient names
#ml -* picard/2.22.1-Java-11
#java -jar $EBROOTPICARD/picard.jar RenameSampleInVcf \
#  INPUT=$(echo $SRA).vcf \
#  OUTPUT=$(echo $SRA)_renamed.vcf \
#  NEW_SAMPLE_NAME=$(echo $SRA)

done 3<dnaSra_split$(echo $SLURM_ARRAY_TASK_ID)

