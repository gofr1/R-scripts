library(mongolite)

source("getConStr.R")

mongo_conn_param <- get_urllike_connection(
    "mongo_local",
    "../python_learning/.env/db.conf",
    ",",
    "mongodb"
)

mongo_test <- mongo(
  collection = "products",
  db = "test",
  url = mongo_conn_param
)

mongo_test$find()
#*       item qty        type
#* 1    Mpuse  50    Computer
#* 2 Keyboard  20 accessories
#* 3  Monitor 100        <NA>

zips <- mongo(
  collection = "zips",
  db = "test",
  url = mongo_conn_param
)

allzips <- zips$find('{}')
print(allzips)

ma_nb_zips <- zips$find('{"state" : "MA", "city": "NEW BEDFORD"}')
print(ma_nb_zips)

#*          city                 loc   pop state
#* 1 NEW BEDFORD -70.91675, 41.61272 13424    MA
#* 2 NEW BEDFORD -70.93555, 41.69134 23661    MA
#* 3 NEW BEDFORD -70.93243, 41.65997 16236    MA
#* 4 NEW BEDFORD -70.93720, 41.63475 46426    MA

nrow(ma_nb_zips)
#* [1] 4
