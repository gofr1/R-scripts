setwd("./data_tbl")
getwd()

library(data.table)

# load data
dt <- fread("dt3.csv")

# get max value for each Id & DetailedNumber and then sum of max values for each Id
dt[, .(maxVal = max(Vals)), by = .(DetailedNumber, Id)][, .(SumOfMax = sum(maxVal)), by = Id]