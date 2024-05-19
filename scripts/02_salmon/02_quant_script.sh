#!/bin/bash

# Script for transcript counting

# Working directory
WORKDIR="/Volumes/oli/RESULTS/data/02_salmon"
cd ${WORKDIR}

# Data
READS="/Volumes/oli/reads_kraken2/" # directory with decontaminated reads
FILES_PATTERN="${READS}kraken2_OL*.fq.gz" # naming pattern for decontaminated reads
INDEX="oli.idx"

source activate salmon

for F in $FILES_PATTERN ; do
    number=$(echo "$F" | awk -F'OL|\\.' '{print $2}')
    
    R1="${READS}kraken2_OL${number}.1.fq.gz"
    R2="${READS}kraken2_OL${number}.2.fq.gz"
    
    
    OUTPUT_DIR="${WORKDIR}/salmon/OL${number}.out"
    
    salmon quant --index ${INDEX} --libType A -1 $R1 -2 $R2 --output ${OUTPUT_DIR} --seqBias --gcBias --minScoreFraction 0.50 --softclip --validateMappings --writeUnmappedNames --threads 5
done

# make one table of counts for all reads
salmon quantmerge --quant ${WORKDIR}/salmon/* --output tpm_table.csv

wait
echo "JOB DONE ヽ(・∀・)ﾉ"
