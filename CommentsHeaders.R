# LEVEL 1 HEADER ##########################
## Level 2 Header =========================
### Level 3 Header ------------------------

# load package manually
library(datasets)

# load and prepare data
?iris # ? for help
df <- iris
head(df) # shows first 6 rows

# use comments to disable lines
hist(df$Sepal.Width,
    col = "#CD0000", # red3
    # border = NA,
    main = "Histogram of Sepal Width",
    xlab = "Sepal Width (in cm)"
    )

# Clean up
rm(list = ls())

# Clear packages
p_unload(all)
detach("package:datasets", unload= T)

# clear plot
dev.off()