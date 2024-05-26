#!/bin/bash

# Script for launching BUSCO analysis and generating plots based on it.

# Working directory
WORKING_DIR="/Volumes/oli/RESULTS/data/01_assembly/busco"
cd ${WORKING_DIR}

# Data
SPADES="/Volumes/oli/RESULTS/data/01_assembly/spades/oli_spades.fasta" # rnaSPAdes assembly
SPADES95_GOOD="/Volumes/oli/RESULTS/data/01_assembly/transrate_results/spades/good.oli_spades95.fasta" # rnaSPAdes assembly after cd-hit clustering and TransRate filtering

TRINITY="/Volumes/oli/RESULTS/data/01_assembly/trinity/oli_trinity.fasta" # Trinity assembly
TRINITY95_GOOD="/Volumes/oli/RESULTS/data/01_assembly/transrate_results/trinity/good.oli_trinity95.fasta" # Trinity assembly after cd-hit clustering and TransRate filtering

BUSCO_DB="/Volumes/oli/databases/busco_database/busco_downloads" # BUSCO database (Metazoa)

# Scripts
BUSCO_PLOT="~/miniconda3/envs/busco/bin/generate_plot.py" # BUSCO script for plotting results 
# Script that creates folder with all BUSCO summaries and gives them better namings which is required for generate_plot.py
MAKE_BUSCO_SUMMARIES="/Volumes/oli/RESULTS/scripts/01_assembly/03_busco/make_BUSCO_summaries.py"

# Environment
source activate oli_env

busco -m transcriptome -i ${SPADES} -l metazoa_odb10 --offline --download_path ${BUSCO_DB} -c 6 -f
busco -m transcriptome -i ${SPADES95_GOOD} -l metazoa_odb10 --offline --download_path ${BUSCO_DB} -c 6 -f
busco -m transcriptome -i ${TRINITY} -l metazoa_odb10 --offline --download_path ${BUSCO_DB} -c 6 -f
busco -m transcriptome -i ${TRINITY95_GOOD} -l metazoa_odb10 --offline --download_path ${BUSCO_DB} -c 6 -f


python ${MAKE_BUSCO_SUMMARIES} 
python ${BUSCO_PLOT} -wd BUSCO_summaries

