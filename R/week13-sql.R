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
# Every row of this table represents a manager, so this code simply gets the 
# number of rows in the table
dbGetQuery(conn, "SELECT COUNT(*) 
           FROM datascience_8960_table;")

# Total number of unique managers by id
# This code returns the count of how many distinct (that is, unique) employee_id
# values there are in this table
dbGetQuery(conn, "SELECT COUNT(DISTINCT employee_id) 
           FROM datascience_8960_table;")

# Summary of managers by location, not hired as managers
# This code keeps only managers who were not originally hired as managers, groups them
# by city, and displays the count of managers in each city
dbGetQuery(conn, "SELECT city, COUNT(employee_id) 
           FROM datascience_8960_table
           WHERE manager_hire = 'N'
           GROUP BY city;")

# Average and standard deviation of tenure split by performance level
# This code groups managers by performance_group, then calculates and displays 
# the mean and standard deviation of number of years of employment by each group
dbGetQuery(conn, "SELECT performance_group, AVG(yrs_employed), STDDEV(yrs_employed)
           FROM datascience_8960_table
           GROUP BY performance_group;")

# Top 3 managers by location
# This code creates a temporary field in the table, which is the dense ranks of
# descending manager test scores within each city. It then selects the 3 variables
# we want in the end wherever a manager's rank was less than or equal to 3.
# Note that by using DENSE_RANK, there are no gaps in sequential
# ranks even if there are ties; the instructions were ambiguous as to whether
# these gaps are desired or not, so I have erred on the side of including 
# more information.
dbGetQuery(conn, "WITH temp_ranked AS (
           SELECT *, DENSE_RANK() OVER(PARTITION BY city ORDER BY test_score DESC) AS manager_rank
           FROM datascience_8960_table)
           SELECT employee_id, test_score, city
           FROM temp_ranked
           WHERE manager_rank <= 3")






