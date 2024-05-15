#!/bin/bash

WORKING_DIR="/home/embr/oli/RESULTS/data/01_assembly"
cd ${WORKING_DIR}

TRANSRATE="/home/embr/tools/orp-transrate/transrate"

SPADES="/home/embr/oli/RESULTS/data/01_assembly/oli_spades.95.fa"
TRINITY="/home/embr/oli/RESULTS/data/01_assembly/oli_trinity.95.fa"

MERGED_READS_1="/home/embr/oli/reads_kraken2/M1.fq.gz" 
MERGED_READS_2="/home/embr/oli/reads_kraken2/M2.fq.gz"

nohup ${TRANSRATE} --assembly ${SPADES}, ${TRINITY} --left ${MERGED_READS_1} --right ${MERGED_READS_2} --threads=30
wait
echo "JOB DONE ヽ(・∀・)ﾉ"
