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

# Displaying tables for each sra attributes:

# > table(rse_gene_SRP130963$sra_attribute.tissue)
#
# differentiating embryonic stem cells into embryoid bodies 
#                                                        14 
#          differentiating embryonic stem cells into episcs 
#                                                        13 
#    differentiating embryonic stem cells into neural cells 
#                                                        14 
#                                      embryonic stem cells 
#                                                         4 
# > table(rse_gene_SRP130963$sra_attribute.genotype)

# wild type 
#        45 
# > table(rse_gene_SRP130963$sra_attribute.background_strain)

# 129/ola 
#      45 
# > table(rse_gene_SRP130963$sra_attribute.source_name)

# differentiating embryonic stem cells into embryoid bodies 
#                                                        14 
#          differentiating embryonic stem cells into episcs 
#                                                        13 
#    differentiating embryonic stem cells into neural cells 
#                                                        14 
#                                      embryonic stem cells 
#                                                         4

# The data shows that all the samples are from the same genotype and same strain
# This is not a limitation for the analysis, in fact this shadows possible confusing 
# variables that could add noise to the analysis

# The straight-forward approach given that the genotype and strain are the same for 
# all the samples, is to compare the expressions between the tissues (or source name)

# This is possible bacause the tissues are from different stages of development:
# (from more pluripotent to more differentiated)

# differentiating embryonic stem cells into embryoid bodies (ESCs): 
#     Pluripotent stem cells derived from the inner cell mass of a blastocyst. 
#     They possess the unique ability to self-renew indefinitely and can 
#     differentiate into all three germ layers: ectoderm, mesoderm, and endoderm.

# differentiating ESCs into Embryoid Bodies (EBs): 
#     A method of spontaneous differentiation where ESCs are grown in 
#     non-adherent conditions to form three-dimensional aggregates. 
#     EBs mimic early embryonic development and contain a disorganized 
#     mix of cells from all three primary germ layers.

# differentiating ESCs into EpiSCs (Epiblast Stem Cells): 
#     Represents a transition from a "naive" pluripotent state to a "primed" 
#     state. EpiSCs are derived from the post-implantation epiblast and 
#     exhibit different growth factor requirements and epigenetic 
#     landscapes compared to original ESCs.

# differentiating ESCs into Neural Cells: 
#     A directed differentiation process that guides pluripotent cells 
#     toward a neuroectodermal lineage. This typically involves inhibiting 
#     BMP signaling to produce neural progenitors, neurons, astrocytes, 
#     and oligodendrocytes for disease modeling or regenerative research.

# In this way the RNA expressions of this tissues will be compared


# Before the analysis, it's important to perform a quality check(qc) of the data 

# One qc is the proportion of reads assigned to genes (via featureCounts) by all reads
# The closer to one means that the reads were high quality and almost all reads were 
# assigned to genes, this method is called gene prop

# To accomplish the qc we'll add a column to our RSE
rse_gene_SRP130963$assigned_gene_prop <- rse_gene_SRP130963$recount_qc.gene_fc_count_all.assigned / rse_gene_SRP130963$recount_qc.gene_fc_count_all.total
# Displaying the summary
# > summary(rse_gene_SRP130963$assigned_gene_prop)
#    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#  0.5893  0.6684  0.6858  0.6827  0.7003  0.7220

# The gene prop of the data is well agrupated but as a double-check
# We can display a boxplot
# > boxplot(rse_gene_SRP130963$assigned_gene_prop)
# The box plot shows a low outlier, and it the one with the lowest gene prop (.5893)
# But it's not essencial to delete it, gene_prop tell us that more than half of the total
# reads are assigned to genes. If we'd found a score of .3 or less those would need to be 
# deleted

# We can go even further and analyse between tissues with:
# > with(colData(rse_gene_SRP130963), tapply(assigned_gene_prop, sra_attribute.tissue, summary))
# (output not display for simplicity)
# But all individual summaries are as the global one of gene prop

