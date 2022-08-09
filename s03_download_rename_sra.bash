#!/bin/bash
echo "USAGE: ./download_rename_sra.bash -s <LIST OF SRA NUMBERS>"
#Parse input arguments
while getopts s:n: option; do
		case "${option}" in
			s) SRAS=${OPTARG};;
		esac
	done

#Download and rename SRA data
while read -u 3 -r SRA; do
	echo Downloading $SRA...

	#Download data
	fastq-dump --split-e $SRA
	#fastq-dump $SRA

	#Rename data
	#If data is accidentially labeled as paired, rename the single-end file too
	#mv $(echo $SRA)_1.fastq $(echo $NAME)_1.fastq
	#mv $(echo $SRA)_2.fastq $(echo $NAME)_2.fastq
	#mv $(echo $SRA).fastq $(echo $NAME).fastq

	#Compress data
	gzip $(echo $SRA)_1.fastq
	gzip $(echo $SRA)_2.fastq
	gzip $(echo $SRA).fastq
	#gzip $(echo $NAME)_1.fastq
	#gzip $(echo $NAME)_2.fastq
	#gzip $(echo $NAME).fastq
done 3<$SRAS

