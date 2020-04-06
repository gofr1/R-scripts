# load packages
library(rio)
library(tidyverse)
library(psych)

# load data
df <- import("data/StateData.xlsx") %>% 
    as_tibble() %>%
    select(
        state_code,
        region,
        psychRegions,
        instagram:modernDance) %>%
    mutate(psychRegions = as.factor(psychRegions)) %>%
    print()

# Summarize
summary(df)
summary(df$entrepreneur)

# Quartiles
# Tukey's five number summary:
# minimnum, lower-hinge, median, upper-hinge, maximum
# no labels
fivenum(df$entrepreneur)

# Boxplot stats: hinges, n, CI for median, outliers
boxplot(df$entrepreneur, notch = T, horizontal = T)
boxplot.stats(df$entrepreneur)

# Alternative descriptives
describe(df)
describe(df$entrepreneur) # psych package

# Clean up
rm(list = ls())

# Clear packages
detach("package:rio", unload= T)
detach("package:tidyverse", unload= T)
detach("package:psych", unload= T)