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

# merge cds into one file, so that seqkit can grab both orthologs for each gene easily
cat Alyrata_384_v2.1.cds_primaryTranscriptOnly.fa Athaliana_447_Araport11.cds_primaryTranscriptOnly.fa > allCDS.fa

# Loop over orthogroups, grab CDS for each ortholog
for orthogroup in proteinSeq/OrthoFinder/Results_Jun09/Single_Copy_Orthologue_Sequences/*
	do	
		# echo $orthogroup
		~/seqkit grep -f <(~/seqkit seq -n -i $orthogroup) allCDS.fa -o OrthogroupCDS/cds_$(echo $orthogroup | sed 's/.*\///g')
	done

echo Extraction complete.
