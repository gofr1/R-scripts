### Loading sample data

setwd("./graphics")

market_data = read.csv("market_data.csv")

market_data$Date = as.Date(market_data$Date, format = "%d-%b-%y")

View(market_data)

### Basic R graphics example

plot(x = market_data$Date, y = market_data$EPAM, type = "l")

lines(x = market_data$Date, y = market_data$AAPL, type = "l")

### Adavnced graphics with ggplot2

library(ggplot2)

ggplot() + layer(
	data = market_data,
	geom = "line",
	mapping = aes(x = Date, y = EPAM),
	stat = "identity",
	position = "identity")

ggplot(market_data) + 
    geom_line(mapping = aes(x = Date, y = EPAM))

ggplot(market_data, aes(x = Date)) + 
	geom_line(mapping = aes(y = EPAM)) + 
	geom_line(mapping = aes(y = AAPL))

ggplot(market_data, aes(x = Date)) + 
	geom_line(mapping = aes(y = EPAM, color = "red")) + 
	geom_line(mapping = aes(y = AAPL, color = "green")) +
	xlab('Dates') +
	ylab('Price') + 
	scale_color_manual(name = 'Stocks', values = c('green' = 'green', 'red' = 'red'), 
		labels = c('red' = 'EPAM', 'green' = 'AAPL'))
		
ggplot(market_data, aes(x = Date)) + 
	geom_line(mapping = aes(y = EPAM, color = "red")) + 
	geom_line(mapping = aes(y = AAPL, color = "green")) +
	geom_smooth(mapping = aes(y = AAPL, color = "blue")) +
	xlab('Dates') +
	ylab('Price') + 
	scale_color_manual(name = 'Stocks', values = c('green' = 'green', 'red' = 'red', 'blue' = 'blue'), 
		labels = c('red' = 'EPAM', 'green' = 'AAPL', 'blue' = 'AAPL Smoothy'))

ggplot(mtcars) + 
  geom_point(mapping = aes(x = mpg, y = hp))
		
g1 = ggplot(mtcars, aes(x = drat, y = qsec, color = cyl)) +
	geom_point(size = 5) +
	theme(legend.position = "none")
g1
	
g2 = ggplot(mtcars, aes(x = factor(cyl), y = qsec, fill = cyl)) +
	geom_boxplot() +
	theme(legend.position = "none")
print(g2)
	
g3 = ggplot(mtcars, aes(x = factor(cyl), fill = factor(cyl))) +
	geom_bar() +
	theme(legend.position = "none")
g3

g4 = g3

library(gridExtra)

grid.arrange(g1, g2, g3, g4, ncol = 2, nrow = 2)

grid.arrange(g2, arrangeGrob(g3, g4, nrow = 2), nrow = 1)

