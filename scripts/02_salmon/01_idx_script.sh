#!/bin/bash

WORKING_DIR="/Volumes/oli/RESULTS/data/02_salmon"
cd ${WORKING_DIR}

ASSEMBLY="/Volumes/oli/RESULTS/data/01_assembly/oli_assembly.fasta"
TAG="oli.idx"

source activate salmon

salmon index --transcripts ${ASSEMBLY} --index ${TAG} --threads 5

wait
echo "JOB DONE ヽ(・∀・)ﾉ"
