# load packages
library(tidyverse)

# load dataset from ggplot2
?diamonds
diamonds

# barplot of frequencies
?boxplot

# basic boxplot (w/defaults)
boxplot(diamonds$price)

# similar using pipes
diamonds %>%
    select(price) %>%
    boxplot()

# boxplot with options
diamonds %>%
    select(price) %>%
    boxplot(
        horizontal = T,
        notch = T, # confidence interval for median
        main = "Boxplot of Price of Diamonds",
        sub = "(Source: ggplot2::diamonds)",
        xlab = "Price of Diamonds",
        col = "#CD0000"
    )

# boxplots by groups
# using plot
diamonds %>%
    select(color, price) %>%
    plot()

# using boxplot
diamonds %>%
    select(color, price) %>%
    boxplot(
        price ~ color, # tilde indicates formula
        data = . , # dot is placeholder for pipe
        col = "#CD0000"
    )

# Clean up
rm(list = ls())

# Clear packages
detach("package:tidyverse", unload= T)