#!/bin/bash

# Script that clusterise transcripts based on their expression patterns 


# Working directory
WORKING_DIR="/Volumes/oli/RESULTS/data/05_clust"
cd ${WORKING_DIR}

# Scripts
CLUSTER_FORMATER="/Volumes/oli/RESULTS/scripts/05_clust/formate_clusters.py" # Script that deletes unnecessary lines from clust output (table with list of genes withtin each cluster)

# Data 
TPM_TABLE="/Volumes/oli/RESULTS/data/02_salmon/filtered_tpm_table.csv" # Filtered TPM table for all samples
CLUST_REPLICATES="/Volumes/oli/RESULTS/scripts/05_clust/replicates_info.txt" # Clust replicates file

CLUSTER_TIGHTNESS=2

# Environment
source activate oli_env

clust "$TPM_TABLE" -r "$CLUST_REPLICATES" -t "$CLUSTER_TIGHTNESS" -o "oli_clust_${CLUSTER_TIGHTNESS}" 

cd oli_clust_${CLUSTER_TIGHTNESS}
python ${CLUSTER_FORMATER} -i Clusters_Objects.tsv -o oli_clust_${CLUSTER_TIGHTNESS}.csv

wait
echo "JOB DONE ヽ(・∀・)ﾉ"
