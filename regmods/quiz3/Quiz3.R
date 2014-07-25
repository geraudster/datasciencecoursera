data(mtcars)

# Q1
model.1 <- lm(mpg ~ factor(cyl) + wt, data=mtcars)
summary(model.1)

round(model.1$coefficients[3],3)

factor(mtcars$cyl)

# Q2
model.2 <- lm(mpg ~ factor(cyl), data=mtcars)
summary(model.2)

# Q3
anova(model.2, model.1)
anova(model.2, model.1,test="Chisq")

# Q4
model.4 <- lm(mpg ~ I(wt * 0.5) + factor(cyl), data = mtcars)
plot(model.4)
model.4


# Q5
x <- c(0.586, 0.166, -0.042, -0.614, 11.72)
y <- c(0.549, -0.026, -0.127, -0.751, 1.344)

fit <- lm(y ~ x)

round(hatvalues(fit), 4)

# Q6
round(dfbetas(fit), 4)

