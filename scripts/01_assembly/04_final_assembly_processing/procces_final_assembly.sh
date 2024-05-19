#!/bin/bash

#Script for final assembly processing which includes new namings for transcripts and gene2trans mapping file (works for rnaSPAdes assembly)

# Working dir
WORKING_DIR="/Volumes/oli/RESULTS/data/01_assembly"
cd ${WORKING_DIR}

# Scripts
MAKE_GENE2TRANS="/Volumes/oli/RESULTS/scripts/01_assembly/04_final_assembly_processing/make_gene2trans.py" # makes gene2trans mapping file for renamed assembly

# Data
BEST_ASSEMBLY="/Volumes/oli/RESULTS/data/01_assembly/transrate_results/spades/good.oli_spades95.fasta" # best assembly based on BUSCO results

# Environment
source activate ml

# Rename rnaSPAdes assembly
sed 's/>NODE/>oli/' "$BEST_ASSEMBLY" > oli_assembly.fasta

python ${MAKE_GENE2TRANS} ./oli_assembly.fasta

wait
echo "JOB DONE ヽ(・∀・)ﾉ"