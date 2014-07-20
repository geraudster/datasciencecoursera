# Q1
x <- c(0.61, 0.93, 0.83, 0.35, 0.54, 0.16, 0.91, 0.62, 0.62)
y <- c(0.67, 0.84, 0.6, 0.18, 0.85, 0.47, 1.1, 0.65, 0.36)
fit <- lm(y ~ x)
summary(fit)
summary(fit)$coefficients[2,4]

# Q2
summary(fit)$sigma

# Q3
data(mtcars)
mpgWeight.model <- lm(mpg ~ wt, mtcars)

mpgWeight.confint <- confint(mpgWeight.model)
mpgWeight.confint[2,1]

newCarMean <- data.frame(wt = mean(mtcars$wt))
mpgMean.predict <- predict(mpgWeight.model, newCarMean, interval="confidence")
mpgMean.predict[1,"lwr"]

# Q4
summary(mpgWeight.model)

# Q5
newCar <- data.frame(wt = c(3))
mpg.predict <- predict(mpgWeight.model, newCar, interval="predict")
mpg.predict[1,"upr"]

# Q6
mtcars$shortTons <- mtcars$wt / 2
mpgShortTons.model <- lm(mpg ~ shortTons, mtcars)
summary(mpgShortTons.model)
confint(mpgShortTons.model)

# Q9
sumSquaredErrors.intercept <- sum((mtcars$mpg - mpgWeight.model$coefficients[1])^2)
sumSquaredErrors.both <- sum((mtcars$mpg - predict(mpgWeight.model, mtcars))^2)
sumSquaredErrors.both <- sum(resid(mpgWeight.model)^2)
sumSquaredErrors.both / sumSquaredErrors.intercept
sumSquaredErrors.intercept <- sum(resid(lm(mtcars$mpg ~ 1))^2)

sum(resid(mpgWeight.model))
