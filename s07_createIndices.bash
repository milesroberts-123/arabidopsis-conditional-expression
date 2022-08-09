#!/bin/bash --login
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=7-00:00:00
#SBATCH --mem-per-cpu=16G
#SBATCH --partition=josephsnodes
#SBATCH --account=josephsnodes
# output information about how this job is running using bash commands
echo "This job is running on $HOSTNAME on `date`"

#Index for BWA
ml -* GCC/5.4.0-2.26 OpenMPI/1.10.3 BWA/0.7.17
bwa index Athaliana_447_TAIR10.fa

#Index for gatk
ml -* GCC/9.3.0 SAMtools/1.11
samtools faidx Athaliana_447_TAIR10.fa

#Sequence dictionary for gatk
ml -* picard/2.22.1-Java-11
java -jar $EBROOTPICARD/picard.jar CreateSequenceDictionary \
      R=Athaliana_447_TAIR10.fa \
      O=Athaliana_447_TAIR10.dict

# Index for salmon
# Build decoy-aware transcriptome file
cat Athaliana_447_Araport11.cds_primaryTranscriptOnly.fa Athaliana_447_TAIR10.fa > AthalianaTranscriptomeDecoyAware.fa

# Build list of decoys (i.e. chromosomes)
rm decoys.txt
echo "Chr1" >> decoys.txt
echo "Chr2" >> decoys.txt
echo "Chr3" >> decoys.txt
echo "Chr4" >> decoys.txt
echo "Chr5" >> decoys.txt
echo "ChrC" >> decoys.txt
echo "ChrM" >> decoys.txt

# Create index, use somewhat short k because the shortest read lengths will be around 25 bp
ml -* Salmon/1.2.1
salmon index -t AthalianaTranscriptomeDecoyAware.fa --decoys decoys.txt -i salmon_index -k 27
