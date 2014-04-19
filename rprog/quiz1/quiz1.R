setwd('/home/geraud/projets/datasciencequiz/rprog/quiz1')
data <- read.csv('hw1_data.csv')

head(data, 2)
tail(data,2)
data$Ozone[47]
all <- is.na(data$Ozone)
allna <- all[all == TRUE]
length(allna)

mean(data$Ozone, na.rm=T)

sub <- subset(data, data$Ozone > 31 & data$Temp > 90)
mean(sub$Solar.R)

mean(data$Temp[data$Month == 6])
max(data$Ozone[!is.na(data$Ozone)][data$Month == 5])
