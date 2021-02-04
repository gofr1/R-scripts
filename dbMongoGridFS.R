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

print(fs)
#* <gridfs> 
#*  $disconnect(gc = TRUE) 
#*  $download(name, path = ".") 
#*  $drop() 
#*  $find(filter = "{}", options = "{}") 
#*  $read(name, con = NULL, progress = TRUE) 
#*  $remove(name) 
#*  $upload(path, name = basename(path), content_type = NULL, metadata = NULL) 
#*  $write(con, name, content_type = NULL, metadata = NULL, progress = TRUE)
# Methods
# Read & Write

# Stream data from a URL into GridFS
# Stream a file from a URL:
con <- url("http://people.ubuntu.com/~flexiondotorg/Focal_Fossa_Wallpapers_All.tar.xz")
fs$write(
    con,
    "Focal_Fossa_Wallpapers_All.tar.xz",
    progress = TRUE, # To get progress bar
    metadata = '{"Comment" : "Pack of Focal Fossa wallpapers"}'
)
#* List of 6
#*  $ id      : chr "601bcbf2e114c600942101a2"
#*  $ name    : chr "Focal_Fossa_Wallpapers_All.tar.xz"
#*  $ size    : num 28930348
#*  $ date    : POSIXct[1:1], format: "2021-02-04 13:26:58"
#*  $ type    : chr NA
#*  $ metadata: chr "{ \"Comment\" : \"Pack of Focal Fossa wallpapers\" }"

# Stream a raw vector with data:
buf <- serialize(mtcars, NULL)

fs$write(buf, "mtcars", progress = FALSE)
#* List of 6
#*  $ id      : chr "601bccd7e114c600942101a3"
#*  $ name    : chr "mtcars"
#*  $ size    : num 3807
#*  $ date    : POSIXct[1:1], format: "2021-02-04 13:30:47"
#*  $ type    : chr NA
#*  $ metadata: chr NA

# List files in the GridFS
fs$find()
#*                         id                              name     size                date type                                         metadata
#* 1 601bcbf2e114c600942101a2 Focal_Fossa_Wallpapers_All.tar.xz 28930348 2021-02-04 13:26:58 <NA> { "Comment" : "Pack of Focal Fossa wallpapers" }
#* 2 601bccd7e114c600942101a3                            mtcars     3807 2021-02-04 13:30:47 <NA>                                             <NA>

# Stream the file from GridFS to disk
out <- fs$read(
    "Focal_Fossa_Wallpapers_All.tar.xz",
    file("Focal_Fossa_Wallpapers_All.tar.xz"),
    progress = TRUE
)
#* [Focal_Fossa_Wallpapers_All.tar.xz]: read 28.93 MB (done)

file.info("Focal_Fossa_Wallpapers_All.tar.xz")$size
#* [1] 28930348

# Remove file
unlink("Focal_Fossa_Wallpapers_All.tar.xz")

# You can set con to NULL in which case the file will be buffered in memory 
# and returned as a raw vector. This is useful for e.g. unserializing R objects.
out <- fs$read(
    "mtcars",
    con = NULL,
    progress = TRUE
)
#* [mtcars]: read 3.81 kB (done)  

df <- unserialize(out$data)
head(df)
#*                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#* Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
#* Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
#* Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
#* Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
#* Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
#* Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1

# Drop GridFS when done
fs$drop()

# Vectorized Upload/Download
# The fs$upload() and fs$download() methods provide an alternative API
# specifically for transferring files between GridFS and your local disk.
#
# This API is vectorized so you can transfer many files at once.
# However transfers cannot be interrupted and will block R until completed.
# This API is only recommended to upload/download a large number of small files.
# Connecting to GridFS
mb <- gridfs(
  db = "mongo-book",
  url = mongo_conn_param,
  prefix = "mongobook"
)
# will upload all files in current directory
mb$upload(list.files(".", recursive = TRUE))

# Download all files in one command:
files <- mb$find()
dir.create("outputfiles")
mb$download(files$name, "outputfiles")
# TODO: if filenames contein spaces you will get error

# Get a list of files
list.files("outputfiles")

unlink("outputfiles", recursive = TRUE)