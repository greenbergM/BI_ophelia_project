# Gene expression dynamics in the life cycle of the annelid *Ophelia limacina*

Authors: 

- Mikhail Greenberg, SPbU Embryology department (student)
- Vitaly Kozin, SPbU Embryology department (supervisor)
- Ilya Borisenko, SPbU Embryology department (supervisor)

## Introduction
The Spiralia group is one of the three major bilaterian clades. One of the key features of this group is its stereotypical embryonic development with early establishment of cell fates [^1] with different Spiralia species utilizing autonomous (dependent on maternal factors) and conditional (dependent on cell-cell interactions) modes of cell specification. Annelids are one of the main model taxa for studying development and evolution of Spiralia, due to of their diverse life cycles and embryonic patterns [^1].

One of the most intriguing and poorly understood aspects of Spiralian embryogenesis is zygotic genome activation (ZGA), which has been shown to act as a trigger for the initiation of complex developmental processes in other Bilateria groups [^2]. However, It is unclear how ZGA is associated with different developmental modes in Spiralia. Transcriptome profiling of early developmental stages of the unequally cleaving annelid *Platynereis* revealed that ZGA proceeds in several waves, with the major transition to the zygotic landscape coinciding with the completion of the spiral cleavage programme after autonomous specification of different cell lineages [^3][^4]. Investigating whether these developmental processes in the equally cleaving annelid *Ophelia limacina* have similar dynamics would contribute substantially to the field of evolutionary developmental biology of the Spiralia clade.

**Aim:** Investigate temporal expression patterns of developmental genes throughout the life cycle of Ophelia limacina.

**Objectives:**  
* Transcriptome assembly for different stages of *O. limacina* life cycle
* Differential gene expression analysis (DE) for *O. limacina* stages
	* Gene set enrichment analysis (GSEA) for differentially expressed genes (DEGs)
	* Identification of developmental genes in DEGs
* Identification of co-expressed gene clusters
  * Gene set enrichment analysis (GSEA) for clustered genes

### Data
*hpf - hours post fertilisation*

*dpf - days post fertilisation*

The data available at the start of the project were: paired reads (bulk RNA-seq data) after basic quality check and trimming for 5 stages of the *O. limacina* life cycle: 

- 0 hpf - **unfertilised egg**
- 10 hpf - **32-cell blastula**
- 24 hpf - **100+ cell gastrula**
- 4 dpf - **trochophore larvae**
- 3 years - **adult male**

There were 3 biological replicates for each stage. 

## Workflow
### Whole workflow overview:
![](pics/workflow.png)

### Decontamination and assembly

All reads were decontaminated using [Kraken2](https://github.com/DerrickWood/kraken2). The PlusPF (standard plus protozoa and fungi; 2022-09-04T165121Z) Kraken2 database was used for classification. Kraken2 reports visualisation performed with the online tool [Pavian](https://fbreitwieser.shinyapps.io/pavian/).

**Kraken2 report visualisation for merged reads:**
![](pics/kraken2_results.png) 

For *de novo* transcriptome assembly were used 2 different assemblers: [rnaSPAdes](https://cab.spbu.ru/software/rnaspades/) (v.3.15.5) and [Trinity](https://github.com/trinityrnaseq/)(v.2.15.1). **Both decontamination and assembly were performed using public [Galaxy](https://github.com/galaxyproject) servers**.

Contigs in each assembly were clustered using [CDHIT-est](https://github.com/weizhongli/cdhit) (v.4.8.1). Contigs with 95% identity were clustered (both strands compared). Contig filtration was performed using [Transrate] (https://hibberdlab.com/transrate/) (v.1.0.3). Assemblies were checked for completeness using [BUSCO](https://gitlab.com/ezlab/busco) (v.5.4.4) against the Metazoa odb10. 

Final assembly was picked based on Transrate scores and BUSCO results (good_oli<...> - assembly after clusterization and Transrate filtration):

![](pics/busco_results.pmg.png) 

| Transrate Metric | rnaSPAdes assembly after clusterization | Trinity assembly after clusterisation |
|---|---|---|
| Contigs before filtering | 536541 | 531911 |
| Contigs after filtering | 532844 | 399678 |
| Percent of well-assembled contigs | **99,3%** | 75,1% |
| Percent of fragments mapped | **95,8%** | 93,1% |
| GC-content | 42,2% | 42% |
| Assembly score | 0.65593 | 0.34640 |
| Optimal score | **0.67449** | 0.54867  |

## References
[^1]: Henry J. Q. (2014). Spiralian model systems. The International journal of developmental biology, 58(6-8), 389–401. https://doi.org/10.1387/ijdb.140127jh
[^2]: Lee, M. T., Bonneau, A. R., & Giraldez, A. J. (2014). Zygotic genome activation during the maternal-to-zygotic transition. Annual review of cell and developmental biology, 30, 581–613. https://doi.org/10.1146/annurev-cellbio-100913-013027
[^3]: Chou, H. C., Pruitt, M. M., Bastin, B. R., & Schneider, S. Q. (2016). A transcriptional blueprint for a spiral-cleaving embryo. BMC genomics, 17, 552. https://doi.org/10.1186/s12864-016-2860-6 ↩
[^4]: Vopalensky, P., Tosches, M. A., Achim, K., Handberg-Thorsager, M., & Arendt, D. (2019). From spiral cleavage to bilateral symmetry: the developmental cell lineage of the annelid brain. BMC biology, 17(1), 81. https://doi.org/10.1186/s12915-019-0705-x 
