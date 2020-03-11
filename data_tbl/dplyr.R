setwd("./data_tbl")
getwd()

library(dplyr)

# load data
cars = read.csv("cars.csv")

# "data.frame"
class(cars)

# selection
select(cars, mpg, car)

# filtering
filter(cars, mpg > 25)

# updating
mutate(cars, dbl_mpg = mpg * 2)

# combination of statements
select(mutate(filter(cars, mpg > 25), dbl_mpg = mpg * 2), car, dbl_mpg)

# same query w/ pipes
cars %>% filter(mpg > 25) %>% mutate(., dbl_mpg = mpg * 2) %>% select(., car, dbl_mpg)
