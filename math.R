# Factorial calculation with recursion
factorialCalc <- function(x) {
    if (x < 0) {
       "Must be positive integer"
    } else if (x == 0) {
       1
    } else {
       x * factorialCalc(x-1)
    }
}

print(factorialCalc(5)) # 120
print(factorialCalc(10)) # 3628800
print(factorialCalc(-1)) # Must be positive integer
print(factorialCalc(0)) # 1

# Calc first x Fibonacci numbers
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

retFibonacci(10)

# Factorial calculation with For loop
factorialLoopCalc <- function(x) {
    if (x < 0) {
       "Must be positive integer"
    } else if (x == 0 | x == 1) {
       1
    } else {
       for (z in 1:(x-1)) {
          x <- z * x
       }
       x
    }
}

print(factorialLoopCalc(5)) # 120
print(factorialLoopCalc(10)) # 3628800
print(factorialLoopCalc(-1)) # Must be positive integer
print(factorialLoopCalc(0)) # 1
print(factorialLoopCalc(1))
print(factorialLoopCalc(2))

# power function
calcPower <- function(x, y) {
   z <- 0
   if (x == 0) {
      0
   } else if (y == 0) {
      1
   } else {
      while (y != sign(y)) {
         x = x * x 
         y <- y - sign(y)
      }
      if (sign(y) > 0) {
         x
      } else {
         1/x
      }
   }
}

calcPower(2, 2) # 4
calcPower(1, 4) # 1
calcPower(10, 1) # 10
calcPower(10, -1) # 0.1
calcPower(10, 2) # 100
calcPower(10, -2) # 0.01
