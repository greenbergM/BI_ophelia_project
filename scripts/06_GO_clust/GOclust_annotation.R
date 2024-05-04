library(topGO)
library(rrvgo)
library(dplyr)
library(ggplot2)

working_directory <- "/Volumes/oli/RESULTS/data/06_GOclust"
setwd(working_directory)

oli_clusters_file <- "/Volumes/oli/RESULTS/data/05_clust/oli_clust_2/oli_clust_2.csv"
oli_geneID2GO_file <- "/Volumes/oli/RESULTS/data/04_annotation/eggnog/oli_gene2GO.csv"


oli_clusters_df <- read.csv(oli_clusters_file, sep="\t")
oli_geneID2GO <- readMappings(file = oli_geneID2GO_file, sep = '\t')
gene_names <- names(oli_geneID2GO)

for(cluster in colnames(oli_clusters_df)){
  
  #GO enrichment in cluster
  cluster_genes <- factor(as.integer(gene_names %in% oli_clusters_df[[cluster]]))
  names(cluster_genes) <- gene_names
  GOdata_cluster <- new("topGOdata", ontology = "BP", allGenes = cluster_genes, annot = annFUN.gene2GO, gene2GO = oli_geneID2GO)
  resultFis <- runTest(GOdata_cluster, algorithm = "classic", statistic = "fisher")
  resultsFis_df <- as.data.frame(score(resultFis))
  
  resultsFis_df_signif <- subset(resultsFis_df, resultsFis_df$`score(resultFis)` < 0.05)
  GO_set <- GenTable(GOdata_cluster, classic=resultFis, ranksOf="classicFisher", topNodes = length(resultsFis_df_signif$`score(resultFis)`))
  GO_subset <- subset(GO_set, Significant > 10)
  GO_subset$classic <- gsub("<", "", GO_subset$classic)
  
  simMatrix <- calculateSimMatrix(GO_subset$GO.ID,
                                  orgdb="org.Hs.eg.db",
                                  ont="BP",
                                  method="Rel")
  
  scores <- setNames(-log10(as.numeric(GO_subset$classic)), GO_subset$GO.ID)
  reducedTerms <- reduceSimMatrix(simMatrix,
                                  scores,
                                  threshold=0.7,
                                  orgdb="org.Hs.eg.db")
  
  reducedTerms_uniq <- reducedTerms %>% 
  group_by(parentTerm) %>%
  filter(row_number() == 1)

  reducedTerms_uniq <- reducedTerms[!duplicated(reducedTerms$parentTerm), ]
  reducedTerms_uniq <- as.data.frame(reducedTerms_uniq)
  reducedTerms <- as.data.frame(reducedTerms)
  
  #creation of folder for results
  cluster_dir <- paste("cluster_", gsub(" ", "_", cluster), "_GOterms", sep = "")
  if (!file.exists(cluster_dir)) {
    dir.create(cluster_dir)
  }

  pdf(file.path(cluster_dir, "tm_reduced_GO.pdf"))
  treemapPlot(reducedTerms, title = cluster)
  dev.off()
  
  write.table(reducedTerms_uniq, file = paste(cluster_dir, "/reducedTerms_uniq.txt", sep = ""), sep = "\t", row.names = FALSE)
  write.table(reducedTerms, file = paste(cluster_dir, "/reducedTerms.txt", sep = ""), sep = "\t", row.names = FALSE)
  write.table(GO_subset, file = paste(cluster_dir, "/allTerms.txt", sep = ""), sep = "\t", row.names = FALSE)
}
