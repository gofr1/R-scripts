library(odbc)

source("getConStr.R")

dbConString <- getConnectionString('azure_ad', '../python_learning/.env/db.conf', ';')

az <- odbc::dbConnect(odbc(), .connection_string = dbConString)
result <- dbSendQuery(az, "select * FROM [dbo].[currency]")
res <- dbFetch(result)

print(res[,c(2:3)]) 
