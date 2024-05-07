library(dplyr)
library(ggplot2)
library(topGO)
library(viridisLite)
library(stringr)

#####

# Function for classifying Deseq2 results output into Upregulated, Downregulated or Non-DEG categories based on 
# log2 fold change and adjusted p-value
classify_DEGs <- function(deseq_res) {
  deseq_res_df <- as.data.frame(deseq_res)
  
  deseq_res_df <- rownames_to_column(deseq_res_df, var = "gene")
  
  deseq_res_df$DEGs <- case_when(
    deseq_res_df$padj < 0.05 & deseq_res_df$log2FoldChange > 2 ~ "Upregulated",
    deseq_res_df$padj < 0.05 & deseq_res_df$log2FoldChange < -2 ~ "Downregulated",
    TRUE ~ "Non-DEG"
  )
  
  deseq_res_df <- merge(deseq_res_df, annotation[c("query", "Preferred_name", "Description", "PFAMs", "GOs")],
                        by.x = "gene", by.y = "query", all.x = TRUE)
  
  deseq_res_df$Preferred_name[is.na(deseq_res_df$Preferred_name)] <- "-"
  deseq_res_df$Description[is.na(deseq_res_df$Description)] <- "-"
  
  deseq_res_df_up <- deseq_res_df[deseq_res_df$DEGs == "Upregulated", ]
  rownames(deseq_res_df_up) <- NULL
  
  deseq_res_df_down <- deseq_res_df[deseq_res_df$DEGs == "Downregulated", ]
  rownames(deseq_res_df_up) <- NULL
  
  return(list(up = deseq_res_df_up, down = deseq_res_df_down, all = deseq_res_df))
}

# Function for plotting volcano plot for classified deseq2 output (see classify_DEGs function)

volcano_plot <- function(res_df, contrast) {
  
  num_upregulated <- sum(res_df$DEGs == "Upregulated")
  num_downregulated <- sum(res_df$DEGs == "Downregulated")
  
  res_df_with_names <- res_df[res_df$Preferred_name != "-", ]
  
  top_genes <- head(res_df_with_names[order(res_df_with_names$padj), ], 20)
  
  name <- paste(c(contrast[2], contrast[3]), collapse = " vs ")
  
  ggplot(res_df) +
    geom_point(aes(x = log2FoldChange, y = -log10(padj), colour = DEGs), size = 0.5) +
    geom_text(data = top_genes, 
              aes(x = log2FoldChange, y = -log10(padj), label = Preferred_name), 
              color = "black", size = 2, check_overlap = TRUE) +
    
    ggtitle(name) +
    xlab("log2FC") + 
    ylab("-log10 padj") +
    theme(legend.position = "bottom", legend.key.size = unit(0.4, "cm"),
          legend.text = element_text(size = 9),
          plot.title = element_text(size = rel(1.1), hjust = 0.5),
          axis.title = element_text(size = rel(0.8)),
          axis.text = element_text(size = 7),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_blank()) +
    scale_color_manual(name = NULL, values = c("Upregulated" = "orange", 
                                               "Downregulated" = "blue", 
                                               "Non-DEG" = "gray"),
                       labels = c(paste("Downregulated genes:", num_downregulated),
                                  "Non-differentially expressed",
                                  paste("Upregulated genes:", num_upregulated))) +
    geom_vline(xintercept = c(-2, 2), linetype = "dashed", color = "black")+
    geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "black")
  
}

#####

