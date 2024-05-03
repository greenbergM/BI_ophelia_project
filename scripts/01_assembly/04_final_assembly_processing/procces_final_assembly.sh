#!/bin/bash

WORKING_DIR="/Volumes/oli/RESULTS/data/01_assembly"
cd ${WORKING_DIR}

BEST_ASSEMBLY="/Volumes/oli/RESULTS/data/01_assembly/transrate_results/spades/good.oli_spades95.fasta"
MAKE_GENE2TRANS="/Volumes/oli/RESULTS/scripts/01_assembly/04_final_assembly_processing/make_gene2trans.py"

source activate ml

sed 's/>NODE/>Oli/' "$BEST_ASSEMBLY" > oli_assembly.fasta

python ${MAKE_GENE2TRANS} ./oli_assembly.fasta

wait
echo "JOB DONE ヽ(・∀・)ﾉ"