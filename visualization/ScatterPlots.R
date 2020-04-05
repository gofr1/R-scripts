# load packages
library(rio)
library(tidyverse)

# load and prepare data
df <- import("data/StateData.xlsx") %>% 
    as_tibble() %>%
    select(
        state_code,
        psychRegions,
        instagram:modernDance) %>%
    mutate(psychRegions = as.factor(psychRegions)) %>%
    print()

# scatterplots

df %>%
    select(instagram:modernDance) %>%
    plot()

# bivariate scatterplot w/defaults
df %>%
    select(scrapbook:modernDance) %>%
    plot()

# bivariate scatterplot w/options
df %>%
    select(scrapbook:modernDance) %>%
    plot(
        main = "Scatterplot of Google Searches by state",
        xlab = "Searches for \"Scrapbook\"",
        ylab = "Searches for \"modern dance\"",
        col = "gray", # colour of points
        pch = 20 # plotting character (small circle)
    )

?pch # see plotting characters

# add fit linear regression line (y ~ x)
df %>%
    lm(modernDance ~ scrapbook, data = .) %>%
    abline()

# Remove outlier
# identify outlier
df %>%
    select(state_code, scrapbook) %>%
    filter(scrapbook > 4) %>% # select outlier
    print()

# bivariate scatterplot w/o outlier
df %>%
    select(scrapbook:modernDance) %>%
    filter(scrapbook < 4) %>%
    plot(
        main = "Scatterplot of Google Searches by state",
        xlab = "Searches for \"Scrapbook\"",
        ylab = "Searches for \"modern dance\"",
        col = "gray", # colour of points
        pch = 20 # plotting character (small circle)
    )

# add fit linear regression line (y ~ x) w/outlier
df %>%
    filter(scrapbook < 4) %>%
    lm(modernDance ~ scrapbook, data = .) %>%
    abline()

# Clean up
rm(list = ls())

# Clear packages
detach("package:rio", unload= T)
detach("package:tidyverse", unload= T)