#Function that runs GO analysis on set of genes (also requires gene2GO list). Returns all terms from topGO run and reduced versions from rrvigo
#(all and unique). For each set calculates number of genes and fold change 
run_GO_analysis <- function(degs_df, oli_geneID2GO) {
  degs <- factor(as.integer(gene_names %in% degs_df$gene))
  names(degs) <- gene_names
  GOdata <- new("topGOdata", ontology = "BP", allGenes = degs, annot = annFUN.gene2GO, gene2GO = oli_geneID2GO)
  resultFis <- runTest(GOdata, algorithm = "classic", statistic = "fisher")
  resultsFis_df <- as.data.frame(score(resultFis))
  resultsFis_df_signif <- subset(resultsFis_df, resultsFis_df$`score(resultFis)` < 0.01)
  GO_set <- GenTable(GOdata, classic=resultFis, ranksOf="classicFisher", 
                     topNodes = length(resultsFis_df_signif$`score(resultFis)`))
  
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
  
  #Get real number of genes per term for rrvgo output and calculate fold change:
  filtered_oli_geneID2GO <- oli_geneID2GO[gene_names %in% degs_df$gene]
  term_genes_subset <- length(filtered_oli_geneID2GO)
  term_genes_all <- length(oli_geneID2GO)
  
  calculate_num_genes <- function(term) {
    sum(sapply(filtered_oli_geneID2GO, function(gene_list) term %in% gene_list))
  }
  
  calculate_fold_change <- function(num_genes, term) {
    num_genes_term <- sum(sapply(oli_geneID2GO, function(gene_list) term %in% gene_list))
    (num_genes / term_genes_subset) / (num_genes_term / term_genes_all)
  }
  
  reducedTerms_uniq$Significant <- sapply(reducedTerms_uniq$go, calculate_num_genes)
  reducedTerms_uniq$fold_change <- mapply(calculate_fold_change, reducedTerms_uniq$Significant, reducedTerms_uniq$go)
  reducedTerms_uniq$GO_id_desc <- paste(reducedTerms_uniq$go, "|", reducedTerms_uniq$term)
  
  reducedTerms$Significant <- sapply(reducedTerms$go, calculate_num_genes)
  reducedTerms$fold_change <- mapply(calculate_fold_change, reducedTerms$Significant, reducedTerms$go)
  reducedTerms$GO_id_desc <- paste(reducedTerms$go, "|", reducedTerms$term)
  
  GO_subset$fold_change <- (GO_subset$Significant / term_genes_subset) / (GO_subset$Annotated / term_genes_all)
  GO_subset$score <- -log10(as.numeric(GO_subset$classic))
  GO_subset$GO_id_desc <- paste(GO_subset$GO.ID, "|", GO_subset$Term)
  
  return(list(reducedTerms_uniq = reducedTerms_uniq, GO_subset = GO_subset, reducedTerms = reducedTerms))
}

#####

# Function that plots GO histogram based on run_GO_analysis function results (see run_GO_analysis func)
plot_GO_hist <- function(rTerms_uniq_df, name) {
  rTerms_uniq_df$GO_id_desc <- str_trunc(rTerms_uniq_df$GO_id_desc, width = 50, ellipsis = "...")
  
  rTerms_uniq_df_top<- rTerms_uniq_df %>% top_n(25, fold_change)
  
  ggplot(data = rTerms_uniq_df_top, aes(x = fold_change, y = reorder(GO_id_desc, fold_change), fill = Significant)) +
    geom_bar(stat = "identity") +
    geom_point(aes(x = fold_change, y = reorder(GO_id_desc, fold_change), size = score), 
               shape = 21, fill = "yellow") +
    scale_fill_viridis_c(name = "Number of genes", option = "cividis") +
    labs(
      title = paste(name),
      y = "GO term: biological process",
      x = "Fold enrichment",
      size = "Enrichment score"
    ) +
    theme(
      axis.text.y = element_text(size = 8),
      plot.title = element_text(face = "bold", size = 10),
      legend.text = element_text(size = 8),
      legend.title = element_text(size = 8)
    )
}

#####

# Function that finds genes from DEG list in annotation based on specific GO-term
get_term_genes <- function(degs, GO, oli_geneID2GO, annotation) {
  
  degs2GO <- oli_geneID2GO[gene_names %in% degs$gene]
  GOI <- names(Filter(function(gene_list) GO %in% gene_list, degs2GO))
  GOI <- annotation[annotation$query %in% GOI, ]
  return(GOI)
}

