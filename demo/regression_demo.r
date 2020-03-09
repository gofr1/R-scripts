# lets predict weight based on height
height <- c(151, 174, 138, 186, 128, 136, 179, 163, 152, 131)
weight <- c(63, 81, 56, 91, 47, 57, 76, 72, 62, 48)

scatter.smooth(height, weight) 

# create a model
model <- lm(weight ~ height)
summary(model)

# use model to predict weight for some height paramrters
input_data = data.frame(height = c(190, 200))
predict(model, input_data)

plot(weight, height, col = "blue", main = "Height & Weight Regression",
    abline(lm(height~weight)), cex = 1.3, pch = 16, xlab = "Weight in Kg", ylab = "Height in cm")

# try with additional parameter age
age <- c(20, 45, 19, 30, 13, 21, 40, 41, 25, 19)

model2 <- lm(weight ~ height + age)
summary(model2)
predict(model2, data.frame(height = c(190, 200), age = c(30, 40)))
