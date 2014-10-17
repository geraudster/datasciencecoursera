## Data loading


```r
library(reshape)
source('loadData.R')
trainingUrl <- 'https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv'
testingUrl <- 'https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv'
  
loadDataFile(trainingUrl, "data/pml-training.csv", unzip=FALSE)
loadDataFile(testingUrl, "data/pml-testing.csv", unzip=FALSE)

training <- read.csv("data/pml-training.csv")
training$timestamp <- paste0(training$raw_timestamp_part_1, training$raw_timestamp_part_2)
testing <- read.csv("data/pml-testing.csv")
```

## Some queries


```r
head(training[,seq(1,7)], 20)
```

```
##     X user_name raw_timestamp_part_1 raw_timestamp_part_2   cvtd_timestamp
## 1   1  carlitos           1323084231               788290 05/12/2011 11:23
## 2   2  carlitos           1323084231               808298 05/12/2011 11:23
## 3   3  carlitos           1323084231               820366 05/12/2011 11:23
## 4   4  carlitos           1323084232               120339 05/12/2011 11:23
## 5   5  carlitos           1323084232               196328 05/12/2011 11:23
## 6   6  carlitos           1323084232               304277 05/12/2011 11:23
## 7   7  carlitos           1323084232               368296 05/12/2011 11:23
## 8   8  carlitos           1323084232               440390 05/12/2011 11:23
## 9   9  carlitos           1323084232               484323 05/12/2011 11:23
## 10 10  carlitos           1323084232               484434 05/12/2011 11:23
## 11 11  carlitos           1323084232               500302 05/12/2011 11:23
## 12 12  carlitos           1323084232               528316 05/12/2011 11:23
## 13 13  carlitos           1323084232               560359 05/12/2011 11:23
## 14 14  carlitos           1323084232               576390 05/12/2011 11:23
## 15 15  carlitos           1323084232               604281 05/12/2011 11:23
## 16 16  carlitos           1323084232               644302 05/12/2011 11:23
## 17 17  carlitos           1323084232               692324 05/12/2011 11:23
## 18 18  carlitos           1323084232               732306 05/12/2011 11:23
## 19 19  carlitos           1323084232               740353 05/12/2011 11:23
## 20 20  carlitos           1323084232               788335 05/12/2011 11:23
##    new_window num_window
## 1          no         11
## 2          no         11
## 3          no         11
## 4          no         12
## 5          no         12
## 6          no         12
## 7          no         12
## 8          no         12
## 9          no         12
## 10         no         12
## 11         no         12
## 12         no         12
## 13         no         12
## 14         no         12
## 15         no         12
## 16         no         12
## 17         no         12
## 18         no         12
## 19         no         12
## 20         no         12
```

```r
library(sqldf)
```

```
## Loading required package: gsubfn
## Loading required package: proto
## Loading required package: RSQLite
## Loading required package: DBI
## Loading required package: RSQLite.extfuns
```

```r
sqldf("select X, user_name, timestamp from training where num_window = 12")
```

```
## Loading required package: tcltk
```

```
##     X user_name        timestamp
## 1   4  carlitos 1323084232120339
## 2   5  carlitos 1323084232196328
## 3   6  carlitos 1323084232304277
## 4   7  carlitos 1323084232368296
## 5   8  carlitos 1323084232440390
## 6   9  carlitos 1323084232484323
## 7  10  carlitos 1323084232484434
## 8  11  carlitos 1323084232500302
## 9  12  carlitos 1323084232528316
## 10 13  carlitos 1323084232560359
## 11 14  carlitos 1323084232576390
## 12 15  carlitos 1323084232604281
## 13 16  carlitos 1323084232644302
## 14 17  carlitos 1323084232692324
## 15 18  carlitos 1323084232732306
## 16 19  carlitos 1323084232740353
## 17 20  carlitos 1323084232788335
## 18 21  carlitos 1323084232876301
## 19 22  carlitos 1323084232892313
## 20 23  carlitos 1323084232932285
## 21 24  carlitos 1323084232996313
```

## First model


```r
library(caret)
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```r
set.seed(32343)
#modelFit <- train(classe ~ ., data=training, method="glm")
#modelFit
```
