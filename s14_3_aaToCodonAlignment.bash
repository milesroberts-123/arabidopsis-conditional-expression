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

for FILE in alignedOrthogroupSeq/*.fa
	do
   # output in paml for codeml
		~/pal2nal.v14/pal2nal.pl $FILE OrthogroupCDS/cds_$(basename $FILE _aligned.fa).fa -output paml -nogap > finalCodonAlignments/$(basename $FILE _aligned.fa).paml
   # output in fasta for biopython
   ~/pal2nal.v14/pal2nal.pl $FILE OrthogroupCDS/cds_$(basename $FILE _aligned.fa).fa -output fasta -nogap > finalCodonAlignments/$(basename $FILE _aligned.fa).fasta
	done
