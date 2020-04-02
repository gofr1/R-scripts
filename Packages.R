# install package if needed
if (!require("pacman")) install.packages("pacman")

pacman::p_load(pacman, party, psych, rio, tidyverse)
# pacman for loading/unloading packages
# party: for decision trees
# psych: for many statistical procedures
# rio: for importing data
# tidyverse: for so many reasons


# load package manually
library(datasets)
library(readr)

# readr
(df <- read_csv("data/trees.csv"))

# rio::import()
(df <- import("data/StateData.xlsx") %>% as_tibble())

# Analyze data
# decision tree
fit <- ctree(y ~ ., data = df[, -1]) # create tree
fit %>% plot()
fit %>%
    predict() %>%
    table(df$y)

hc <- df %>% # get data
    dist %>% # compute distance
    hclust %>% # hierarchical cluster
    plot(labels = df$state_code)  # create plot


# Clean up
rm(list = ls())

# Clear packages
p_unload(all)
detach("package:datasets", unload= T)

# clear plot
dev.off()