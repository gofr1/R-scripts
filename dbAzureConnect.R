library(RODBC)
source("getConStr.R")

dbConString <- getConnectionString('azure_ad', '../python_learning/.env/db.conf', ';')

dbhandle <- odbcDriverConnect(dbConString)
res <- sqlQuery(dbhandle, 'select * FROM [dbo].[currency]')
odbcClose(dbhandle)
# odbcCloseAll()

print(res[,c(2:3)]) 
