# load packages
library(tidyverse)

# load dataset from ggplot2
?diamonds
diamonds

# histograms
?hist

# basic histogram (w/defaults)
hist(diamonds$price)

# histogram w/options
hist(
    diamonds$price,
    breaks = 7, # suggest number of breaks
    main   = "Histogram of Price of Diamonds",
    sub    = "(Source: ggplot2::diamonds)",
    ylab   = "Frequency",
    xlab   = "Price of Diamonds",
    border = NA, # no borders
    col    = "#CD0000" # red3
)

# Clean up
rm(list = ls())

# Clear packages
detach("package:tidyverse", unload= T)