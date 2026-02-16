# Load of the library of recount3
library("recount3")

# To search for a specific project, request the available projects in recount3 of mice 
mouse_projects_df <- available_projects(organism = "mouse")

# Print the head of the data.frame 
head(mouse_projects_df)


# Using subset to extract the info of the project
project_info <- subset(
    mouse_projects_df,
    project == "SRP130963" & project_type == "data_sources"
)
# 
# I chose the project SRP130963 because it has a fair ammount of samples and won't be so computational expensive to process the data of it
# 
#      project organism file_source     project_home project_type n_samples
# 98 SRP130963    mouse         sra data_sources/sra data_sources        45

# It's time to create the RSE object 
# Given that we load the recount3 library, SummarizedExperiment is also loaded
rse_gene_SRP130963 <- create_rse(project_info)

# Display the info of the RSE object
rse_gene_SRP130963

######################
# class: RangedSummarizedExperiment 
# dim: 55421 45 
# metadata(8): time_created recount3_version ... annotation recount3_url
# assays(1): raw_counts
# rownames(55421): ENSMUSG00000079800.2 ENSMUSG00000095092.1 ... ENSMUSG00000096850.1 ENSMUSG00000099871.1
# rowData names(11): source type ... havana_gene tag
# colnames(45): SRR6495000 SRR6495001 ... SRR6494998 SRR6494999
# colData names(177): rail_id external_id ... recount_pred.curated.cell_line BigWigUR
#
# This object has 55421 genes, and the 45 samples 
######################

# In the recount3 documentation is said that:
# "recount3 provides processed RNA-seq data for human and mouse in file formats similar to recount2, 
#  which at its core is based on coverage bigWig files and exon-exon junction counts"
#
# To work downstream the pipeline we need to transform the raw data to the expresion matrices 
# So we use the funtion 'compute_read_counts' of recount3 and add those like an assay of name "counts" to our RSE
assay(rse_gene_SRP130963, "counts") <- compute_read_counts(rse_gene_SRP130963)

# From the bioconductor package "recount3":
# For studies from SRA, we can further extract the SRA attributes using expand_sra_attributes()
# We can extract more information of the experiments with that tool
rse_gene_SRP130963 <- expand_sra_attributes(rse_gene_SRP130963)
# --snip-- (rse_gene_SRP130963 display)
# colData names(181): rail_id external_id ... sra_attribute.source_name sra_attribute.tissue
# This funtion has added for this expermient 4 more columns with information

# The SummarizedExperiment package has a save method to export our RSE object and use it in others scripts allowing
# a segmented workflow, to fulfill the templete of the LIBD, the raw and processed data will be saved
# (change dir if necessary)
saveRDS(create_rse(project_info), file = "raw-data/raw_rse_gene_SRP130963") # Raw RSE

saveRDS(rse_gene_SRP130963, file = "processed-data/rse_gene_SRP130963") # Processed RSE


