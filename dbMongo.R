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

allzips <- zips$find("{}")
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

# create collection with example data
dmd <- mongo(
  collection = "diamonds",
  db = "test",
  url = mongo_conn_param
)

dmd$insert(ggplot2::diamonds)
#* List of 5
#*  $ nInserted  : num 53940
#*  $ nMatched   : num 0
#*  $ nRemoved   : num 0
#*  $ nUpserted  : num 0
#*  $ writeErrors: list()

# Example of a document
#* {
#*   "_id": {
#*     "$oid": "6013db824ed5d103a73ca256"
#*   },
#*   "carat": 0.23,
#*   "cut": "Ideal",
#*   "color": "E",
#*   "clarity": "SI2",
#*   "depth": 61.5,
#*   "table": 55,
#*   "price": 326,
#*   "x": 3.95,
#*   "y": 3.98,
#*   "z": 2.43
#* }

# Sorting & Filtering
sort_and_filter <- dmd$find(
  query = '{"cut" : "Premium", "price" : { "$lt" : 1000 } }',
  fields = '{"cut" : true, "clarity" : true, "_id": false}',
  limit = 5
)
print(sort_and_filter)
#*       cut clarity
#* 1 Premium     SI1
#* 2 Premium     VS2
#* 3 Premium     SI1
#* 4 Premium     SI2
#* 5 Premium      I1

# Indexing
# By default everything is sorted by _id, which is slow
system.time(dmd$find(sort = '{"price" : 1}', limit = 1))
#*   user  system elapsed
#*  0.000   0.002   0.044

# Let's add an index
dmd$index(add = '{"price" : 1}')
#*   v key._id key.price    name
#* 1 2       1        NA    _id_
#* 2 2      NA         1 price_1

system.time(dmd$find(sort = '{"price" : 1}', limit = 1))
#*   user  system elapsed
#*  0.002   0.000   0.003
# Faster!

# In order to speed up queries involving multiple fields,
# you can add a cross-index which intersects both field
dmd$index(add = '{"depth" : 1}')
dmd$index(add = '{"depth" : 1, "price" : 1}')

system.time(dmd$find(sort = '{"price" : 1, "depth" : 1}', limit = 1))

# Remove indexes
dmd$index(remove = "depth_1_price_1")
dmd$index(remove = "depth_1")
dmd$index(remove = "price_1")

# Iteration
# perform query and return the iterator
it <- dmd$iterate('{"cut" : "Premium"}', sort = '{"price": -1}', limit = 10)

# read records from the iterator one by one
while(!is.null(x <- it$one())) {
  cat(sprintf("Found %.2f carat diamond for $%d\n", x$carat, x$price))
}
