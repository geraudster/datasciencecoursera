# Q1
12 - qnorm(0.05) * (4 / sqrt(100))

# Q2
baseline <- c(140, 138, 150, 148, 135) 	
week2 <- c(132, 135, 151, 146, 130)
t.test(baseline, week2, alternative = "two.sided", paired = TRUE)$p.value

# Q3
round(1100 - qnorm(0.025) * (30 / sqrt(9)))
round(1100 + qnorm(0.025) * (30 / sqrt(9)))

# Q4
round(pbinom(2, prob = 0.5, size = 4, lower.tail = FALSE), 2)

# Q5
round(ppois(10, lambda = 0.01 * 1787, lower.tail = TRUE), 2)
