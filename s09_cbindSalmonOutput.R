library(data.table)

# Arguments
args = commandArgs(trailingOnly=TRUE)
print(args)

#List salmon outputs
print("Finding salmon output files...")
quants = list.files(pattern = "^quant.sf$", recursive = T)
print(quants)

#Function to read TPM
readQuantsTPM = function(x){
	as.data.frame(fread(x, nThread = as.numeric(args), select = "TPM", header = T))
}

readQuantsNumReads = function(x){
	as.data.frame(fread(x, nThread = as.numeric(args), select = "NumReads", header = T))
}

#Function to merge many dataframes
#mergeManyFrames <- function(df1, df2){
#  merge(df1, df2, by = "Name")
#}

#Read data
print("Reading TPM data...")
quantFrameTPM = lapply(quants, readQuantsTPM)
print("Reading read count data...")
quantFrameNum= lapply(quants, readQuantsNumReads)

# Read names
print("Reading gene names...")
geneNames = as.data.frame(fread(quants[1], nThread = as.numeric(args), select = "Name", header = T))
geneNames = geneNames$Name
print(geneNames)

# cbind frames
print("cbind TPM data...")
quantFrameTPM = as.data.frame(do.call("cbind", quantFrameTPM))
print("cbind read count data...")
quantFrameNum = as.data.frame(do.call("cbind", quantFrameNum))

# add gene names
print("adding row names (i.e. gene names) ...")
quantFrameTPM = as.data.frame(cbind(geneNames, quantFrameTPM))
quantFrameNum = as.data.frame(cbind(geneNames, quantFrameNum))

#Merge frames
#print("Merging TPM data...")
#quantFrameTPM = Reduce(mergeManyFrames, quantFrameTPM)
#print("Merging read count data...")
#quantFrameNum = Reduce(mergeManyFrames, quantFrameNum) 

# Add column names to matrix
print("Extracting column names...")
newColNames = c("Name", gsub("_mapped/quant.sf", "", quants))
names(quantFrameTPM) = newColNames
names(quantFrameNum) = newColNames

#Write result
print("Writing output...")
write.csv(quantFrameTPM, "expressionMatrixCbind_TPM.csv", quote = F, row.names = F)
write.csv(quantFrameNum, "expressionMatrixCbind_NumReads.csv", quote = F, row.names = F)

