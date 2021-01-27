library(RODBC)
source("getConStr.R")

dbconstring <- getConnectionString(
    "mssql_local",
    "../python_learning/.env/db.conf",
    ";"
)

dbhandle <- odbcDriverConnect(dbconstring)
res <- sqlQuery(dbhandle, "SELECT * FROM sys.databases")
odbcClose(dbhandle)
# odbcCloseAll()

print(res[, c(1:2)]) # print first two columns
