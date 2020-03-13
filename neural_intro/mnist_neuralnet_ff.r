## https://rstudio-pubs-static.s3.amazonaws.com/326787_431decc80c1a4ec797c3ef1e0b095e41.html

setwd("./neural_intro")

library(RColorBrewer)
BNW <- c("white", "black")
CUSTOM_BNW <- colorRampPalette(colors = BNW)

par(mfrow = c(4, 3), pty = "s", mar = c(1, 1, 1, 1), xaxt = "n", yaxt = "n")
images_digits_0_9 <- array(dim = c(10, 28 * 28))
for (digit in 0:9) {
  images_digits_0_9[digit + 1, ] <- apply(train_orig[train_orig[, 1] == digit, -1], 2, sum)
  images_digits_0_9[digit + 1, ] <- images_digits_0_9[digit + 1, ]/max(images_digits_0_9[digit + 1, ]) * 255
  z <- array(images_digits_0_9[digit + 1, ], dim = c(28, 28))
  z <- z[, 28:1]
  image(1:28, 1:28, z, main = digit, col = CUSTOM_BNW(256))
}

print_img = function(idx) {
    x = train_orig[idx, -1]
    x = array(as.numeric((x)), dim = c(28, 28))
    x <- x[, 28:1]
    image(1:28, 1:28, x, col = CUSTOM_BNW(256))
}

library(neuralnet)
library(caret)
library(data.table)
train_orig = read.csv("mnist_train.csv", header = TRUE)

train = train_orig

train$label = as.factor(train$label)

nzv.data = nearZeroVar(train, saveMetrics = TRUE)
drop.cols = rownames(nzv.data)[nzv.data$nzv == TRUE]
train = train[,!names(train) %in% drop.cols]

set.seed(43210)
train_indexes = createDataPartition(train$label, p = 0.1, list = FALSE, times = 1)
train_dataset = train[train_indexes, ]
test_dataset = train[-train_indexes, ]

class.ind = function(cl) {
    n = length(cl)
    cl = as.factor(cl)
    x = matrix(0, n, length(levels(cl)) )
    x[(1:n) + n*(unclass(cl)-1)] = 1
    dimnames(x) = list(names(cl), levels(cl))
    x
}

train_dataset = cbind(class.ind(as.factor(train_dataset$label)), train_dataset[,-1])
names(train_dataset) = c("l0","l1","l2","l3","l4","l5","l6","l7","l8","l9", names(train_dataset)[-(1:10)])
                      
scl = function(x) {
    (x - min(x))/(max(x) - min(x))
}

train_dataset[, 11:ncol(train_dataset)] = data.frame(lapply(train_dataset[, 11:ncol(train_dataset)], scl))
test_dataset[, 2:ncol(test_dataset)] = data.frame(lapply(test_dataset[, 2:ncol(test_dataset)], scl))

n = colnames(train_dataset)
form <- as.formula(
    paste("l0 + l1 + l2 + l3 + l4 + l5 + l6 + l7 + l8 + l9 ~", 
    paste(n[!n %in% c("l0","l1","l2", "l3","l4","l5", "l6","l7","l8","l9")], collapse = " + "))
)

train_dataset = readRDS("train_dataset.rds")
test_dataset = readRDS("test_dataset.rds")


## Original data set
View(train_orig[1:5,])

## Digit example
print_img(4)

## Prepared data set
View(train_dataset[1:5,])

## Prediction formula
form

library(neuralnet)

neural_model = neuralnet (
    formula = form,
    hidden = c(252), 
    act.fct = "logistic",
    linear.output = FALSE, 
    data = train_dataset,
    threshold = 0.01,
    err.fct = "ce",
    lifesign.step = 20,
    lifesign = "full"
)

plot(neural_model, show.weights = FALSE, information = FALSE, radius = 0.05, arrow.length = 0.2)

pred = compute(neural_model, test_dataset[,-1])$net.result

pred = max.col(pred) - 1


data.table(
    actual = test_dataset$label[1:20],
    prediction = pred[1:20],
    match = (pred[1:20] == test_dataset$label[1:20])
)

