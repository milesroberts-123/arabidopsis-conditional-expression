ml -* GCC/8.3.0 BEDTools/2.29.2
# GC content and CG methylation
bedtools nuc -fi Athaliana_447_TAIR10.fa -bed arabidopsis_thaliana_genes_overlapping.bed -C -pattern CG > arabidopsis_thaliana_gcContent_CG.txt

# CHG context
bedtools nuc -fi Athaliana_447_TAIR10.fa -bed arabidopsis_thaliana_genes_overlapping.bed -C -pattern CAG > arabidopsis_thaliana_gcContent_CAG.txt
bedtools nuc -fi Athaliana_447_TAIR10.fa -bed arabidopsis_thaliana_genes_overlapping.bed -C -pattern CTG > arabidopsis_thaliana_gcContent_CTG.txt
bedtools nuc -fi Athaliana_447_TAIR10.fa -bed arabidopsis_thaliana_genes_overlapping.bed -C -pattern CCG > arabidopsis_thaliana_gcContent_CCG.txt

# CHH context
bedtools nuc -fi Athaliana_447_TAIR10.fa -bed arabidopsis_thaliana_genes_overlapping.bed -C -pattern CAA > arabidopsis_thaliana_gcContent_CAA.txt
bedtools nuc -fi Athaliana_447_TAIR10.fa -bed arabidopsis_thaliana_genes_overlapping.bed -C -pattern CAT > arabidopsis_thaliana_gcContent_CAT.txt
bedtools nuc -fi Athaliana_447_TAIR10.fa -bed arabidopsis_thaliana_genes_overlapping.bed -C -pattern CAC > arabidopsis_thaliana_gcContent_CAC.txt

bedtools nuc -fi Athaliana_447_TAIR10.fa -bed arabidopsis_thaliana_genes_overlapping.bed -C -pattern CTA > arabidopsis_thaliana_gcContent_CTA.txt
bedtools nuc -fi Athaliana_447_TAIR10.fa -bed arabidopsis_thaliana_genes_overlapping.bed -C -pattern CTC > arabidopsis_thaliana_gcContent_CTC.txt
bedtools nuc -fi Athaliana_447_TAIR10.fa -bed arabidopsis_thaliana_genes_overlapping.bed -C -pattern CTT > arabidopsis_thaliana_gcContent_CTT.txt

bedtools nuc -fi Athaliana_447_TAIR10.fa -bed arabidopsis_thaliana_genes_overlapping.bed -C -pattern CCA > arabidopsis_thaliana_gcContent_CCA.txt
bedtools nuc -fi Athaliana_447_TAIR10.fa -bed arabidopsis_thaliana_genes_overlapping.bed -C -pattern CCC > arabidopsis_thaliana_gcContent_CCC.txt
bedtools nuc -fi Athaliana_447_TAIR10.fa -bed arabidopsis_thaliana_genes_overlapping.bed -C -pattern CCT > arabidopsis_thaliana_gcContent_CCT.txt