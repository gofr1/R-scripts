library(mongolite)
options(width = 200)
source("getConStr.R")

mongo_conn_param <- get_urllike_connection(
    "mongo_local",
    "../python_learning/.env/db.conf",
    ",",
    "mongodb"
)

# Connecting to GridFS
fs <- gridfs(
  db = "file-store",
  url = mongo_conn_param,
  prefix = "fs"
)

# GridFS is a special type of collection for storing binary data such as files. 
# To the user, GridFS looks like a key-value store which supports potentially very large values.

