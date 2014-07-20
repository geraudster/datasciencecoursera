
# Q2
(0.75 * 0.3) / ((0.75 * 0.3) + (1 - 0.52)*(1 - 0.3))

# Q3
round(pnorm(70, mean=80, sd=10) * 100)

# Q4
round(qnorm(.95, mean=1100, sd=75))

# Q5
round(qnorm(.95, mean=1100, sd=75/sqrt(100)))

# Q6
round(pbinom(3, prob=0.5, size=5, lower.tail=FALSE) * 100)


# Q7
15 + c(-1, 1) * qt(0.95, 100 - 1) * 10/sqrt(100)
qnorm(0.1, mean=15, sd=10/sqrt(100))

z1 <- (14 - 15) / 10
z2 <- (16 - 15) / 10
p14 <- -0.53983
p16 <- 0.53983

round(ppois(14, lambda = 15) * 100)


# Q8
qnorm(.5, mean=0.5, sd=sqrt(1/12/1000))

# Q9
1/12/sqrt(1000)

# Q10
round(ppois(10, lambda = 3 * 5) * 100)

# Q11
factorial(9)/(factorial(3) * (factorial(9 - 3)))
