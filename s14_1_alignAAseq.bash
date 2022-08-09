ml -* GCC/10.2.0 OpenMPI/4.0.5 MAFFT/7.475-with-extensions
for FILE in proteinSeq/OrthoFinder/Results_Jun09/Single_Copy_Orthologue_Sequences/*.fa
	do
		mafft --quiet --maxiterate 1000 --localpair $FILE > alignedOrthogroupSeq/$(basename $FILE .fa)_aligned.fa
	done
