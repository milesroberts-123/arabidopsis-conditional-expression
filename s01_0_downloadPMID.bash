# delete files from previous trials, if needed
rm PMIDforBioprojects.txt
rm out.xml

# Extract pubmed id for each bioproject
while read -u 3 -r BIOPROJECT; do
	efetch -db bioproject -id $BIOPROJECT -format xml > out.xml
	PMID="$(cat out.xml | xtract -pattern ProjectDescr -element Publication@id)"
        NEWBIOPROJECT="$(cat out.xml | xtract -pattern ProjectID -element ArchiveID@accession)"
        echo "$NEWBIOPROJECT, $PMID" >> PMIDforBioprojects.txt

	#PMID="$(efetch -db bioproject -id $BIOPROJECT -format xml | xtract -pattern ProjectDescr -element Publication@id)"
	#NEWBIOPROJECT="$(efetch -db bioproject -id $BIOPROJECT -format xml | xtract -pattern ProjectID -element ArchiveID@accession)"
	#echo "$NEWBIOPROJECT, $PMID" >> PMIDforBioprojects.txt
done 3<bioprojectsToCheckForPMID.txt

# delete intermediate files
rm out.xml
