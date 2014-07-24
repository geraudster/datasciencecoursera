# Q1
round(1100 + qt(.975, 8) * 30 / sqrt(9))
round(1100 - qt(.975, 8) * 30 / sqrt(9))

# Q2
(-2 / qt(.975, 8)) * sqrt(9)

# Q4
mn <- 3 - 5
n.new <- 10
df.new <- n.new - 1
var.new <- 0.6
n.std <- 10
df.std <- n.std - 1
var.std <- 0.68

sp <- sqrt((df.new * var.new + df.std * var.std)/(df.new + df.std))
round(mn + c(-1, 1) * qt(0.975, df.new + df.std) * sp * (1/n.new + 1/n.std)^0.5, 2)

# Q6
n <- 100
m.new <- 4
s.new <- 0.5
m.old <- 6
s.old <- 2

sp <- sqrt(((n-1) * s.new ^2 + (n-1) * s.old ^2)/(n + n -2))
round(m.old - m.new + c(-1, 1) * qt(0.975, 2 * n - 2) * sp * (1/n + 1/n)^0.5, 2)

(m.old - m.new) / (sp * sqrt(1/n + 1/n))
qt(0.975, 2 * n - 2)

# Q7
n <- 9
m.new <- -3
s.new <- 1.5
m.pla <- 1
s.pla <- 1.8

sp <- sqrt(((n-1) * s.new ^2 + (n-1) * s.pla ^2)/(n + n -2))
round(m.new - m.pla + c(-1, 1) * qt(0.95, 2 * n - 2) * sp * (1/n + 1/n)^0.5, 3)
