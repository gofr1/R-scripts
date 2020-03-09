library(caret)

### Load data
setwd('./demo')
data <- read.csv("german_credit_data.csv")

### Explore data
View(data)

nrow(data) # number of rows
ncol(data) # number of columns
colnames(data) # column names
sapply(data, class)
summary(data) 

any(is.na(data)) # check if any columns have only NULLs

# some hisograms
hist(data$age)
hist(data$creditamount)

# some plots
featurePlot(x = data$age, y = data$default, plot = "box", auto.key = list(columns = 2))
featurePlot(x = data$creditamount, y = data$default, plot = "box", auto.key = list(columns = 2))

# Convert categorical columns
# and add some dummy data
dummyVars <- function(data) {
  dummy <- caret::dummyVars(" ~ . - default", drop2nd = T, data = data)
  res <- data.frame(default = data$default, predict(dummy, newdata = data))
  return(res)
}
data2 <- dummyVars(data)
View(data2)

# Remove columns with low variance

nearZeroVar(data2, names = T)

data2$job.unemployed <- NULL
data2$savingaccount.rich <- NULL
data2$purpose.domestic <- NULL
data2$purpose.repairs <- NULL
data2$purpose.vacation <- NULL

# Check correlations
m <- data2
m$default <- m$default == "yes"

corr_matrix <- cor(m, method = "spearman")

View(corr_matrix)

library(corrplot)
corrplot(corr_matrix, type = "upper", tl.pos = "td", method = "circle", tl.cex = 0.5, tl.col = 'black', order = "hclust", diag = F)

data2$sex.male <- NULL
data2$sex.female <- NULL

# Prepare train & test subsets
set.seed(1234L)
trainIndex <- createDataPartition(data2$default, p = 0.8, list = F)

trainSubset <- data2[trainIndex,]
testSubset <- data2[-trainIndex,]

# Train model
# check available train methods 
# names(getModelInfo())
model <- train(
  default ~ .,
  data = trainSubset,
  method = "rf",
  metric = "Accuracy",
  trControl = trainControl(method = "repeatedcv", number = 5, repeats = 3),
  tuneLength = 5
)

# # Some plots
# plot(model)
# plot(varImp(model))

# library(rpart.plot)
# prp(model$finalModel);

# Test model
predicted_default = predict(model, testSubset)
predicted_default
cm <- confusionMatrix(predicted_default, testSubset$default)
cm

# # Save model for the future usage
# saveRDS(model, "model.rds")
