# Q1
x <- c(0.18, -1.54, 0.42, 0.95)
w <- c(2, 1, 3, 1)
sum(w*(x-0.3)^2)
sum(w*(x-0.1471)^2)
sum(w*(x-0.0025)^2)
sum(w*(x-1.077)^2)

# Q2
x <- c(0.8, 0.47, 0.51, 0.73, 0.36, 0.58, 0.57, 0.85, 0.44, 0.42)
y <- c(1.39, 0.72, 1.55, 0.48, 1.19, -1.59, 1.23, -0.65, 1.49, 0.05)

# y is the outcome, x the predictor
beta1 <- cor(y, x) *  sd(y) / sd(x)
beta1

# Q3
data(mtcars)
colnames(mtcars)

# mpg is outcome predicted by weight (wt)
with(mtcars, cor(mpg, wt) *  sd(mpg) / sd(wt))

# Q4 1

# Q5 0.6 (1.5 * slope)

# Q6
x <- c(8.58, 10.46, 9.01, 9.64, 8.86)
u <- x - mean(x)
mean(u)
z <- u / sd(x)
sd(z)
z[1]

# Q7
x <- c(0.8, 0.47, 0.51, 0.73, 0.36, 0.58, 0.57, 0.85, 0.44, 0.42)
y <- c(1.39, 0.72, 1.55, 0.48, 1.19, -1.59, 1.23, -0.65, 1.49, 0.05)

myPlot <- function(beta){
    freqData <- as.data.frame(table(x, y))
    names(freqData) <- c("x", "y", "freq")
    plot(
        as.numeric(as.vector(freqData$x)), 
        as.numeric(as.vector(freqData$y)),
        pch = 21, col = "black", bg = "lightblue",
        cex = .15 * freqData$freq, 
        xlab = "x", 
        ylab = "y",
        xlim=c(-1,1)
    )
    abline(0, beta, lwd = 3)
    points(0, 0, cex = 2, pch = 19)
    mse <- mean( (y - beta * x)^2 )
    title(paste("beta = ", beta, "mse = ", round(mse, 3)))
}
manipulate(myPlot(beta), beta = slider(-2, 2, step = 0.2))


# x predictor, y outcome
slope <- cor(y, x) * sd(y) / sd(x)
intercept <- mean(y) - slope * mean(x)
intercept

# Q8 intercept is 0 (intercept = mean(y) - slope * mean(x))

# Q9
x <- c(0.8, 0.47, 0.51, 0.73, 0.36, 0.58, 0.57, 0.85, 0.44, 0.42)
sum((x-0.573)^2)
sum((x-0.8)^2)
sum((x-0.36)^2)
sum((x-0.44)^2)
