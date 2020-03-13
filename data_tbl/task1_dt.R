setwd("./data_tbl")
getwd()

library(data.table)

MonthDates <- fread("dt1.csv")

# all dates within the min max values for each month
DateMinMax <- MonthDates[, .(NewDate = min(Date):max(Date)), by = Month]

# # tried with merge (failed)
# merge(DateMinMax, MonthDates, by.x=c('Month','NewDate'), by.y=c('Month','Date'))

# get results with "not join"
results <- DateMinMax[!MonthDates, on=c(Month = 'Month',NewDate = 'Date')]

# rename column
setnames(results, old = "NewDate", new = "MissingDates")

# results
results

# TODO: implement same with dpryl