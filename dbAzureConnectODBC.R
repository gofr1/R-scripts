library(odbc)

source("getConStr.R")

dbconstring <- getConnectionString(
    "azure_ad",
    "../python_learning/.env/db.conf",
    ";"
)

az <- odbc::dbConnect(odbc(), .connection_string = dbconstring)
result <- dbSendQuery(az, "select * FROM [dbo].[currency]")
res <- dbFetch(result)

print(res[, c(2:3)])