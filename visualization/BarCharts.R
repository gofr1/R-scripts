# load packages
library(tidyverse)

# load dataset
?diamonds
diamonds

# barplot of frequencies
?plot
?barplot

# shortest way to make a barplot
plot(diamonds$cut)

# similar way using pipes
diamonds %>%
    select(color) %>%
    plot()

# to use barplot we need to use a table
?table

diamonds %>%
    select(clarity) %>%
    table() %>%
    barplot()

# sort bars bydecreasing values (not for ordina x)
diamonds %>%
    select(clarity) %>%
    table() %>%
    sort(descending = T) %>%
    barplot()

# add options to the plot
diamonds %>%
    select(clarity) %>%
    table() %>%
    sort(descending = T) %>%
    barplot(
        main   = "Clarity of Diamonds",
        sub    = "(Source: ggplot2::diamonds)",
        horiz  = T, # draw horizontal bars
        ylab   = "Clarity of Diamonds", # flip axis values
        xlab   = "Frequency",
        xlim   = c(0, 15000), # limit for X axis
        border = NA, # no borders
        col    = "#CD0000" # red3
    )

# Side-by-side barplot of frequencies
# 100% stacked bar
diamonds %>%
    select(color, clarity) %>%
    plot()

# stacked bars: step 1: create a table
df <- diamonds %>%
            select(color, clarity) %>%
            table() %>%
            print() # show table in console

# create a graph
df %>%
    barplot(legend = rownames(.)) # draw plot w/legend

df %>%
    barplot(
        legend = rownames(.),
        beside = T # put bars next to each other
    )

# Clean up
rm(list = ls())

# Clear packages
detach("package:tidyverse", unload= T)
