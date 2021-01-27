# Loading the dataset
data1 <- swiss
options(width = 200) # to expand output length
head(data1, 4) # get first 4 rows

# Creating a scatter plot using ggplot2 library
library(ggplot2)
ggplot(data1, aes(x = Fertility, y = Infant.Mortality)) + geom_point()
+ geom_smooth(method = "lm", se = TRUE, color = "black")

# Testing the assumptions (Linearity and Normalcy)
# Linearity#: Visible from the plot itself (True, the relationship is linear)
# Normality$: Using Shapiro test (This is a test of normality, here we are
# checking whether the variables are normally distributed or not )

shapiro.test(data1$Fertility)
#*         Shapiro-Wilk normality test
#*
#* data:  data1$Fertility
#* W = 0.97307, p-value = 0.3449

shapiro.test(data1$Infant.Mortality)
#*         Shapiro-Wilk normality test
#*
#* data:  data1$Infant.Mortality
#* W = 0.97762, p-value = 0.4978
# p-value is greater than 0.05, so we can assume the normality

# Correlation Coefficient
cor(data1$Fertility, data1$Infant.Mortality)
#* [1] 0.416556

# Checking for the significance
res <- cor.test(swiss$Fertility, swiss$Infant.Mortality, method = "pearson")

res
#*         Pearson's product-moment correlation
#*
#* data:  swiss$Fertility and swiss$Infant.Mortality
#* t = 3.0737, df = 45, p-value = 0.003585
#* alternative hypothesis: true correlation is not equal to 0
#* 95 percent confidence interval:
#*  0.1469699 0.6285366
#* sample estimates:
#*      cor
#* 0.416556

# Since the p-value is less than 0.05 (here it is 0.003585),
# we can conclude that Fertility and Infant Mortality are significantly
# correlated with a value of 0.416556 and a p-value of 0.003585.