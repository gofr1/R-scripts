setwd("../data_tbl")
getwd()

library(data.table)

# load data
cars = fread("cars.csv")

# "data.table" "data.frame"
class(cars) 

# select
cars  # all
cars[,,] # all
cars[1, ]  # first row
cars[c(1, 3, 5)] # rows 1, 3 and 5
cars[mpg > 25] # where mpg > 25
cars[mpg > 25 & carb == 1] # where mpg > 25 and carb = 1
cars[mpg > 25 & carb == 1, .(car, mpg)] # same as previous but only 2 columns
cars[, .(car, mpg)] #  only 2 columns

# What is the differences
# datable
dt1 <- cars[, .(mpg)]

# numeric and distinct values
dt2 <- cars[, unique(mpg)]

## What will be the result?
col_name = "mpg"
cars[1:3, col_name]

# update

cars[c(1, 3, 5)]
cars[c(1, 3, 5), `:=`(carb = 0, mpg = 100)]
cars[c(1, 3, 5)]


# group

cars[, , by = carb]
cars[, mean(mpg), by = carb]
cars[, .(avg = mean(mpg), s = sum(mpg)), by = carb]

cars[, {
	if (mean(mpg) > 20) data.table(a = 10) else data.table(a = 20)
}, by = carb]

cars[, .N, by = carb]
cars[, .I, by = carb]
cars[, .GRP, keyby = ifelse(carb %% 2 == 0, 1, 2)]
cars[, {print(.SD); list(a = 1);}, by = carb]


# join

dt1 = data.table(a = 1:5, b = "dt1", key = "a")
dt2 = data.table(a = 3:8, b = "dt2", key = "a")

dt1
dt2

dt1[dt2]
dt2[dt1]
dt1[dt2, nomatch = 0L]
dt1[dt2, .(a, bb = i.b), nomatch = 0L]
dt1[dt2, b := i.b]

dt1 = data.table(a = c(1, 1, 2, 2), b = paste("dt1", 1:4), key = "a")
dt2 = data.table(a = c(1, 1, 1), b = paste("dt2", 1:3), key = "a")
dt2[dt1]

dt2[dt1, allow.cartesian = T]
