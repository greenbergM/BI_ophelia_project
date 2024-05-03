#!/bin/bash

WORKDIR="/Volumes/oli/RESULTS/data/02_salmon"
cd ${WORKDIR}

READS="/Volumes/oli/reads_kraken2/"
FILES_PATTERN="${READS}kraken2_OL*.fq.gz"
INDEX="oli.idx"

source activate salmon

for F in $FILES_PATTERN ; do
    number=$(echo "$F" | awk -F'OL|\\.' '{print $2}')
    
    R1="${READS}kraken2_OL${number}.1.fq.gz"
    R2="${READS}kraken2_OL${number}.2.fq.gz"
    
    
    OUTPUT_DIR="${WORKDIR}/salmon/OL${number}.out"
    
    salmon quant --index ${INDEX} --libType A -1 $R1 -2 $R2 --output ${OUTPUT_DIR} --seqBias --gcBias --minScoreFraction 0.50 --softclip --validateMappings --writeUnmappedNames --threads 5
done

salmon quantmerge --quant ${WORKDIR}/salmon/* --output tpm_table.csv

wait
echo "JOB DONE ヽ(・∀・)ﾉ"
