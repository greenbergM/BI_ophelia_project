#!/bin/bash

WORKING_DIR="/Volumes/oli/RESULTS/data/04_annotation"
cd ${WORKING_DIR}


ANNOTATION="/Volumes/oli/RESULTS/data/04_annotation/eggnog/out.emapper.annotations"
TPM_TABLE="/Volumes/oli/RESULTS/data/02_salmon/filtered_tpm_table.csv"

make_gene2GO="/Volumes/oli/RESULTS/scripts/04_annotation/make_gene2GO.R"
make_TPM_table_for_specificGO="/Volumes/oli/RESULTS/scripts/04_annotation/make_TPM_table_for_specificGO.R"

INTERESTING_GOs="GO:0032502|GO:0044767" 
NAME_INTERESTING_TPM="development"

source activate clustGO

#create convenient annotation file
ANNOTATION_DIR=$(dirname "${ANNOTATION}")
grep -v '^##' "${ANNOTATION}" | sed 's/#//g' > "${ANNOTATION_DIR}/oli_annot.csv"

Rscript ${make_gene2GO} ${ANNOTATION_DIR}/oli_annot.csv

Rscript ${make_TPM_table_for_specificGO} ${ANNOTATION_DIR}/oli_annot.csv ${TPM_TABLE} ${INTERESTING_GOs} ${NAME_INTERESTING_TPM}

wait
echo "JOB DONE ヽ(・∀・)ﾉ"