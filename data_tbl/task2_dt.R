setwd("./data_tbl")
getwd()

library(data.table)

# load data
id_vals <- fread("dt2.csv")

# # some samples of shift
# shift(id_vals, n=1, type="lag") # produce a data.table lag by 1 
# shift(id_vals, n=1, type="lead")  # produce a data.table lead by 1 
# shift(id_vals, n = -1:1, give.names = TRUE) # getting a window 

# get a window of lag = 1 lead = 1 and current Vals with auto-naming
results <- id_vals[,shift(id_vals, n = -1:1, give.names = TRUE)][,c(2,4:6)]

# set NewVals = Vals_lag_0 and if it is NA set it to lead value
# in second part if NewVals is still NA take lag value
results[, NewVals := Vals_lag_0][is.na(NewVals), NewVals := Vals_lead_1][is.na(NewVals), NewVals := Vals_lag_1]

# # rename columns
# setnames(results, old = "OldName", new = "NewName")
setnames(results, c("Id_lag_0","Vals_lag_0"), c("Id", "Vals"))

# get results
results[,c(1,3,5)] 

# TODO: implement same with dpryl