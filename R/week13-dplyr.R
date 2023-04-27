# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(keyring)
library(RMariaDB)



# Data Import and Cleaning

# The following code established a connection to the LATIS mySQL, gets the table of interest from the cla_tntlab database, and saves it as a csv.
# This code is now commented out because following code simply takes the downloaded data from this project's directory.
# conn <- dbConnect(MariaDB(),
#                   user="bazia001",
#                   password=key_get("latis-mysql","bazia001"),
#                   host="mysql-prod5.oit.umn.edu",
#                   port=3306,
#                   ssl.ca = '../mysql_hotel_umn_20220728_interm.cer'
# )
# 
# dbExecute(conn, "USE cla_tntlab;")
# week13_data <- dbGetQuery(conn, "SELECT * FROM datascience_8960_table")
# write_csv(week13_data, "../data/week13.csv")

#This code reads in the data we downloaded previously from the LATIS mySQL
week13_tbl <- read_csv("../data/week13.csv")


# Analysis

# Total number of managers
n_managers <- nrow(week13_tbl)
n_managers

# Total number of unique managers by id
n_managers_unique <- length(unique(week13_tbl$employee_id))
n_managers_unique

# Summary of managers by location, not hired as managers
managers_by_location_not_hired_tbl <- week13_tbl %>% 
  filter(manager_hire == "N") %>% 
  group_by(city) %>%
  count()
managers_by_location_not_hired_tbl

# Average and standard deviation of tenure split by performance level
tenure_tbl <- week13_tbl %>% 
  group_by(performance_group) %>% 
  summarise(average_tenure = mean(yrs_employed), sd_tenure = sd(yrs_employed))
tenure_tbl

# Top 3 managers by location
top_managers_tbl <- week13_tbl %>% 
  group_by(city) %>% 
  arrange(city, desc(test_score)) %>% 
  select(employee_id, test_score, city) %>% 
  slice_max(order_by = tibble(city, test_score), n = 3, with_ties = T)
top_managers_tbl






