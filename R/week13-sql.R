# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(keyring)
library(RMariaDB)




# Data Import and Cleaning

# The following code establishes a connection to the LATIS mySQL so we can access our data of interest
conn <- dbConnect(MariaDB(),
                  user="bazia001",
                  password=key_get("latis-mysql","bazia001"),
                  host="mysql-prod5.oit.umn.edu",
                  port=3306,
                  ssl.ca = '../mysql_hotel_umn_20220728_interm.cer'
)

dbExecute(conn, "USE cla_tntlab;")



