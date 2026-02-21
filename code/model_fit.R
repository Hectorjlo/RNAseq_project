# Load the recount3 library 
library(recount3)

# Load and save the SRE object
rse_gene_SRP130963 <- readRDS(file = "processed-data/rse_gene_SRP130963")

# The atrributes of the SRE object are needed to be casted to factors or numerics
# For this RSE the sra attributes are all categoric variables so only factors will
# be applied

# All text will be formated to lowercase, in this way all text is only in one format
rse_gene_SRP130963$sra_attribute.background_strain <- factor(tolower(rse_gene_SRP130963$sra_attribute.background_strain))
rse_gene_SRP130963$sra_attribute.genotype <- factor(tolower(rse_gene_SRP130963$sra_attribute.genotype))
rse_gene_SRP130963$sra_attribute.source_name <- factor(tolower(rse_gene_SRP130963$sra_attribute.source_name))
rse_gene_SRP130963$sra_attribute.tissue <- factor(tolower(rse_gene_SRP130963$sra_attribute.tissue))
