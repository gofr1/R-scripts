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

# Combine categories with RECODE
# categorical recode
df %>%
    mutate(relaxed = recode(
        psychRegions,
        "Relaxed and Creative" = "yes",
        "Friendly and Conventional" = "no",
        .default = "no" # set default value
    )) %>%
    select(state_code, psychRegions, relaxed)

# Combine categories with CASE_WHEN
# case_when works a little differently so we will save as df2
df2 <- df %>%
    mutate(likeArts = case_when(
        museum > 1 | scrapbook > 1 | modernDance > 1 ~ "yes",
        TRUE ~ "no" # all other values
    ))

df2 %>%
    select(state_code, likeArts, museum:modernDance) %>%
    arrange(desc(likeArts)) %>%
    print(n = Inf)

# Clean up
rm(list = ls())

# Clear packages
detach("package:rio", unload= T)
detach("package:tidyverse", unload= T)