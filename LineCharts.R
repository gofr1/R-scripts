# How things change over time 
# patterns and glitches

# load packages
library(tidyverse)

# single time series
?uspop
uspop

?ts # get info about time-series objects

# plot with default plot()
plot(uspop)

# plot w/options
uspop %>%
    plot(
        main = "US Population 1790 - 1970",
        sub = "(Source: datesets::uspop)",
        xlab = "Year",
        ylab = "Population (in millions)"
    )
abline(v = 1930, col = "lightgray") # v - vertical, for 1930, w/lightgray colour
text(1930, 10, "1930", col = "red3") # go to 1930, 10 pixels up, write "1930" in red
abline(v = 1940, col = "lightgray")
text(1940, 2, "1940", col = "red3") 

# plot w/ts.plot()
?ts.plot # help
ts.plot(uspop)

# plot w/plot.ts()
?plot.ts
plot.ts(uspop)

# Multiple time-series

?EuStockMarkets
EuStockMarkets

# three different plot functions
plot(EuStockMarkets)
ts.plot(EuStockMarkets)
plot.ts(EuStockMarkets)

# Clean up
rm(list = ls())

# Clear packages
detach("package:tidyverse", unload= T)