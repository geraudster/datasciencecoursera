library(datasets)
data(iris)

# Q1
s <- split(iris, iris$Species)
mean(s$virginica$Sepal.Length)

# Q2
rowMeans(iris[,1:4])
colMeans(iris[,1:4])
apply(iris[,1:4], 2, mean)

# Q3
data(mtcars)
lapply(split(mtcars$mpg, mtcars$cyl), mean)

# Q4
means <- lapply(split(mtcars$hp, mtcars$cyl), mean)
abs(means$`4` - means$`8`)
