# Data Types

# Numeric
(n1 <- 15) # double precision by default
typeof(n1)

(n2 <- 1.5)
typeof(n2)

# Character/string
(c1 <- "c")
typeof(c1)

(c2 <- "a string of text")
typeof(c2)

# Logical/boolean
(l1 <- TRUE)
typeof(l1)

(l2 <- F)
typeof(l2)

# Data Structures

# Vector
# is a default structure (almost everything is a vector)
is.vector(n1) # TRUE
# is a one dimensional collection of numbers
# either a row or a column
(v1 <- c(1, 2, 3, 4, 5))
is.vector(v1)

(v2 <- c("a", "b", "c"))
is.vector(v2)

(v3 <- c(TRUE, TRUE, FALSE, FALSE, TRUE))
is.vector(v3)

# Matrix
(m1 <- matrix(data = c(T, T, F, F, T, F), nrow = 2))
(m2 <- matrix(c("a", "b", "c", "d"), nrow = 2, byrow = 2))
is.matrix(m1) # T
is.vector(m1) # F

# Array
# give data, then dimensions (rows, columns, tables)
(a1 <- array(c(1:24), c(4, 3, 2)))

# Data Fame
# can combine vectors of the same length
vNumeric <- c(1, 2, 3)
vCharacter <- c("a", "b", "c")
vLogical <- c(T, F, T)

(df1 <- cbind(vNumeric, vCharacter, vLogical))
# everyting is switched to a character
typeof(df1) # character
is.matrix(df1) # T
is.vector(df1) # F
is.data.frame(df1) # F
is.list(df1) # F

(df2 <- as.data.frame(cbind(vNumeric, vCharacter, vLogical)))
# now it is a data frame with 3 different vectors
typeof(df2) # list
is.matrix(df2) # F
is.vector(df2) # F
is.data.frame(df2) # T
is.list(df2) # T

# List
# can store anything
o1 <- c(1, 2, 3)
o2 <- c("a", "b", "c", "d")
o3 <- c(T, F, T, T, F)

(list1 <- list(o1, o2, o3))
typeof(list1) # list
is.matrix(list1) # F
is.vector(list1) # T
is.data.frame(list1) # F
is.list(list1) # T

# lists within the lists
(list2 <- list(o1, o2, o3, list1))

# select the list elements
list2[[1]] # all elements of o1
list2[[2]] # all elements of o2
list2[[2]][3] # "c"
list2[[4]][[1]] # all elements of o1 within list1
list2[[4]][[1]][2] 

# Coercing types
# Automatic coercion
# goes to the "least restrictive" type 
(coerce1 <- c(1, "b", TRUE))
typeof(coerce1) # character

# coerce numeric to integer
(coerce2 <- 5)
typeof(coerce2) # double
(coerce3 <- as.integer(coerce2))
typeof(coerce3) # integer

# coerce character to numeric
(coerce4 <- "5")
typeof(coerce4) # character
(coerce5 <- as.numeric(coerce4))
typeof(coerce5) # double

(coerce6 <- c("1.2", "2.1",  "3.4"))
typeof(coerce6) # character
# be careful with conversion from character to numeric
(coerce7 <- as.integer(coerce6))
typeof(coerce7) # integer # 1, 2, 3 
(coerce8 <- as.numeric(coerce6))
typeof(coerce8) # double # 1.2, 2.1, 3.4

# Coerce matrix to data frame
(cm <- matrix(1:10, nrow = 5))
is.matrix(cm) # T
is.data.frame(cm) # F

(dfm <- as.data.frame(cm))
is.matrix(dfm) # F
is.data.frame(dfm) # T

# Clean up
rm(list = ls())