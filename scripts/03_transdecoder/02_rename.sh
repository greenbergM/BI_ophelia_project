#!/bin/bash

# Script that makes simpler fasta names for transdecoder outputs (useful during annotation and subsequent analysis)

# Working directory
WORKING_DIR="/Volumes/oli/RESULTS/data/03_transdecoder"
cd ${WORKING_DIR}

# Scripts
get_normal_names="/Volumes/oli/RESULTS/scripts/03_transdecoder/get_normal_names.py" # script that deletes long descriptions in transdecoder output

# Data
PROTEINS="/Volumes/oli/RESULTS/data/03_transdecoder/oli_assembly.fasta.transdecoder.pep"
CDS="/Volumes/oli/RESULTS/data/03_transdecoder/oli_assembly.fasta.transdecoder.cds"

# Environment
source activate oli_env

# Results folder in working directory
mkdir renamed
cd renamed

python ${get_normal_names} -i ${PROTEINS} -o proteins.fasta
python ${get_normal_names} -i ${CDS} -o cds.fasta

wait
echo "JOB DONE ヽ(・∀・)ﾉ"