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

# embryonic stem cells (ESCs): 
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

# For a better visulization the tissues the names of them were changed to compact names
# differentiating embryonic stem cells into embryoid bodies as Eembryod bodies
rse_gene_SRP130963$sra_attribute.tissue <- gsub(
  "differentiating embryonic stem cells into embryoid bodies",
  "Embryoid bodies",
  rse_gene_SRP130963$sra_attribute.tissue
)
# differentiating embryonic stem cells into episcs as Epiblast Stem Cells
rse_gene_SRP130963$sra_attribute.tissue <- gsub(
  "differentiating embryonic stem cells into episcs",
  "Epiblast SCs",
  rse_gene_SRP130963$sra_attribute.tissue
)
# differentiating embryonic stem cells into neural cells as differentiating ESCs into Neural Cells
rse_gene_SRP130963$sra_attribute.tissue <- gsub(
  "differentiating embryonic stem cells into neural cells",
  "differentiating ESCs into Neural Cells",
  rse_gene_SRP130963$sra_attribute.tissue
)
# Using ESC as Embryonic Stem Cells 
rse_gene_SRP130963$sra_attribute.tissue <- gsub(
  "embryonic stem cells",
  "ESCs",
  rse_gene_SRP130963$sra_attribute.tissue
)

# After the use of gsub the factor needs to be build again
rse_gene_SRP130963$sra_attribute.tissue <- factor(rse_gene_SRP130963$sra_attribute.tissue)


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

# We can go even further and analyze between tissues with:
# > with(colData(rse_gene_SRP130963), tapply(assigned_gene_prop, sra_attribute.tissue, summary))
# (output not display for simplicity)
# But all individual summaries are as the global one of gene prop

# Let's continue at the qc, this time let's analyze the samples for it's avarage expression
# If the avarage expression of a sample is less than .1 would be dropped
# It is more robust to perform the qc that filters by expression using a well worked library
# for example the library edgeR
# The code will use the edgeR library if it's not installed would need to be installed with
# install.packages("edgeR")

# Load the library edgeR
library(edgeR)

# For the filter, it's needed to create a DGE object with the counts of the assay
dge <- DGEList(counts = assay(rse_gene_SRP130963, "counts"))

# Define the experimental group, were the filter would be applied
experimental_group <- rse_gene_SRP130963$sra_attribute.tissue

# Filter out with edgeR
# edgeR uses an internal logic to discriminate if the expression is statistical important
# the funtion returns a logic vector to decide for each gene
filter <- filterByExpr(dge, group = experimental_group)
# Take a look to the table of filter
# > table(filter)
# FALSE  TRUE 
# 33164 22257
# The funtion took 22257 genes as TRUE, this means that those genes had the enough expression
# to be considered in further analysis

# Apply the filter to the RSE object
# Overwrite the RSE but save the total genes for later comparation
total_genes <- nrow(rse_gene_SRP130963)
rse_gene_SRP130963 <- rse_gene_SRP130963[filter, ]

# Check the new dimensions (genes x samples) that were left after the screening
# > dim(rse_gene_SRP130963)
# [1] 22257    45

# Percentage of genes that were retain after filtration
print("Percentage of genes that were retain after filtration")
round((nrow(rse_gene_SRP130963) / total_genes) * 100, 2)

# Note: It is importat to apply a normalization of the data, is needed because the raw
# counts can be influenciated technical bias as library size or the detp of the sequencing
# once the normalization is done the samples can be compared.

# As the filter an DGEList object is needed
dge <- DGEList(
  counts = assay(rse_gene_SRP130963, "counts"),
  genes = rowData(rse_gene_SRP130963),
  samples = colData(rse_gene_SRP130963)
)
# Apply the normalization with the funtion of edgeR funtion calcNormFactors
dge <- calcNormFactors(dge)

# - - Design of the model matrix - - #
# Here it's defined the stadistical model matrix that would be used in further analysis
# We defined the covariables of a linear model, here only one would be taken as the data
# has no further information and also the gene prop
# The use of relevel is meant to order in a specific way the variables as to define the baseline
rse_gene_SRP130963$sra_attribute.tissue <- relevel(rse_gene_SRP130963$sra_attribute.tissue, "ESCs", "Embryoid bodies", "Epiblast SCs", "differentiating ESCs into Neural Cells")
model_matrix <-  model.matrix(~ sra_attribute.tissue + assigned_gene_prop, data = as.data.frame(colData(rse_gene_SRP130963)))
# Explore the matrix
colnames(model_matrix)

# Then to perform a data exploration, we can use the library of variancePartition and limma to create lineal
# model, and also check that our variables choosen were the ones that explain the majority of the variance of 
# the data, so we load both libraries 
library(limma)
library(variancePartition)

# Using a function of the library limma that transform RNA-Seq Data Ready for Linear Modelling
vGene <- voom(dge, design = model_matrix, plot = FALSE)

# Asigning a formula as the type of tissues found
formula <- ~ sra_attribute.tissue + assigned_gene_prop

# Then a model is fit to a lineal model that allow to explain the variance given the variable (formula) passed
# to the function fitExtarctVarPartModel()
varPart <- fitExtractVarPartModel(vGene, formula, as.data.frame(colData(rse_gene_SRP130963)))

# And then visualize how much of the variance is explain by our variable
plotVarPart(varPart)

# For is project, the plot shows that only about 25% of our variable can explain all the variance of the data
# this is an interesting result, given that this set of data only has a variable (tissue) as the main driver of variance
# the plot show a possible hidden variables that are not considered

# After a deep investigation, tried to find possible causes for the low variance, the conclusion is that the
# cells themselves are not in states too different from each that the variance is low. This is justified because
# even tough the option of batch effect was considered there are not varibles that show possible batch effect
# so the conclusion to this situation is that: All tissues (state) of the samples are in a gradient of differentiation
# 3 of them in a proccess in early differentiation and 1 in a complete pluripotent state, so the variance is not indicating
# bad quality, in fact it is not a huge difference of this 4 early develoment tissues but them still show a 
# separation between them that will allow the next step in the DE.


# To keep a separation of the code, the vGene that cointains the data ready for the limma analysis will be exported
# as the RSE object transformed in this code.

# Save the vGene object
saveRDS(vGene, file = "processed-data/vGene_DE_ready")

# Save the RSE transformed in this code
saveRDS(rse_gene_SRP130963, file = "processed-data/rse_gene_SRP130963_DE_ready")