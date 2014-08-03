# Q1
library(MASS)
mdl1 <- glm(factor(use) ~ factor(wind), "binomial", shuttle)
round(exp(mdl1$coefficients[2]),3)

# Q2
mdl2 <- glm(factor(use) ~ factor(wind) + factor(magn), "binomial", shuttle)
exp(mdl2$coefficients[2])

# Q3
mdl3 <- glm(relevel(factor(use), "noauto") ~ factor(wind), "binomial", shuttle)

# Q4
data(InsectSprays)
mdl4 <- glm(count ~ spray, family = "poisson", InsectSprays)

# Q5

# Q6
x <- -5:5
y <- c(5.12, 3.93, 2.67, 1.87, 0.52, 0.08, 0.93, 2.05, 2.54, 3.87, 4.97)
plot(x, y)
