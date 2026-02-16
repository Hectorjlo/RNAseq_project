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
