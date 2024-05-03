# Script for making TPM table with only specific genes - used for clust

annotGO_file <- commandArgs(trailingOnly = TRUE)[1]
tpm_table_file <- commandArgs(trailingOnly = TRUE)[2]
interestingGOs <- commandArgs(trailingOnly = TRUE)[3]
name <- commandArgs(trailingOnly = TRUE)[4]

annotGO <- read.csv(annotGO_file, sep = '\t')
tpm_table <- read.csv(tpm_table_file, sep = '\t')

interesting_genes<- subset(annotGO, grepl(interestingGOs, annotGO$GOs))
interesting_tpm_table <- tpm_table[tpm_table$Name %in% interesting_genes$query, ]

output_directory <- dirname(tpm_table_file)
output_filename <- paste0(name, "_", basename(tpm_table_file))
interesting_tpm_table_file <- file.path(output_directory, output_filename)
write.table(interesting_tpm_table, file = interesting_tpm_table_file, sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
