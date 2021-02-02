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
while (!is.null(x <- it$one())) {
  cat(sprintf("Found %.2f carat diamond for $%d\n", x$carat, x$price))
}

# Select by date
# Get some data
mydata <- jsonlite::fromJSON(
  "https://api.github.com/repos/jeroen/mongolite/issues"
)
mydata$title <- paste0(substr(mydata$title, 1, 40), "...")
mydata$created_at <- strptime(mydata$created_at, "%Y-%m-%dT%H:%M:%SZ", "UTC")
mydata$closed_at <- strptime(mydata$closed_at, "%Y-%m-%dT%H:%M:%SZ", "UTC")

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
mongolite_issues$find(fields = '{"created_at":true, "_id":true}', limit = 5)
#*                        _id          created_at
#* 1 601542ad7ec71461353392c2 2020-12-22 11:46:29
#* 2 601542ad7ec71461353392c3 2020-10-22 10:30:02
#* 3 601542ad7ec71461353392c4 2020-06-12 16:02:33
#* 4 601542ad7ec71461353392c5 2020-06-11 17:05:38
#* 5 601542ad7ec71461353392c6 2020-06-02 14:12:07

# Use the {"$oid"} operator (similar to ObjectId() in mongodb)
# to select a record by it’s _id:
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

str <- c('{"name" : "John"}', '{"name": "Mark", "age" : 31}', '{"name": "Andrew"}')
subjects$insert(str)
#* List of 6
#*  $ nInserted  : int 3
#*  $ nMatched   : int 0
#*  $ nModified  : int 0
#*  $ nRemoved   : int 0
#*  $ nUpserted  : int 0
#*  $ writeErrors: list()

subjects$find(query = "{}", fields = "{}")
#*                        _id   name age
#* 1 6016780bbc0f7c489d7b5d68   John  NA
#* 2 6016780bbc0f7c489d7b5d69   Mark  31
#* 3 6016780bbc0f7c489d7b5d6a Andrew  NA

# Remove
subjects$count()
#* [1] 3

subjects$remove('{"name" : "Andrew"}')
subjects$count()
#* [1] 2

str <- c('{"name" : "Bob", "age" : 24}', '{"name": "Joe", "age" : 26}', '{"name": "Greg", "age" : 45}')
subjects$insert(str)
subjects$count()
#* [1] 5

# just_one option to delete a single record
subjects$remove('{"age" : {"$gte" : 30}}', just_one = TRUE)
subjects$count()
#* [1] 4

# To delete all records in the collection (but not the collection itself):
subjects$remove("{}")
subjects$count()
#* [1] 0

# drop() operator will delete an entire collection.
subjects$drop()

# Update and upsert
str <- c('{"name" : "John"}', '{"name": "Mark", "age" : 31}', '{"name": "Andrew"}')
subjects$insert(str)

subjects$find()
#*     name age
#* 1   John  NA
#* 2   Mark  31
#* 3 Andrew  NA

subjects$update('{"name":"John"}', '{"$set":{"age": 27}}')
#* List of 3
#*  $ modifiedCount: int 1
#*  $ matchedCount : int 1
#*  $ upsertedCount: int 0

subjects$find()
#*     name age
#* 1   John  27
#* 2   Mark  31
#* 3 Andrew  NA

# By default, the update() method updates a single document. To update multiple documents, use the multi option in the update() method.
subjects$update('{}', '{"$set":{"has_age": false}}', multiple = TRUE)
#* List of 3
#*  $ modifiedCount: int 3
#*  $ matchedCount : int 3
#*  $ upsertedCount: int 0

subjects$find()
#*     name age has_age
#* 1   John  27   FALSE
#* 2   Mark  31   FALSE
#* 3 Andrew  NA   FALSE

subjects$update('{"age" : {"$gte" : 0}}', '{"$set":{"has_age": true}}', multiple = TRUE)
#* List of 3
#*  $ modifiedCount: int 2
#*  $ matchedCount : int 2
#*  $ upsertedCount: int 0

subjects$find()
#*     name age has_age
#* 1   John  27    TRUE
#* 2   Mark  31    TRUE
#* 3 Andrew  NA   FALSE

# If no document matches the update condition, the default behavior of the update method is to do nothing.
# By specifying the upsert option to true, the update operation either updates matching document(s) or
# inserts a new document if no matching document exists.

subjects$update('{"name":"Greg"}', '{"$set":{"age": 28}}', upsert = TRUE)
#* List of 4
#*  $ modifiedCount: int 0
#*  $ matchedCount : int 0
#*  $ upsertedCount: int 1
#*  $ upsertedId   : chr "60167bd9e697844bb2a68161"

subjects$find()
#*     name age has_age
#* 1   John  27    TRUE
#* 2   Mark  31    TRUE
#* 3 Andrew  NA   FALSE
#* 4   Greg  28      NA

# Array Filters
# Starting in MongoDB 3.6, when updating an array field, you can specify 
# arrayFilters that determine which array elements to update.

students <- mongo(
  collection = "students",
  db = "test",
  url = mongo_conn_param
)
students$insert(c(
  '{ "student" : 1, "grades" : [ 4, 5, 3 ] }',
  '{ "student" : 2, "grades" : [ 5, 4, 4  ] }',
  '{ "student" : 3, "grades" : [ 5, 5, 3] }')
)

