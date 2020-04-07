# load packages
library(rio)
library(tidyverse)

# load data
df <- import("data/StateData.xlsx") %>% 
    as_tibble() %>%
    select(instagram:modernDance) %>%
    print()

# Scatterplots
df %>%
    select(instagram:modernDance) %>%
    plot()

# quick graphical check of data
df %>%
    select(museum, volunteering) %>%
    plot()

# add regression line
lm(df$volunteering ~ df$museum) %>% abline()

# Bivariate regression
# compute and save bivariate regression
fit1 <- lm(df$volunteering ~ df$museum)

# show model
fit1

# summarize regression model
summary(fit1)

# confidence intervals for coefficients
confint(fit1)

# predict values of "volunteering"
predict(fit1)

# prediction of intervals of values of "volunteering"
predict(fit1, interval = "prediction")

# regression diagnostics
lm.influence(fit1)
influence.measures(fit1)

# Multiple regression
df <- df %>%
    select(volunteering, everything()) %>%
    print()

# three ways to specify model
# most  concise
lm(df)

# identify outcome , infer rest
lm(volunteering ~ ., data = df)

# identify entire model
lm(volunteering ~ instagram + facebook + retweet +
   entrepreneur + gdpr + privacy + university+
   mortgage + museum + scrapbook + modernDance,
   data = df)

# save model
fit2 <- lm(df)

# show model
fit2

# summarize regression model
summary(fit2)

# confidence intervals for coefficients
confint(fit2)

# predict values of "volunteering"
predict(fit2)

# prediction of intervals of values of "volunteering"
predict(fit2, interval = "prediction")

# regression diagnostics
lm.influence(fit2)
influence.measures(fit2)

# Clean up
rm(list = ls())

# Clear packages
detach("package:rio", unload= T)
detach("package:tidyverse", unload= T)