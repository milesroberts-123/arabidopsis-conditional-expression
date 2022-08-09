#!/bin/bash
#Extract just genes in bed file format
#Chr, start, end, gene name
#Must convert from GFF-style counting to BED-style counting
ml -* GCC/8.3.0 BEDTools/2.29.2

# Extract list of gene coordinates from gff file
zcat Athaliana_447_Araport11.gene.gff3.gz | awk '(($3 == "gene"))' | grep -v "^#" | sed 's/;.*$//g' | sed 's/ID=//g' | sed 's/.Araport11.447//g' | cut -f 1,4,5,9 | awk -v s=1 '{OFS = "\t"; print $1, $2 - s, $3, $4}' | sort -k1,1 -k2,2n > arabidopsis_thaliana_genes_overlapping.bed

# Extract list of CDS coordinates from gff file, where CDS intervals can be overlapping
zcat Athaliana_447_Araport11.gene.gff3.gz | awk '(($3 == "CDS"))' | cut -f 1,4,5,9 | sed 's/;.*$//g' | sed 's/ID=//g' | sed 's/\.[0-9]*.Araport11.447.*//g' > arabidopsis_thaliana_CDS_overalpping.bed

# Extract list of CDS coordinates, but merge overlapping CDS intervals
zcat Athaliana_447_Araport11.gene.gff3.gz | awk '(($3 == "CDS"))' | grep -v "^#" | sed 's/;.*$//g' | sed 's/ID=//g' | sed 's/.Araport11.447//g' | cut -f 1,4,5,9 | awk -v s=1 '{OFS = "\t"; print $1, $2 - s, $3}' | sort -k1,1 -k2,2n | bedtools merge > arabidopsis_thaliana_CDS.bed

#Subset genes and CDS by chromosome for parallelization
awk '(($1 == "Chr1"))' arabidopsis_thaliana_genes_overlapping.bed > arabidopsis_thaliana_genes_overlapping_Chr1.bed
awk '(($1 == "Chr2"))' arabidopsis_thaliana_genes_overlapping.bed > arabidopsis_thaliana_genes_overlapping_Chr2.bed
awk '(($1 == "Chr3"))' arabidopsis_thaliana_genes_overlapping.bed > arabidopsis_thaliana_genes_overlapping_Chr3.bed
awk '(($1 == "Chr4"))' arabidopsis_thaliana_genes_overlapping.bed > arabidopsis_thaliana_genes_overlapping_Chr4.bed
awk '(($1 == "Chr5"))' arabidopsis_thaliana_genes_overlapping.bed > arabidopsis_thaliana_genes_overlapping_Chr5.bed

awk '(($1 == "Chr1"))' arabidopsis_thaliana_CDS.bed > arabidopsis_thaliana_CDS_Chr1.bed
awk '(($1 == "Chr2"))' arabidopsis_thaliana_CDS.bed > arabidopsis_thaliana_CDS_Chr2.bed
awk '(($1 == "Chr3"))' arabidopsis_thaliana_CDS.bed > arabidopsis_thaliana_CDS_Chr3.bed
awk '(($1 == "Chr4"))' arabidopsis_thaliana_CDS.bed > arabidopsis_thaliana_CDS_Chr4.bed
awk '(($1 == "Chr5"))' arabidopsis_thaliana_CDS.bed > arabidopsis_thaliana_CDS_Chr5.bed

# Create populations file for pixy
sed 's/$/\tFOOBAR/g' dnaSra.txt > arabidopsisThalianaPopulations.txt
