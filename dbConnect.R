library(RODBC)
source("getConStr.R")

dbConString <- getConnectionString('mssql_local', '../python_learning/.env/db.conf', ';')

dbhandle <- odbcDriverConnect(dbConString)
res <- sqlQuery(dbhandle, 'select * from sys.databases')
odbcClose(dbhandle)
# odbcCloseAll()

print(res[,c(1:2)]) # print first two columns
