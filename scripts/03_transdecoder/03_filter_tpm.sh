#!/bin/bash

# Script  that filters the TPM table, quant.sf files, and TransDecoder output, retaining only protein-coding transcripts with an expression level of at least 1 TPM in at least one sample.

WORKING_DIR="/Volumes/oli/RESULTS/data/03_transdecoder"
cd ${WORKING_DIR}

# Script
tpm_filtrator="/Volumes/oli/RESULTS/scripts/03_transdecoder/tpm_filtrator_sf.py" # Filtration script

# Data
ANNOTATED_PEP="/Volumes/oli/RESULTS/data/03_transdecoder/renamed/proteins.fasta" # renamed TransDecoder proteins output
ANNOTATED_CDS="/Volumes/oli/RESULTS/data/03_transdecoder/renamed/cds.fasta" # renamed TransDecoder cds output 
TPM_TABLE="/Volumes/oli/RESULTS/data/02_salmon/tpm_table.csv" # TPM table for all samples (NOTE that for tpm_filtrator_sf.py to work this file need to be in salmon output direcory - see 02_salmon scripts)

# Output dir for filtered TPM table
OUTPUT_DIR=$(dirname "$TPM_TABLE")

# Environment
source activate transdecoder

python ${tpm_filtrator} --pep ${ANNOTATED_PEP} --cds ${ANNOTATED_CDS} -t ${TPM_TABLE} -o ${OUTPUT_DIR}

wait
echo "JOB DONE ヽ(・∀・)ﾉ"
