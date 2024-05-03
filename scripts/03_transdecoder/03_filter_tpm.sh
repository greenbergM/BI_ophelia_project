#!/bin/bash

WORKING_DIR="/Volumes/oli/RESULTS/data/03_transdecoder"
cd ${WORKING_DIR}

ANNOTATED_PEP="/Volumes/oli/RESULTS/data/03_transdecoder/renamed/proteins.fasta"
ANNOTATED_CDS="/Volumes/oli/RESULTS/data/03_transdecoder/renamed/cds.fasta"
TPM_TABLE="/Volumes/oli/RESULTS/data/02_salmon/tpm_table.csv"

tpm_filtrator="/Volumes/oli/RESULTS/scripts/03_transdecoder/tpm_filtrator_sf.py"

OUTPUT_DIR=$(dirname "$TPM_TABLE")

source activate transdecoder

python ${tpm_filtrator} --pep ${ANNOTATED_PEP} --cds ${ANNOTATED_CDS} -t ${TPM_TABLE} -o ${OUTPUT_DIR}

wait
echo "JOB DONE ヽ(・∀・)ﾉ"
