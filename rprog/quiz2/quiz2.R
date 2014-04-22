library(datasets)
data(iris)

# Q1
s <- split(iris, iris$Species)
mean(s$virginica$Sepal.Length)

# Q2
rowMeans(iris[,1:4])
colMeans(iris[,1:4])
apply(iris[,1:4], 2, mean)

