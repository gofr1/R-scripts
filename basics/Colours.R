# load some data
x = c(24, 13, 7, 5, 3, 2)
barplot(x)

# colour in R
# R has 657 colour names for 502 unique colours
?colors
colors() # show all names

# use colours:
# names
barplot(x, col = "red3")
barplot(x, col = "slategray3")

# RGB triplets (0.00 - 1.00)
barplot(x, col = rgb(.80, 0, 0))
barplot(x, col = rgb(.62, .71, .80))

# RGB triplets (0 - 255)
barplot(x, col = rgb(205, 0, 0, max = 255))
barplot(x, col = rgb(159, 182, 205, max = 255))

# RGB HEX codes
barplot(x, col = "#CD0000")
barplot(x, col = "#9FB6CD")

# index numbers
barplot(x, col = colors() [555])
barplot(x, col = colors() [602])

# multiple colours
barplot(x, col = c("red3", "slategray3")
barplot(x, col = c("#CD0000","#9FB6CD"))

# using colour palettes
?palette
palette()

barplot(x, col = 1:6)
barplot(x, col = rainbow(6))
barplot(x, col = heat.colors(6))
barplot(x, col = terrain.colors(6))
barplot(x, col = topo.colors(6))
barplot(x, col = cm.colors(6))

