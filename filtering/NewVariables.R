# load packages
library(rio)
library(tidyverse)

# load data
df <- import("data/StateData.xlsx") %>%
    as_tibble() %>%
    select(
        state_code,
        region,
        psychRegions,
        instagram:modernDance) %>%
    mutate(psychRegions = as.factor(psychRegions)) %>%
    # rename(y=psychRegions) %>%
    print()

# Average variables
df %>%
    mutate(
        socialMedia = (instagram + facebook + retweet) / 3,
        artsCrafts = (museum + scrapbook + modernDance) / 3
    ) %>%
    select(state_code, socialMedia, artsCrafts)

# Reverse coding
df %>%
    mutate(
        outgoing = (volunteering + (privacy * -1)) / 2
    ) %>%
    select(state_code, outgoing, volunteering, privacy)

# for 1-n scale, use (n+1)-x
# for 0-n scale, use n-x

# Clean up
rm(list = ls())

# Clear packages
detach("package:rio", unload = T)
detach("package:tidyverse", unload = T)