# load packages
library(rio)
library(tidyverse)

# load data
df <- import("data/StateData.xlsx") %>% 
    as_tibble() %>%
    select(
        state_code,
        region,
        psychRegions
    ) %>%
    mutate(psychRegions = as.factor(psychRegions)) %>%
    print()

# Summarize dataframe
summary(df) # gives frequencies for factors only

# Summarize categorical variable
# "region" is a character variable
df %>%
    select(region) %>%
    summary() # not very useful

df %>%
    select(region) %>%
    table() # works better

table(df$region)

# Summarize a factor
# "psychRegions" is a factor
summary(df$psychRegions) # works best

table(df$psychRegions) 

# Summarize multiple factors
df <- df %>%
    mutate(region = as.factor(region)) %>%
    mutate(psychRegions = as.factor(psychRegions)) %>%
    print()

summary(df)

# Clean up
rm(list = ls())

# Clear packages
detach("package:rio", unload= T)
detach("package:tidyverse", unload= T)