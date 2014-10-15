# Q1
m <- 12
s <- 4
n <- 100
z <- qnorm(0.05)
m + z * s / sqrt(n)

# Q2
baseline <- c(140, 138, 150, 148, 135) 	
week2 <- c(132, 135, 151, 146, 130)
t.test(baseline, week2, alternative = "two.sided", paired = TRUE)$p.value

# Q3
m <- 1100
s <- 30
n <- 9
error <- qt(0.975, df=n-1) * (s / sqrt(n))
round(m + c(-1,1) * error)

# Q4
round(pbinom(2, prob = 0.5, size = 4, lower.tail = FALSE), 2)

# Q5
round(ppois(10, lambda = 0.01 * 1787, lower.tail = TRUE), 2)

# Q6
n <- 9
m.new <- -3
s.new <- 1.5
m.pla <- 1
s.pla <- 1.8

sp <- sqrt(((n-1) * s.new ^2 + (n-1) * s.pla ^2)/(n + n -2))
round(m.new - m.pla + c(-1, 1) * qt(0.975, 2 * n - 2) * sp * (1/n + 1/n)^0.5, 3)

t <- (m.new - m.pla) / (sp * sqrt((1 / 9) + (1 / 9)))
pt(t, df=n - 1)

# Q7

# Q8
m <- 0
s <- 0.04
n <- 100
h.a <- -0.01

mypower <- function(m, s, n, h.a) {
    error <- qt(0.95, df = n -1) * s / sqrt(n)
    conf.int <- m + c(-1,1) * error
    z.conf.int <- (conf.int - h.a) / (s / sqrt(n))
    p <- pt(z.conf.int[2], df = n -1) - pt(z.conf.int[1], df = n - 1)
    round(1 - p, 2)
}

mypower(m, s, n, h.a)

# also:
power.t.test(n = n, delta = m - h.a, sd = s, type = "paired", alt = "one.sided")

# Q9
mypower(m, s, 180, h.a)
mypower(m, s, 160, h.a)
mypower(m, s, 120, h.a)
mypower(m, s, 140, h.a)

# also:
power.t.test(power = 0.9, delta = m - h.a, sd = 0.04, type = "one.sample", alt = "one.sided")

# Q11
m0 <- 44
n <- 288 # * 2
m1 <- 42.04
s <- 12

sp <- sqrt(((n-1) * s ^2 + (n-1) * s ^2)/(n + n -2))
#se <- sqrt(s*s/n+s*s/n)
t <- (m0 - m1) / (sp * sqrt((1 / n) + (1 / n)))
2*pnorm(-abs(t))
round(pt(-t, df = n-1), 4)
