#!/bin/bash

SPADES_ASSEMBLY="/Volumes/oli/RESULTS/data/01_assembly/spades/oli_spades.fasta"
TRINITY_ASSEMBLY="/Volumes/oli/RESULTS/data/01_assembly/trinity/oli_trinity.fasta"

source activate cdhit

cd $(dirname "$SPADES_ASSEMBLY")
cd-hit-est -i ${SPADES_ASSEMBLY} -o oli_spades95.fasta -d 0 -g 1 -r 1 -M 9000 -c 0.95 -T 6

cd $(dirname "$TRINITY_ASSEMBLY")
cd-hit-est -i ${TRINITY_ASSEMBLY} -o oli_trinity95.fasta -d 0 -g 1 -r 1 -M 9000 -c 0.95 -T 6

wait
echo "JOB DONE ヽ(・∀・)ﾉ"