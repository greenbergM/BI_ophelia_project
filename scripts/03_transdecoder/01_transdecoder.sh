#!/bin/bash

WORKING_DIR="/Volumes/oli/RESULTS/data/03_transdecoder"
cd ${WORKING_DIR}

ASSEMBLY="/Volumes/oli/RESULTS/data/01_assembly/oli_assembly.fasta"
PFAM_DB="/Volumes/oli/databases/pfam_database/Pfam-A.hmm"
UNIREF_DB="/Volumes/oli/databases/uniref90_database/uniref90/uniref90.dmnd"

source activate transdecoder


~/tools/TransDecoder-TransDecoder-v5.7.1/TransDecoder.LongOrfs -t $ASSEMBLY -m 100
ASSEMBLY_NAME=$(basename "$ASSEMBLY")

mkdir hmmer_search
cd hmmer_search
hmmsearch --cpu 6 --domtblout longORFs_vs_pfama.domtblout $PFAM_DB $WORKING_DIR/$ASSEMBLY_NAME.transdecoder_dir/longest_orfs.pep
cd ..


mkdir uniref90_search
cd uniref90_search
diamond blastp --db $UNIREF_DB --query $WORKING_DIR/$ASSEMBLY_NAME.transdecoder_dir/longest_orfs.pep --threads 6 --out longORFs_vs_uniref90.diamond.outfmt6 --outfmt 6 --max-target-seqs 1 --evalue 1e-5 
cd ..


~/tools/TransDecoder-TransDecoder-v5.7.1/TransDecoder.Predict -t $ASSEMBLY --retain_pfam_hits ./hmmer_search/longORFs_vs_pfama.domtblout --retain_blastp_hits ./uniref90_search/longORFs_vs_uniref90.diamond.outfmt6 --single_best_only

wait
echo "JOB DONE ヽ(・∀・)ﾉ"
