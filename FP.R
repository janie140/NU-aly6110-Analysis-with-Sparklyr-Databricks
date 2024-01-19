cat("\014")  # clears console
rm(list = ls())  # clears global environment
try(dev.off(dev.list()["RStudioGD"]), silent = TRUE) # clears plots
try(p_unload(p_loaded(), character.only = TRUE), silent = TRUE) # clears packages
options(scipen = 100) # disables scientific notion for entire R session

# # load required packages
# library(sparklyr)
# library(dplyr)
# library(ggplot2)
# 
# library(pacman)
# p_load(tidyverse, dplyr, ggplot2, corrplot, skimr, RColorBrewer)

# # connect to databricks clutter
# sc <- spark_connect(method = "databricks")

# # load dataset into a Spark DataFrame
# # The dataset name is "fraud" in Databricks
# fraud <- spark_read_csv(sc, name = "fraud", path = "/FileStore/tables/filename.csv",
#                         header = TRUE, infer_schema = TRUE) 

# # load dataset in rstudio
# df <- read.csv('Electric_Vehicle_Population_Data.csv')

############################ EDA and DATA CLEANING #############################
# clean columns names
head(df)
colnames(df)
p_load(janitor)
df <- clean_names(df)

# descriptive statistics
skim(df) #data types, missing values, min, max, mean, sd, hist
sapply(df, function(x) sum(is.na(x))) #Check for missing values in entire data set

# remove some Identifier variables & unused columns
df <- subset(df, select = -c(vin_1_10,legislative_district, dol_vehicle_id,
                             vehicle_location, x2020_census_tract))

# filter WA state only
table(df$state) # have a small number of other states
df <- df |> filter(state == 'WA')

# What's the range of 'base_msrp' values?
hist(df$base_msrp) # a huge number of '0' values

# EV by County
gr_by_county <- df |> group_by(county) |> summarise(count = n()) |>
                                                      arrange(desc(count))  
gr_by_county$county <- factor(gr_by_county$county, levels = gr_by_county$county)  

ggplot(gr_by_county, aes(x = county, y = count, fill = count)) + geom_col() +
  labs(title = 'Electric Vehicles by County', x = "County", y = 'Number of EVs') +
  theme(axis.text.x = element_text(size = 7, angle = 45, hjust = 1, vjust = 1)) +
  scale_fill_gradient(low = "green", high = "darkgreen")

# EV by Manufacturers and their mean electric range
gr_by_make <- df |> group_by(make) |> summarise(count = n(),
                                          mean_electric_range = mean(electric_range)) |>
  arrange(desc(count))  

gr_by_make$make <- factor(gr_by_make$make, levels = rev(gr_by_make$make)) 

ggplot(gr_by_make, aes(x = count, y = make, fill = mean_electric_range)) +
  geom_col() +
  labs(title = 'Electric Vehicles by Manufacturers', x = "Number of EVs",
       y = 'Manufacturers') +
  scale_fill_gradient(low = "yellow", high = "darkorange")

# Create a scatter plot between Manufacturer and Basic Price
filtered_df <- df[df$base_msrp != 0, ]# Remove rows with '0' values in 'base_msrp'

ggplot(filtered_df, aes(x = make, y = base_msrp)) +
  geom_point(alpha = 0.6) +
  labs(title = "Scatter Plot: Manufacturer vs. Basic Price",
       x = "Manufacturer",
       y = "Basic Price") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# What is the distribution of data across the 'model_year' column?
ggplot(df, aes(x = model_year)) +
  geom_line(stat = "count", color = 'blue') +
  geom_point(stat = "count", color = 'blue') +
  labs(x = "Model Year", y = "Count",
       title = "Distribution of EVs Across Model Year") +
  scale_x_continuous(breaks = seq(min(df$model_year), max(df$model_year), by = 2))

###################### Top 10 Models and Their Manufacturers
# Calculate the count of each EV model
model_counts <- table(df$model)
top_10_models <- names(head(sort(model_counts, decreasing = TRUE), 10))

# Create a data frame for the top 10 models and their makes
top_models_df <- df[df$model %in% top_10_models, c("model", "make")]
top_models_df$model <- factor(top_models_df$model, levels = names(sort(model_counts)))

# Create a bar plot
ggplot(top_models_df, aes(x = model, fill = make)) +
  geom_bar() +
  coord_flip() +
  labs(title = "Top 10 EV Models and Their Manufacturers",
       x = "EV Model",
       y = "Number of vehicles",
       fill = 'Manufacturer') +
  theme_minimal() +
  theme(legend.position = "right")

##################### Top_models vs. Electric range
# Calculate mean electric_range for each model
mean_range <- df |> filter(model %in% top_10_models) |> 
  group_by(model) |> 
  summarise(mean_range = mean(electric_range, na.rm = TRUE))

top_models_df <- left_join(top_models_df, mean_range, by = "model")

ggplot(top_models_df, aes(x = factor(model,
                                     levels = names(sort(model_counts))), y = mean_range)) +
  geom_bar(stat = "identity") + coord_flip() +
  labs(title = "Top EV Models vs. Electric Range",
       x = "Top EV Models",
       y = "Electric Range")

################# How are 'electric_vehicle_type' and 'electric_range' related?
hist(df$electric_range) # Zero (0) is for the EVs range has not been researched

ggplot(df, aes(x = electric_vehicle_type, y = electric_range)) +
  geom_point(alpha = 0.6) +
  labs(title = "Electric Vehicle Type vs. Electric Range",
       x = "Electric Vehicle Type",
       y = "Electric Range")

#################### EV types pie chart
ev_type_df <- df |> group_by(electric_vehicle_type) |> summarise(count = n()) |> 
  mutate(percent = count/sum(count)*100)

ggplot(ev_type_df, aes(x = "", y = percent, fill = electric_vehicle_type)) +
  geom_bar(stat = "identity") +
  coord_polar("y", start = 0) +
  labs(title = "Distribution of Electric Vehicle Types",
       fill = "Electric Vehicle Type") +
  theme_void() + geom_text(aes(label = paste0(round(percent, 1), "%")),
                           position = position_stack(vjust = 0.5))

# What's the distribution of 'clean_alternative_fuel_vehicle_cafv_eligibility'?
cafv_eligibility <- df |>
  group_by(clean_alternative_fuel_vehicle_cafv_eligibility) |>
  summarise(count = n()) |> 
  mutate(percent = count/sum(count)*100)

ggplot(cafv_eligibility, aes(x = "", y = percent,
                                          fill = clean_alternative_fuel_vehicle_cafv_eligibility)) +
  geom_bar(stat = "identity") +
  coord_polar("y", start = 0) +
  labs(title = "Distribution of CAFV Eligibility",
       fill = "CAFV Eligibility") +
  theme_void() +
  scale_fill_manual(values = c('green', 'gray', 'red')) +
  geom_text(aes(label = paste0(round(percent, 1), "%")),
            position = position_stack(vjust = 0.5))

unique(df$electric_utility)
