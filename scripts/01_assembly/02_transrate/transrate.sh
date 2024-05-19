#!/bin/bash

# Script for filtering low-quality transcripts from assemblies. 

# Working directory
WORKING_DIR="/home/embr/oli/RESULTS/data/01_assembly"
cd ${WORKING_DIR}

# Data
SPADES="/home/embr/oli/RESULTS/data/01_assembly/oli_spades95.fa" # Clustered spades assmbly
TRINITY="/home/embr/oli/RESULTS/data/01_assembly/oli_trinity95.fa"  # Clustered trinity assmbly

MERGED_READS_1="/home/embr/oli/reads_kraken2/M1.fq.gz" # Merged decontaminated forward reads
MERGED_READS_2="/home/embr/oli/reads_kraken2/M2.fq.gz" # Merged decontaminated reverse reads

# Tool
TRANSRATE="/home/embr/tools/orp-transrate/transrate"

nohup ${TRANSRATE} --assembly ${SPADES}, ${TRINITY} --left ${MERGED_READS_1} --right ${MERGED_READS_2} --threads=30
wait
echo "JOB DONE ヽ(・∀・)ﾉ"
