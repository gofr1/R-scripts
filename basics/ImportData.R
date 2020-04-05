library(rio)
library(tidyverse)

df <- import("data/StateData.xlsx") %>% 
    as_tibble() %>%
    select(
        state_code,
        psychRegions,
        instagram:modernDance) %>%
    mutate(psychRegions = as.factor(psychRegions)) %>%
    rename(y=psychRegions) %>%
    print()

# Clean up
rm(list = ls())

# Clear packages
detach("package:rio", unload= T)
detach("package:tidyverse", unload= T)