students$find()
#*   student  grades
#* 1       1 4, 5, 3
#* 2       2 5, 4, 4
#* 3       3 5, 5, 3

students$update(
  query = "{}",
  update = '{"$set":{"grades.$[element]":4}}',
  filters = '[{"element": {"$lte":4}}]',
  multiple = TRUE
)
#* List of 3
#*  $ modifiedCount: int 2
#*  $ matchedCount : int 3
#*  $ upsertedCount: int 0

students$find()
#*   student  grades
#* 1       1 4, 5, 4
#* 2       2 5, 4, 4
#* 3       3 5, 5, 4

# JSON

subjects$export(stdout())
#* { "_id" : { "$oid" : "60167abbbc0f7c489d7b5d6e" }, "name" : "John", "age" : 27, "has_age" : true }
#* { "_id" : { "$oid" : "60167abbbc0f7c489d7b5d6f" }, "name" : "Mark", "age" : 31, "has_age" : true }
#* { "_id" : { "$oid" : "60167abbbc0f7c489d7b5d70" }, "name" : "Andrew", "has_age" : false }
#* { "_id" : { "$oid" : "60167bd9e697844bb2a68161" }, "name" : "Greg", "age" : 28 }

# to file:
subjects$export(file("subjects.json"))

# Let’s remove the entire collection, and then import it back from the file:
subjects$drop()
subjects$count()
#* [1] 0

subjects$import(file("subjects.json"))
subjects$count()
#* [1] 4

# Export data as json to a memory buffer using raw connections:
con <- rawConnection(raw(), "wb")
subjects$export(con)
json <- rawToChar(rawConnectionValue(con))
df <- jsonlite::stream_in(textConnection(json), verbose = FALSE)
head(df)
close(con)
#*                       $oid   name age has_age
#* 1 60167abbbc0f7c489d7b5d6e   John  27    TRUE
#* 2 60167abbbc0f7c489d7b5d6f   Mark  31    TRUE
#* 3 60167abbbc0f7c489d7b5d70 Andrew  NA   FALSE
#* 4 60167bd9e697844bb2a68161   Greg  28      NA

# Jsonlite
mydata <- jsonlite::stream_in(file("subjects.json"), verbose = FALSE)
print(mydata)
# This is a convenient way to exchange data in a way with R users that might not have MongoDB.
#*                       $oid   name age has_age
#* 1 60167abbbc0f7c489d7b5d6e   John  27    TRUE
#* 2 60167abbbc0f7c489d7b5d6f   Mark  31    TRUE
#* 3 60167abbbc0f7c489d7b5d70 Andrew  NA   FALSE
#* 4 60167bd9e697844bb2a68161   Greg  28      NA

# jsonlite allows for exporting data in a way that is easy to import in Mongo:
jsonlite::stream_out(mtcars, file("mtcars.json"), verbose = FALSE)
mt <- mongo(
  collection = "mtcars",
  db = "test",
  url = mongo_conn_param
)
mt$import(file("mtcars.json"))
mt$find()
#*                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#* Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
#* Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#* Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#* ...

# Streaming
flt <- mongo(
  collection = "flights",
  db = "test",
  url = mongo_conn_param
)
flt$import(gzcon(curl::curl("https://jeroen.github.io/data/nycflights13.json.gz")))
flt$count()
#* [1] 336776

# Same in jsonlite:
#? flights <- jsonlite::stream_in(
#?   gzcon(curl::curl("https://jeroen.github.io/data/nycflights13.json.gz")), verbose = FALSE)
#? nrow(flights)

# BSON
# BSON is a binary version of JSON
flt$export(file("flights.bson"), bson = TRUE)
flt$drop()
# Import back:
flt$import(file("flights.bson"), bson = TRUE)
#* [1] 336776

# Aggregate
stats <- flt$aggregate(
  '[{"$group":{"_id":"$carrier", "count": {"$sum":1}, "average":{"$avg":"$distance"}}}]',
  options = '{"allowDiskUse":true}'
)
names(stats) <- c("carrier", "count", "average")
print(stats)
#*    carrier count   average
#* 1       VX  5162 2499.4822
#* 2       DL 48110 1236.9012
#* 3       AS   714 2402.0000
#* 4       9E 18460  530.2358
#* 5       US 20536  553.4563
#* 6       UA 58665 1529.1149
#* 7       MQ 26397  569.5327
#* 8       AA 32729 1340.2360
#* 9       FL  3260  664.8294
#* 10      WN 12275  996.2691
#* 11      B6 54635 1068.6215
#* 12      EV 54173  562.9917
#* 13      YV   601  375.0333
#* 14      OO    32  500.8125
#* 15      HA   342 4983.0000
#* 16      F9   685 1620.0000
library(ggplot2)
ggplot(aes(carrier, count), data = stats) + geom_col()

# Aggregation Iterators
iter <- flt$aggregate(
  '[{"$group":{"_id":"$carrier", "count": {"$sum":1}, "average":{"$avg":"$distance"}}}]',
  options = '{"allowDiskUse":true}',
  iterate = TRUE
)
# get first ten results
iter$json(10)
