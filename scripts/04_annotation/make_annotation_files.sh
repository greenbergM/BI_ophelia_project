#!/bin/bash

# Script for making different files based on annotation - gene2GO mapping file (useful for subsequent topGO analysis) and subset of TPM table with transcripts harbouring specific GO terms. 

# Working directory
WORKING_DIR="/Volumes/oli/RESULTS/data/04_annotation"
cd ${WORKING_DIR}

# Scripts
make_gene2GO="/Volumes/oli/RESULTS/scripts/04_annotation/make_gene2GO.R" # create gene2GO mapping file
make_TPM_table_for_specificGO="/Volumes/oli/RESULTS/scripts/04_annotation/make_TPM_table_for_specificGO.R" # create subset of TPM table with transcripts harbouring specific GO terms
 
# Data
ANNOTATION="/Volumes/oli/RESULTS/data/04_annotation/eggnog/out.emapper.annotations" # eggNOG-mapper output 
TPM_TABLE="/Volumes/oli/RESULTS/data/02_salmon/filtered_tpm_table.csv" # filtered TPM table

INTERESTING_GOs="GO:0032502|GO:0044767" # GOs for filtering TPM table
NAME_INTERESTING_TPM="development" # name tag for TPM table subset

# Environment
source activate oli_env

# Delete unnecessary lines from annotation file and save it under new name (oli_annot.csv) in same directory
ANNOTATION_DIR=$(dirname "${ANNOTATION}")
grep -v '^##' "${ANNOTATION}" | sed 's/#//g' > "${ANNOTATION_DIR}/oli_annot.csv"

Rscript ${make_gene2GO} ${ANNOTATION_DIR}/oli_annot.csv

Rscript ${make_TPM_table_for_specificGO} ${ANNOTATION_DIR}/oli_annot.csv ${TPM_TABLE} ${INTERESTING_GOs} ${NAME_INTERESTING_TPM}

wait
echo "JOB DONE ヽ(・∀・)ﾉ"