# Creation of separate gene2GO file seems to be more convenient for subsecuent analysis with topGO R package.

annot_file <- commandArgs(trailingOnly = TRUE)[1]

annotGO <- read.csv(annot_file, sep = '\t')
annotGO <- annotGO[, c("query", "GOs")]
annotGO <- subset(annotGO, annotGO$GOs != "-")
output_file <- file.path(dirname(annot_file), "oli_gene2GO.csv")
write.table(annotGO, file = output_file, sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)