#####

# Function that creates a z-score matrix for set of genes (see get_term_genes function)
make_zscore_matrix <- function(GOI, normalized_counts) {
  norm_expr_goi <- subset(normalized_counts, normalized_counts$gene %in% GOI$query)
  
  norm_expr_goi$gene <- paste(norm_expr_goi$gene, " | ", 
                              GOI$Preferred_name[match(norm_expr_goi$gene, 
                                                       GOI$query)])
  
  avg_norm_expr_goi <- data.frame(
    gene = norm_expr_goi$gene,
    egg = rowMeans(norm_expr_goi[, c(2:4)]),
    blastula = rowMeans(norm_expr_goi[, c(5:7)]),
    gastrula = rowMeans(norm_expr_goi[, c(6:9)]),
    trochophore = rowMeans(norm_expr_goi[, c(10:13)]),
    adult = rowMeans(norm_expr_goi[, c(14:16)])
  )
  
  gene <- avg_norm_expr_goi[,1]
  vals <- as.matrix(avg_norm_expr_goi[,2:ncol(avg_norm_expr_goi)])
  
  score <- NULL
  for (i in 1:nrow(vals)) {
    row <- vals[i,]
    zscore <- (row - mean(row)) / sd(row)
    score <- rbind(score, zscore)
  }
  
  row.names(score) <- gene
  return(score)
}

#####

# Function that filters a DEGs list (see classify_DEGs function). The result table will have only genes (to some extent)
# that are related to tgf-beta, wnt, fgf, notch, sonic-hedgehog, etc pathways alongside transcriptional cis-regulators. 
get_important_development_genes <- function(DEG_set) {
  
  interesting_GOs <- c(
    "GO:0000976", "GO:0000975", "GO:0000984", "GO:0001017", "GO:0044212",
    "GO:0001228", "GO:0001077", "GO:0001205", "GO:0001209", "GO:0001211",
    "GO:0001212", "GO:0001213", "GO:0140297", "GO:0001107", "GO:0033613",
    "GO:0070491", "GO:0007219", "GO:0030179", "GO:0071363", "GO:0007169",
    "GO:0007178", "GO:0000165", "GO:0000122", "GO:0010553", "GO:0045816",
    "GO:0000978", "GO:0000980", "GO:0003002"
  )
    
  interesting_GOs <- paste(interesting_GOs, collapse = "|")
  interesting_genes <- subset(DEG_set, grepl(interesting_GOs, DEG_set$GOs))
  
  #I found out that many Forkhead-family genes don't have any GOs in eggNOG annotation. Thus this part of code exists:
  forkhead_genes <- subset(DEG_set,  grepl('Forkhead', DEG_set$PFAMs))
  interesting_genes <- unique(rbind(interesting_genes, forkhead_genes))
  
  return(interesting_genes)
}

#####

#Function that finds annotation for specific genes in list DEGs df based on name or/and description or/and PFAMs
get_genes_by_name <- function(name=NULL, description=NULL, pfam=NULL, datasets) {
  GOIs <- data.frame()
  
  for (dataset in datasets) {
    subset_data <- data.frame()
    
    if (!is.null(name)) {
      subset_data <- rbind(subset_data, subset(dataset, grepl(name, Preferred_name)))
    }
    if (!is.null(description)) {
      subset_data <-  rbind(subset_data, subset(dataset, grepl(description, Description)))
    }
    if (!is.null(pfam)) {
      subset_data <- rbind(subset_data, subset(dataset, grepl(pfam, PFAMs)))
    }
    
    GOIs <- rbind(GOIs, subset_data)
  }
  
  GOIs <- unique(GOIs)
  GOIs <- annotation[annotation$query %in% GOIs$gene, ]
  
  return(GOIs)
}
