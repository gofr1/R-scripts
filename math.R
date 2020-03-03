factorialCalc <- function(x) {
    if (x < 0) {
       "Must be positive integer"
    } else if (x == 0) {
       1
    } else {
       x * factorial_calc(x-1)
    }
}

retFibonacci <- function(x) {
   if (x < 1) {
      "Must be positive integer not equal to zero or one"
   } else {
      f1 <- 0
      f2 <- 1
      print(f1)
      for (z in 2:x) {
         print(f2)
         y <- f1 + f2
         f1 <- f2
         f2 <- y
      }
   }
}

retFibonacci(2)

print(factorial_calc(5)) # 120
print(factorial_calc(10)) # 3628800
print(factorial_calc(-1)) # Must be positive integer
print(factorial_calc(0)) # 1