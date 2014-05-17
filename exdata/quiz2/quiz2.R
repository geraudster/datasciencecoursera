# Q2
library(nlme)
library(lattice)
xyplot(weight ~ Time | Diet, BodyWeight)

# Q3
?lpoints #lattice
?points #base
?lines #base
?text #base

# Q5
?splom # scatter plot matrices
?trellis.par.set # graphical parameters
?par # base
?print.trellis # print override for lattice trellis

# Q7
install.packages("ggplot2")
library(ggplot2)
library(datasets)
data(airquality)
str(airquality)
airquality = transform(airquality, Month = factor(Month))
qplot(Wind, Ozone, data = airquality, facets = . ~ Month)

# Q10
?geom_smooth
data(movies)
str(movies)
# should be this:
qplot(votes, rating, data = movies) + stat_smooth(method="loess")
