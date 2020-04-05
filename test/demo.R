# Test
require("datasets")
df <- iris
plot(df)

# Basics
2+2 # a simple calculation
1:100 # prints numbers from 1 to 100
print("Hello World!")

# Assigning Values
# individual
a <- 1
2 -> b
c <- d <- e <- 3 # Multiple assignments

# multiple
x = c(1, 2, 5, 9) # c = Combine/Concatenate

# Sequences
0:10 # 0 through 10
10:0 # 10 through 0
seq(10) # 1 to 10
seq(30, 0, by = -3) # Count down by 3

# Math
(y <- c(5, 1, 0, 10)) # if you put a command of assigning in parentesses it will be printed
x + y # adds corresponding elements in x and y 
x * 2 # multiplies each element in x by 2
2^6 # powers/exponents
sqrt(64) # squareroot
log(100) # natural log base e = 2.71828...
log10(100) # base 10 log

# Clean up
rm(list = ls())