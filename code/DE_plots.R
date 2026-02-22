# Load the library limma to visualize plots of DE
library(limma)

# Load and save the the RSE object procceded and ready for the DE analysis
rse_gene_SRP130963_DE_ready <- readRDS(
  file = "processed-data/rse_gene_SRP130963_DE_ready"
)

# Load and save the counts in logCPM (object created with voom())
vGene <- readRDS(
  file = "processed-data/vGene_DE_ready"
) 
