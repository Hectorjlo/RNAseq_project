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

