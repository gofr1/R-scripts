# Shows connections b/w cases in your data

# load packages
library(rio)
library(tidyverse)

# load data
df <- import("data/StateData.xlsx") %>% 
    as_tibble() %>%
    select(
        state_code,
        psychRegions,
        instagram:modernDance) %>%
    mutate(psychRegions = as.factor(psychRegions)) %>%
    rename(y=psychRegions) %>%
    print()

# Analyze data
# calculate clusters
hc <- df %>% # get data
    dist %>% # compute distance/dissimilarity matrix
    hclust # compute hierarchical clusters

# plot a dendrogram
hc %>% 
    plot(labels = df$state_code)

# draw boxes around clusters
hc %>%
    rect.hclust(k = 2, border = "gray80") # 2 boxes
hc %>%
    rect.hclust(k = 3, border = "gray60") # 3 boxes
hc %>%
    rect.hclust(k = 4, border = "gray40") # 4 boxes

# Clean up
rm(list = ls())

# Clear packages
detach("package:rio", unload= T)
detach("package:tidyverse", unload= T)