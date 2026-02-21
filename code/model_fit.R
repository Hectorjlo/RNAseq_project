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
