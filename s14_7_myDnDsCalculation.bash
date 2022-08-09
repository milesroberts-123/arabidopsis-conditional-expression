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

ml -* GCC/10.2.0 OpenMPI/4.0.5 Biopython/1.79-a

# loop over codon aligned fasta files, calculate N and S
for FILE in finalCodonAlignments/*.fasta
do
  python3 s14_6_myDnDsCalculation.py $FILE pair > $(basename $FILE fasta)dnds
done

# Calculate N and S for every gene in A thaliana, not just 1:1 orthologs
python3 s14_6_myDnDsCalculation.py Athaliana_447_Araport11.cds_primaryTranscriptOnly.fa sing > arabidopsis_thaliana_nonsynonymousSitesForEveryGene.txt