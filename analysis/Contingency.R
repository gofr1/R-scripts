# load packages
library(rio)
library(tidyverse)
library(magrittr) # to get arithmetic aliases

# load data
df <- import("data/StateData.xlsx") %>% 
    as_tibble() %>%
    select(state_code, region, psychRegions) %>%
    mutate(psychRegions = as.factor(psychRegions)) %>%
    print()

# Anali\yze data
# using contingency table
(ct <- table(df$region, df$psychRegions))

# row percentages
ct %>%
    prop.table(1) %>% # 1 is for row percentage
    round(2) %>%
    multiply_by(100)

# column percentages
ct %>%
    prop.table(2) %>% # 2 is for column percentage
    round(2) %>%
    multiply_by(100)

# total percentages
ct %>%
    prop.table() %>% # no arguments for total percentage
    round(2) %>%
    multiply_by(100)

# Chi-squared test 
(tchi <- chisq.test(ct))

# Additional tables
tchi$observed # observed frequencies
tchi$expected # expected frequencies
tchi$residuals # Pearson's residual
tchi$stdres # standardized residual

# Clean up
rm(list = ls())

# Clear packages
detach("package:rio", unload= T)
detach("package:tidyverse", unload= T)
detach("package:magrittr", unload= T)