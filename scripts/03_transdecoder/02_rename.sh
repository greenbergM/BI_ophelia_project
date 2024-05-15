#!/bin/bash

# get simpler fasta names for transdecoder outputs 

WORKING_DIR="/Volumes/oli/RESULTS/data/03_transdecoder"
cd ${WORKING_DIR}

PROTEINS="/Volumes/oli/RESULTS/data/03_transdecoder/oli_assembly.fasta.transdecoder.pep"
CDS="/Volumes/oli/RESULTS/data/03_transdecoder/oli_assembly.fasta.transdecoder.cds"
get_normal_names="/Volumes/oli/RESULTS/scripts/03_transdecoder/get_normal_names.py"


source activate transdecoder

mkdir renamed
cd renamed

python ${get_normal_names} -i ${PROTEINS} -o proteins.fasta
python ${get_normal_names} -i ${CDS} -o cds.fasta

wait
echo "JOB DONE ヽ(・∀・)ﾉ"