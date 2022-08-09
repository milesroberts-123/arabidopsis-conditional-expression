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

ml -* GCC/6.4.0-2.28 PAML/4.9i
for FILE in finalCodonAlignments/*.paml
  do

    OUTFILE=codemlOutput/$(basename $FILE paml)codeml

    sed -i "s|seqfile.*|seqfile = $FILE|g" codeml.ctl
        
    sed -i "s|outfile.*|outfile = $OUTFILE|g" codeml.ctl
    
    codeml

  done
