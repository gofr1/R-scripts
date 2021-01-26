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

# Filter by one variable
# "entrepreneur" is a quantative variable
df %>%
    filter(entrepreneur > 1) %>%
    print()

# "region" is a character variable
df %>%
    filter(region == "South") %>%
    print()

# "psychRegions" is a factor
df %>%
    filter(psychRegions == "Relaxed and Creative") %>%
    print()

# Filter by multiple variables
# "or" is the vertical pipe |
df %>%
    filter(
        region == "South" |
        psychRegions == "Relaxed and Creative") %>%
    print()

# "and" is the ampersand &
df %>%
    filter(
        region == "South" &
        psychRegions == "Relaxed and Creative") %>%
    print()

# "not" is the exclamation point !
df %>%
    filter(
        region == "South" &
        !psychRegions == "Relaxed and Creative") %>%
    print()


# Clean up
rm(list = ls())

# Clear packages
detach("package:rio", unload = T)
detach("package:tidyverse", unload = T)