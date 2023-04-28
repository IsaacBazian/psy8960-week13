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

# Analysis

# Total number of managers
dbGetQuery(conn, "SELECT COUNT(*) 
           FROM datascience_8960_table;")

# Total number of unique managers by id
dbGetQuery(conn, "SELECT COUNT(DISTINCT employee_id) 
           FROM datascience_8960_table;")

# Summary of managers by location, not hired as managers
dbGetQuery(conn, "SELECT city, COUNT(employee_id) 
           FROM datascience_8960_table
           WHERE manager_hire = 'N'
           GROUP BY city;")

# Average and standard deviation of tenure split by performance level
dbGetQuery(conn, "SELECT performance_group, AVG(yrs_employed), STDDEV(yrs_employed)
           FROM datascience_8960_table
           GROUP BY performance_group;")

# Top 3 managers by location
dbGetQuery(conn, "WITH temp_ranked AS (
           SELECT *, RANK() OVER(PARTITION BY city ORDER BY test_score DESC) AS manager_rank
           FROM datascience_8960_table)
           SELECT employee_id, test_score, city
           FROM temp_ranked
           WHERE manager_rank <= 3")






