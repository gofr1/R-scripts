# load packages
library(rio)
library(tidyverse)
library(Hmisc)

# load data
df <- import("data/StateData.xlsx") %>% 
    as_tibble() %>%
    select(instagram:modernDance) %>%
    print()

# Correlation matrix
cor(df)

# rounded to 2 decimals
df %>%
    cor() %>%
    round(2)

# Single correlation
# can test one pair of variables at a time
# gives r, hypothesis test, and confidence interval
cor.test(df$instagram, df$privacy)

# P-values for matrix
# need to use Hmisc package
# coerce from dataframe to matrix
# to get both a correlation matrix and p-values (in separate tables)
df %>%
    as.matrix() %>%
    rcorr()

# Clean up
rm(list = ls())

# Clear packages
detach("package:rio", unload= T)
detach("package:tidyverse", unload= T)
detach("package:Hmisc", unload= T)