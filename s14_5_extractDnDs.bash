# delete previous results file, if present
rm arabidopsis_thaliana_v_arabidopsis_lyrata_Codeml_NeiAndGojobori_dnds.txt
rm  arabidopsis_thaliana_v_arabidopsis_lyrata_Codeml_ML_dnds.txt

# add file headers
echo -e 'gene\tdnds\tdn\tds' >> arabidopsis_thaliana_v_arabidopsis_lyrata_Codeml_NeiAndGojobori_dnds.txt
echo -e 't\tS\tN\tdnds\tdn\tds' >> arabidopsis_thaliana_v_arabidopsis_lyrata_Codeml_ML_dnds.txt

# extract dn/ds
for FILE in codemlOutput/*
	do
		# Extract Nei and Gojobori estimate on line 80, add tab seperators
		sed -n '80p' $FILE | sed 's/[()]//g' | sed 's/\s\{1,\}/\t/g' >> arabidopsis_thaliana_v_arabidopsis_lyrata_Codeml_NeiAndGojobori_dnds.txt
   
    # Extract ML estimates on line 89, add tab seperators, remove equal signs
    sed -n '89p' $FILE | sed 's/\s\{1,\}/\t/g' | cut -f1,3,5,7,9,10,12,13 --complement >>  arabidopsis_thaliana_v_arabidopsis_lyrata_Codeml_ML_dnds.txt
	done

# Add gene ids to ML output
cut -f1 arabidopsis_thaliana_v_arabidopsis_lyrata_Codeml_NeiAndGojobori_dnds.txt | paste - arabidopsis_thaliana_v_arabidopsis_lyrata_Codeml_ML_dnds.txt > arabidopsis_thaliana_v_arabidopsis_lyrata_Codeml_ML_dnds_withGeneIDs.txt