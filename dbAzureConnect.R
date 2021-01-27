library(RODBC)
source("getConStr.R")

dbconstring <- getConnectionString(
    "azure_ad",
    "../python_learning/.env/db.conf",
    ";"
)

dbhandle <- odbcDriverConnect(dbconstring)
res <- sqlQuery(dbhandle, "SELECT * FROM [dbo].[currency]")
odbcClose(dbhandle)
# odbcCloseAll()

print(res[, c(2:3)])
