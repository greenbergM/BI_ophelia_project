#!/bin/bash

WORKING_DIR="/Volumes/oli/RESULTS/data/05_clust"
cd ${WORKING_DIR}

TPM_TABLE="/Volumes/oli/RESULTS/data/02_salmon/development_filtered_tpm_table.csv"
CLUST_REPLICATES="/Volumes/oli/RESULTS/scripts/05_clust/replicates_info.txt"
CLUSTER_FORMATER="/Volumes/oli/RESULTS/scripts/05_clust/formate_clusters.py"

CLUSTER_TIGHTNESS=10

source activate clust

clust "$TPM_TABLE" -r "$CLUST_REPLICATES" -t "$CLUSTER_TIGHTNESS" -o "oli_clust_${CLUSTER_TIGHTNESS}" 

cd oli_clust_${CLUSTER_TIGHTNESS}
python ${CLUSTER_FORMATER} -i Clusters_Objects.tsv -o oli_clust_${CLUSTER_TIGHTNESS}.csv

wait
echo "JOB DONE ヽ(・∀・)ﾉ"
