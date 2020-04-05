# to test how functions perform
library(microbenchmark)

x = runif(100)

microbenchmark(
  sqrt(x),
  x ^ 0.5
)