if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

# Install Bioconductor packages
BiocManager::install(c("recount3", "edgeR", "limma", "variancePartition", "SummarizedExperiment"))

# Install CRAN packages
install.packages(c("ggplot2", "ggrepel", "patchwork", "pheatmap", "RColorBrewer"))