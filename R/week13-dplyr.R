#Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(keyring)
library(RMariaDB)



#Data Import and Cleaning

#The following code established a connection to the LATIS mySQL, gets the table of interest from the cla_tntlab database, and saves it as a csv.
#This code is now commented out because following code simply takes the downloaded data from this project's directory.
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
