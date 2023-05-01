# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(keyring)
library(RMariaDB)



# Data Import and Cleaning

# The following code establishes a connection to the LATIS mySQL, gets the table of interest from the cla_tntlab database, and saves it as a csv.
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
# Every row of this table represents a manager, so this code simply gets the 
# number of rows in the table
n_managers <- nrow(week13_tbl)
n_managers

# Total number of unique managers by id
# The unique function returns a vector with every unique value of employee_id;
# therefore, the number of entries in that vector is the number of unique managers
n_managers_unique <- length(unique(week13_tbl$employee_id))
n_managers_unique

# Summary of managers by location, not hired as managers
# First we filter to only get the managers not originally hired as managers,
# then we group the remainder by the city they work in, and get the count
# of managers in each group to get managers per city
managers_by_location_not_hired_tbl <- week13_tbl %>% 
  filter(manager_hire == "N") %>% 
  group_by(city) %>%
  count()
managers_by_location_not_hired_tbl

# Average and standard deviation of tenure split by performance level
# First we group managers by their performance level, then we calculate
# the mean and standard deviation of number of years of employment for each group
tenure_tbl <- week13_tbl %>% 
  group_by(performance_group) %>% 
  summarise(average_tenure = mean(yrs_employed), sd_tenure = sd(yrs_employed))
tenure_tbl

# Top 3 managers by location
# First we group managers by city, then we arrange the table first in alphabetical
# order of city, then by descending test_score. We then use mutate to add a rank
# to each manager based on their descending test_score, filter to only include
# those managers with a rank of 3 or less, and then select only the 3 variables
# we want in the end. Note that by using dense_rank, there are no gaps in sequential
# ranks even if there are ties; the instructions were ambiguous as to whether
# these gaps are desired or not, so I have erred on the side of including 
# more information.
top_managers_tbl <- week13_tbl %>% 
  group_by(city) %>% 
  arrange(city, desc(test_score)) %>% 
  mutate(rank = dense_rank(desc(test_score))) %>% 
  filter(rank <= 3) %>% 
  select(employee_id, test_score, city)
top_managers_tbl






