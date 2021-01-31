library(mongolite)
options(width = 200)
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

# Select by date
# Get some data
mydata <- jsonlite::fromJSON("https://api.github.com/repos/jeroen/mongolite/issues")
mydata$title <- paste0(substr(mydata$title, 1, 40), "...")
mydata$created_at <- strptime(mydata$created_at, "%Y-%m-%dT%H:%M:%SZ", 'UTC')
mydata$closed_at <- strptime(mydata$closed_at, "%Y-%m-%dT%H:%M:%SZ", 'UTC')

# insert into new collection
mongolite_issues <- mongo(
  collection = "issues",
  db = "test",
  url = mongo_conn_param
)

mongolite_issues$insert(mydata)

# query data
mongolite_issues$find(
  query = '{"created_at": { "$gte" : { "$date" : "2020-01-01T00:00:00Z" }}}',
  fields = '{"created_at" : true, "user.login" : true, "title":true, "_id": false}'
)

# Select by _id
mongolite_issues$find(fields= '{"created_at":true, "_id":true}', limit = 5)
#*                        _id          created_at
#* 1 601542ad7ec71461353392c2 2020-12-22 11:46:29
#* 2 601542ad7ec71461353392c3 2020-10-22 10:30:02
#* 3 601542ad7ec71461353392c4 2020-06-12 16:02:33
#* 4 601542ad7ec71461353392c5 2020-06-11 17:05:38
#* 5 601542ad7ec71461353392c6 2020-06-02 14:12:07

# Use the {"$oid"} operator (similar to ObjectId() in mongodb) to select a record by it’s _id:
mongolite_issues$find(query = '{"_id" : {"$oid":"601542ad7ec71461353392c4"}}')

# Insert
# Create a new collection (optional)
test <- mongo(
  collection = "iris",
  db = "test",
  url = mongo_conn_param
)

test$insert(iris)
#* List of 5
#*  $ nInserted  : num 150
#*  $ nMatched   : num 0
#*  $ nRemoved   : num 0
#*  $ nUpserted  : num 0
#*  $ writeErrors: list()

# Or to insert just one object:
subjects <- mongo(
  collection = "subjects",
  db = "test",
  url = mongo_conn_param
)

str <- c('{"name" : "John"}' , '{"name": "Mark", "age" : 31}', '{"name": "Andrew"}')
subjects$insert(str)
#* List of 6
#*  $ nInserted  : int 3
#*  $ nMatched   : int 0
#*  $ nModified  : int 0
#*  $ nRemoved   : int 0
#*  $ nUpserted  : int 0
#*  $ writeErrors: list()

subjects$find(query = '{}', fields = '{}')
#*                        _id   name age
#* 1 6016780bbc0f7c489d7b5d68   John  NA
#* 2 6016780bbc0f7c489d7b5d69   Mark  31
#* 3 6016780bbc0f7c489d7b5d6a Andrew  NA