
## Install libraries


```r
#install.packages('caret')
#install.packages('e1071')
#install.packages('gbm')
#install.packages('randomForest')
#install.packages('doMC', dependencies = TRUE)
```

## Data loading


```r
library(caret)
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```r
source('loadData.R')
trainingUrl <- 'https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv'
testingUrl <- 'https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv'
  
loadDataFile(trainingUrl, "data/pml-training.csv", unzip=FALSE)
loadDataFile(testingUrl, "data/pml-testing.csv", unzip=FALSE)

data <- read.csv("data/pml-training.csv")
inTrain <- createDataPartition(y=data$classe, p=0.75, list=FALSE)

training <- data[inTrain,]
testing <- data[-inTrain,]

validation <- read.csv("data/pml-testing.csv")
```


Several columns contain lots of empty or NAs values:

```r
str(training)
```

```
## 'data.frame':	14718 obs. of  160 variables:
##  $ X                       : int  1 4 6 7 8 10 11 13 14 16 ...
##  $ user_name               : Factor w/ 6 levels "adelmo","carlitos",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ raw_timestamp_part_1    : int  1323084231 1323084232 1323084232 1323084232 1323084232 1323084232 1323084232 1323084232 1323084232 1323084232 ...
##  $ raw_timestamp_part_2    : int  788290 120339 304277 368296 440390 484434 500302 560359 576390 644302 ...
##  $ cvtd_timestamp          : Factor w/ 20 levels "02/12/2011 13:32",..: 9 9 9 9 9 9 9 9 9 9 ...
##  $ new_window              : Factor w/ 2 levels "no","yes": 1 1 1 1 1 1 1 1 1 1 ...
##  $ num_window              : int  11 12 12 12 12 12 12 12 12 12 ...
##  $ roll_belt               : num  1.41 1.48 1.45 1.42 1.42 1.45 1.45 1.42 1.42 1.48 ...
##  $ pitch_belt              : num  8.07 8.05 8.06 8.09 8.13 8.17 8.18 8.2 8.21 8.15 ...
##  $ yaw_belt                : num  -94.4 -94.4 -94.4 -94.4 -94.4 -94.4 -94.4 -94.4 -94.4 -94.4 ...
##  $ total_accel_belt        : int  3 3 3 3 3 3 3 3 3 3 ...
##  $ kurtosis_roll_belt      : Factor w/ 397 levels "","0.000673",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ kurtosis_picth_belt     : Factor w/ 317 levels "","0.006078",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ kurtosis_yaw_belt       : Factor w/ 2 levels "","#DIV/0!": 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_roll_belt      : Factor w/ 395 levels "","0.000000",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_roll_belt.1    : Factor w/ 338 levels "","0.000000",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_yaw_belt       : Factor w/ 2 levels "","#DIV/0!": 1 1 1 1 1 1 1 1 1 1 ...
##  $ max_roll_belt           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ max_picth_belt          : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ max_yaw_belt            : Factor w/ 68 levels "","0.0","-0.1",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ min_roll_belt           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_pitch_belt          : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_yaw_belt            : Factor w/ 68 levels "","0.0","-0.1",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ amplitude_roll_belt     : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ amplitude_pitch_belt    : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ amplitude_yaw_belt      : Factor w/ 4 levels "","0.00","0.0000",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ var_total_accel_belt    : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ avg_roll_belt           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ stddev_roll_belt        : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ var_roll_belt           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ avg_pitch_belt          : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ stddev_pitch_belt       : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ var_pitch_belt          : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ avg_yaw_belt            : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ stddev_yaw_belt         : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ var_yaw_belt            : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ gyros_belt_x            : num  0 0.02 0.02 0.02 0.02 0.03 0.03 0.02 0.02 0 ...
##  $ gyros_belt_y            : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ gyros_belt_z            : num  -0.02 -0.03 -0.02 -0.02 -0.02 0 -0.02 0 -0.02 0 ...
##  $ accel_belt_x            : int  -21 -22 -21 -22 -22 -21 -21 -22 -22 -21 ...
##  $ accel_belt_y            : int  4 3 4 3 4 4 2 4 4 4 ...
##  $ accel_belt_z            : int  22 21 21 21 21 22 23 21 21 23 ...
##  $ magnet_belt_x           : int  -3 -6 0 -4 -2 -3 -5 -3 -8 0 ...
##  $ magnet_belt_y           : int  599 604 603 599 603 609 596 606 598 592 ...
##  $ magnet_belt_z           : int  -313 -310 -312 -311 -313 -308 -317 -309 -310 -305 ...
##  $ roll_arm                : num  -128 -128 -128 -128 -128 -128 -128 -128 -128 -129 ...
##  $ pitch_arm               : num  22.5 22.1 22 21.9 21.8 21.6 21.5 21.4 21.4 21.3 ...
##  $ yaw_arm                 : num  -161 -161 -161 -161 -161 -161 -161 -161 -161 -161 ...
##  $ total_accel_arm         : int  34 34 34 34 34 34 34 34 34 34 ...
##  $ var_accel_arm           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ avg_roll_arm            : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ stddev_roll_arm         : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ var_roll_arm            : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ avg_pitch_arm           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ stddev_pitch_arm        : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ var_pitch_arm           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ avg_yaw_arm             : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ stddev_yaw_arm          : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ var_yaw_arm             : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ gyros_arm_x             : num  0 0.02 0.02 0 0.02 0.02 0.02 0.02 0.02 0.02 ...
##  $ gyros_arm_y             : num  0 -0.03 -0.03 -0.03 -0.02 -0.03 -0.03 -0.02 0 0 ...
##  $ gyros_arm_z             : num  -0.02 0.02 0 0 0 -0.02 0 -0.02 -0.03 -0.03 ...
##  $ accel_arm_x             : int  -288 -289 -289 -289 -289 -288 -290 -287 -288 -289 ...
##  $ accel_arm_y             : int  109 111 111 111 111 110 110 111 111 109 ...
##  $ accel_arm_z             : int  -123 -123 -122 -125 -124 -124 -123 -124 -124 -121 ...
##  $ magnet_arm_x            : int  -368 -372 -369 -373 -372 -376 -366 -372 -371 -367 ...
##  $ magnet_arm_y            : int  337 344 342 336 338 334 339 338 331 340 ...
##  $ magnet_arm_z            : int  516 512 513 509 510 516 509 509 523 509 ...
##  $ kurtosis_roll_arm       : Factor w/ 330 levels "","0.01388","0.01574",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ kurtosis_picth_arm      : Factor w/ 328 levels "","-0.00484",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ kurtosis_yaw_arm        : Factor w/ 395 levels "","-0.01548",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_roll_arm       : Factor w/ 331 levels "","-0.00051",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_pitch_arm      : Factor w/ 328 levels "","0.00000","-0.00184",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_yaw_arm        : Factor w/ 395 levels "","0.00000","-0.00311",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ max_roll_arm            : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ max_picth_arm           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ max_yaw_arm             : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_roll_arm            : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_pitch_arm           : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_yaw_arm             : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ amplitude_roll_arm      : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ amplitude_pitch_arm     : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ amplitude_yaw_arm       : int  NA NA NA NA NA NA NA NA NA NA ...
##  $ roll_dumbbell           : num  13.1 13.4 13.4 13.1 12.8 ...
##  $ pitch_dumbbell          : num  -70.5 -70.4 -70.8 -70.2 -70.3 ...
##  $ yaw_dumbbell            : num  -84.9 -84.9 -84.5 -85.1 -85.1 ...
##  $ kurtosis_roll_dumbbell  : Factor w/ 398 levels "","0.0016","-0.0035",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ kurtosis_picth_dumbbell : Factor w/ 401 levels "","0.0045","0.0130",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ kurtosis_yaw_dumbbell   : Factor w/ 2 levels "","#DIV/0!": 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_roll_dumbbell  : Factor w/ 401 levels "","0.0011","0.0014",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_pitch_dumbbell : Factor w/ 402 levels "","-0.0053","0.0063",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ skewness_yaw_dumbbell   : Factor w/ 2 levels "","#DIV/0!": 1 1 1 1 1 1 1 1 1 1 ...
##  $ max_roll_dumbbell       : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ max_picth_dumbbell      : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ max_yaw_dumbbell        : Factor w/ 73 levels "","0.0","-0.1",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ min_roll_dumbbell       : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_pitch_dumbbell      : num  NA NA NA NA NA NA NA NA NA NA ...
##  $ min_yaw_dumbbell        : Factor w/ 73 levels "","0.0","-0.1",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ amplitude_roll_dumbbell : num  NA NA NA NA NA NA NA NA NA NA ...
##   [list output truncated]
```

So we filter the column with more than 95% of NAs:

```r
colnamesForFilter <- colnames(training)
colsPercent <- sapply(colnamesForFilter, function(x) {
    na <- is.na(training[,x]) | training[,x] == ''
    sum(na)/length(na)
})

trainingColnames <- names(which(colsPercent < 0.95))
```

So below is our dataset:

```r
trainingData <- training[training$new_window == 'no',trainingColnames[-c(1, 3:7, 61)]]
testingData <- testing[testing$new_window == 'no',trainingColnames[-c(1, 3:7, 61)]]
```

## Training model with GBM


```r
gbmModel <- list()
gbmModel$time <- system.time(gbmModel$fit <- train( classe ~ ., data=trainingData, method="gbm"))
```

```
## Loading required package: gbm
## Loading required package: survival
## Loading required package: splines
## 
## Attaching package: 'survival'
## 
## The following object is masked from 'package:caret':
## 
##     cluster
## 
## Loading required package: parallel
## Loaded gbm 2.1
## Loading required package: plyr
```

```
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1241
##      2        1.5258            -nan     0.1000    0.0899
##      3        1.4674            -nan     0.1000    0.0612
##      4        1.4257            -nan     0.1000    0.0553
##      5        1.3891            -nan     0.1000    0.0507
##      6        1.3554            -nan     0.1000    0.0426
##      7        1.3291            -nan     0.1000    0.0429
##      8        1.3023            -nan     0.1000    0.0339
##      9        1.2808            -nan     0.1000    0.0345
##     10        1.2584            -nan     0.1000    0.0342
##     20        1.1047            -nan     0.1000    0.0187
##     40        0.9281            -nan     0.1000    0.0093
##     60        0.8174            -nan     0.1000    0.0065
##     80        0.7369            -nan     0.1000    0.0055
##    100        0.6725            -nan     0.1000    0.0039
##    120        0.6195            -nan     0.1000    0.0029
##    140        0.5783            -nan     0.1000    0.0031
##    150        0.5592            -nan     0.1000    0.0020
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1866
##      2        1.4877            -nan     0.1000    0.1318
##      3        1.4036            -nan     0.1000    0.1038
##      4        1.3376            -nan     0.1000    0.0840
##      5        1.2830            -nan     0.1000    0.0786
##      6        1.2338            -nan     0.1000    0.0691
##      7        1.1899            -nan     0.1000    0.0661
##      8        1.1497            -nan     0.1000    0.0503
##      9        1.1180            -nan     0.1000    0.0526
##     10        1.0851            -nan     0.1000    0.0385
##     20        0.8930            -nan     0.1000    0.0276
##     40        0.6717            -nan     0.1000    0.0107
##     60        0.5399            -nan     0.1000    0.0070
##     80        0.4498            -nan     0.1000    0.0074
##    100        0.3836            -nan     0.1000    0.0021
##    120        0.3372            -nan     0.1000    0.0032
##    140        0.2949            -nan     0.1000    0.0024
##    150        0.2778            -nan     0.1000    0.0031
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2320
##      2        1.4606            -nan     0.1000    0.1708
##      3        1.3540            -nan     0.1000    0.1263
##      4        1.2752            -nan     0.1000    0.1121
##      5        1.2054            -nan     0.1000    0.0917
##      6        1.1487            -nan     0.1000    0.0698
##      7        1.1035            -nan     0.1000    0.0679
##      8        1.0606            -nan     0.1000    0.0662
##      9        1.0196            -nan     0.1000    0.0566
##     10        0.9841            -nan     0.1000    0.0553
##     20        0.7446            -nan     0.1000    0.0208
##     40        0.5218            -nan     0.1000    0.0117
##     60        0.3980            -nan     0.1000    0.0079
##     80        0.3140            -nan     0.1000    0.0050
##    100        0.2563            -nan     0.1000    0.0059
##    120        0.2161            -nan     0.1000    0.0022
##    140        0.1833            -nan     0.1000    0.0024
##    150        0.1687            -nan     0.1000    0.0014
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1248
##      2        1.5257            -nan     0.1000    0.0864
##      3        1.4687            -nan     0.1000    0.0661
##      4        1.4265            -nan     0.1000    0.0533
##      5        1.3919            -nan     0.1000    0.0506
##      6        1.3596            -nan     0.1000    0.0474
##      7        1.3299            -nan     0.1000    0.0353
##      8        1.3073            -nan     0.1000    0.0363
##      9        1.2838            -nan     0.1000    0.0325
##     10        1.2633            -nan     0.1000    0.0314
##     20        1.1113            -nan     0.1000    0.0186
##     40        0.9364            -nan     0.1000    0.0117
##     60        0.8248            -nan     0.1000    0.0057
##     80        0.7438            -nan     0.1000    0.0053
##    100        0.6811            -nan     0.1000    0.0038
##    120        0.6284            -nan     0.1000    0.0032
##    140        0.5851            -nan     0.1000    0.0020
##    150        0.5658            -nan     0.1000    0.0024
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1854
##      2        1.4917            -nan     0.1000    0.1248
##      3        1.4106            -nan     0.1000    0.1077
##      4        1.3419            -nan     0.1000    0.0803
##      5        1.2907            -nan     0.1000    0.0721
##      6        1.2444            -nan     0.1000    0.0711
##      7        1.1998            -nan     0.1000    0.0602
##      8        1.1621            -nan     0.1000    0.0485
##      9        1.1314            -nan     0.1000    0.0474
##     10        1.1023            -nan     0.1000    0.0441
##     20        0.8974            -nan     0.1000    0.0255
##     40        0.6732            -nan     0.1000    0.0121
##     60        0.5504            -nan     0.1000    0.0074
##     80        0.4595            -nan     0.1000    0.0068
##    100        0.3968            -nan     0.1000    0.0043
##    120        0.3416            -nan     0.1000    0.0031
##    140        0.2989            -nan     0.1000    0.0018
##    150        0.2814            -nan     0.1000    0.0019
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2288
##      2        1.4633            -nan     0.1000    0.1563
##      3        1.3634            -nan     0.1000    0.1345
##      4        1.2795            -nan     0.1000    0.0950
##      5        1.2186            -nan     0.1000    0.0830
##      6        1.1656            -nan     0.1000    0.0843
##      7        1.1126            -nan     0.1000    0.0791
##      8        1.0646            -nan     0.1000    0.0615
##      9        1.0265            -nan     0.1000    0.0546
##     10        0.9925            -nan     0.1000    0.0545
##     20        0.7586            -nan     0.1000    0.0268
##     40        0.5237            -nan     0.1000    0.0109
##     60        0.3978            -nan     0.1000    0.0075
##     80        0.3172            -nan     0.1000    0.0052
##    100        0.2602            -nan     0.1000    0.0039
##    120        0.2149            -nan     0.1000    0.0030
##    140        0.1825            -nan     0.1000    0.0014
##    150        0.1684            -nan     0.1000    0.0012
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1294
##      2        1.5234            -nan     0.1000    0.0874
##      3        1.4650            -nan     0.1000    0.0676
##      4        1.4207            -nan     0.1000    0.0550
##      5        1.3843            -nan     0.1000    0.0514
##      6        1.3515            -nan     0.1000    0.0435
##      7        1.3231            -nan     0.1000    0.0374
##      8        1.2992            -nan     0.1000    0.0362
##      9        1.2759            -nan     0.1000    0.0333
##     10        1.2543            -nan     0.1000    0.0278
##     20        1.1026            -nan     0.1000    0.0152
##     40        0.9271            -nan     0.1000    0.0080
##     60        0.8202            -nan     0.1000    0.0069
##     80        0.7419            -nan     0.1000    0.0052
##    100        0.6786            -nan     0.1000    0.0038
##    120        0.6265            -nan     0.1000    0.0026
##    140        0.5814            -nan     0.1000    0.0028
##    150        0.5624            -nan     0.1000    0.0028
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1853
##      2        1.4899            -nan     0.1000    0.1290
##      3        1.4068            -nan     0.1000    0.1036
##      4        1.3406            -nan     0.1000    0.0810
##      5        1.2873            -nan     0.1000    0.0756
##      6        1.2409            -nan     0.1000    0.0693
##      7        1.1968            -nan     0.1000    0.0603
##      8        1.1588            -nan     0.1000    0.0590
##      9        1.1223            -nan     0.1000    0.0540
##     10        1.0900            -nan     0.1000    0.0428
##     20        0.8899            -nan     0.1000    0.0210
##     40        0.6734            -nan     0.1000    0.0093
##     60        0.5487            -nan     0.1000    0.0074
##     80        0.4610            -nan     0.1000    0.0048
##    100        0.3956            -nan     0.1000    0.0045
##    120        0.3442            -nan     0.1000    0.0022
##    140        0.3003            -nan     0.1000    0.0021
##    150        0.2817            -nan     0.1000    0.0014
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2377
##      2        1.4602            -nan     0.1000    0.1648
##      3        1.3576            -nan     0.1000    0.1256
##      4        1.2783            -nan     0.1000    0.1066
##      5        1.2107            -nan     0.1000    0.0949
##      6        1.1515            -nan     0.1000    0.0778
##      7        1.1040            -nan     0.1000    0.0639
##      8        1.0635            -nan     0.1000    0.0806
##      9        1.0144            -nan     0.1000    0.0507
##     10        0.9825            -nan     0.1000    0.0566
##     20        0.7508            -nan     0.1000    0.0317
##     40        0.5230            -nan     0.1000    0.0102
##     60        0.3964            -nan     0.1000    0.0060
##     80        0.3133            -nan     0.1000    0.0044
##    100        0.2552            -nan     0.1000    0.0035
##    120        0.2147            -nan     0.1000    0.0031
##    140        0.1805            -nan     0.1000    0.0016
##    150        0.1679            -nan     0.1000    0.0018
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1287
##      2        1.5229            -nan     0.1000    0.0921
##      3        1.4630            -nan     0.1000    0.0676
##      4        1.4185            -nan     0.1000    0.0520
##      5        1.3839            -nan     0.1000    0.0511
##      6        1.3513            -nan     0.1000    0.0477
##      7        1.3212            -nan     0.1000    0.0326
##      8        1.2995            -nan     0.1000    0.0367
##      9        1.2748            -nan     0.1000    0.0326
##     10        1.2536            -nan     0.1000    0.0344
##     20        1.0992            -nan     0.1000    0.0198
##     40        0.9262            -nan     0.1000    0.0097
##     60        0.8212            -nan     0.1000    0.0055
##     80        0.7407            -nan     0.1000    0.0050
##    100        0.6789            -nan     0.1000    0.0047
##    120        0.6266            -nan     0.1000    0.0040
##    140        0.5834            -nan     0.1000    0.0018
##    150        0.5642            -nan     0.1000    0.0024
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1895
##      2        1.4881            -nan     0.1000    0.1334
##      3        1.4030            -nan     0.1000    0.1081
##      4        1.3343            -nan     0.1000    0.0823
##      5        1.2827            -nan     0.1000    0.0669
##      6        1.2397            -nan     0.1000    0.0797
##      7        1.1903            -nan     0.1000    0.0604
##      8        1.1534            -nan     0.1000    0.0560
##      9        1.1176            -nan     0.1000    0.0472
##     10        1.0889            -nan     0.1000    0.0459
##     20        0.8847            -nan     0.1000    0.0183
##     40        0.6809            -nan     0.1000    0.0145
##     60        0.5540            -nan     0.1000    0.0098
##     80        0.4632            -nan     0.1000    0.0060
##    100        0.3918            -nan     0.1000    0.0034
##    120        0.3384            -nan     0.1000    0.0027
##    140        0.2990            -nan     0.1000    0.0022
##    150        0.2805            -nan     0.1000    0.0035
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2322
##      2        1.4585            -nan     0.1000    0.1686
##      3        1.3525            -nan     0.1000    0.1198
##      4        1.2755            -nan     0.1000    0.1011
##      5        1.2111            -nan     0.1000    0.0980
##      6        1.1494            -nan     0.1000    0.0703
##      7        1.1047            -nan     0.1000    0.0833
##      8        1.0547            -nan     0.1000    0.0649
##      9        1.0143            -nan     0.1000    0.0550
##     10        0.9803            -nan     0.1000    0.0568
##     20        0.7467            -nan     0.1000    0.0232
##     40        0.5220            -nan     0.1000    0.0133
##     60        0.3963            -nan     0.1000    0.0088
##     80        0.3169            -nan     0.1000    0.0039
##    100        0.2600            -nan     0.1000    0.0035
##    120        0.2176            -nan     0.1000    0.0025
##    140        0.1838            -nan     0.1000    0.0019
##    150        0.1700            -nan     0.1000    0.0021
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1274
##      2        1.5242            -nan     0.1000    0.0861
##      3        1.4661            -nan     0.1000    0.0656
##      4        1.4228            -nan     0.1000    0.0546
##      5        1.3869            -nan     0.1000    0.0516
##      6        1.3538            -nan     0.1000    0.0464
##      7        1.3248            -nan     0.1000    0.0348
##      8        1.3020            -nan     0.1000    0.0376
##      9        1.2786            -nan     0.1000    0.0323
##     10        1.2589            -nan     0.1000    0.0316
##     20        1.1041            -nan     0.1000    0.0174
##     40        0.9346            -nan     0.1000    0.0101
##     60        0.8291            -nan     0.1000    0.0076
##     80        0.7492            -nan     0.1000    0.0045
##    100        0.6863            -nan     0.1000    0.0033
##    120        0.6355            -nan     0.1000    0.0030
##    140        0.5910            -nan     0.1000    0.0026
##    150        0.5713            -nan     0.1000    0.0027
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1806
##      2        1.4911            -nan     0.1000    0.1245
##      3        1.4108            -nan     0.1000    0.0969
##      4        1.3486            -nan     0.1000    0.0889
##      5        1.2921            -nan     0.1000    0.0711
##      6        1.2464            -nan     0.1000    0.0683
##      7        1.2030            -nan     0.1000    0.0586
##      8        1.1660            -nan     0.1000    0.0550
##      9        1.1319            -nan     0.1000    0.0506
##     10        1.1004            -nan     0.1000    0.0398
##     20        0.8977            -nan     0.1000    0.0213
##     40        0.6834            -nan     0.1000    0.0119
##     60        0.5576            -nan     0.1000    0.0073
##     80        0.4651            -nan     0.1000    0.0059
##    100        0.4017            -nan     0.1000    0.0040
##    120        0.3503            -nan     0.1000    0.0023
##    140        0.3091            -nan     0.1000    0.0022
##    150        0.2907            -nan     0.1000    0.0030
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2269
##      2        1.4646            -nan     0.1000    0.1565
##      3        1.3652            -nan     0.1000    0.1343
##      4        1.2807            -nan     0.1000    0.1045
##      5        1.2136            -nan     0.1000    0.0889
##      6        1.1574            -nan     0.1000    0.0732
##      7        1.1113            -nan     0.1000    0.0672
##      8        1.0681            -nan     0.1000    0.0577
##      9        1.0316            -nan     0.1000    0.0603
##     10        0.9942            -nan     0.1000    0.0524
##     20        0.7663            -nan     0.1000    0.0230
##     40        0.5310            -nan     0.1000    0.0137
##     60        0.4011            -nan     0.1000    0.0066
##     80        0.3176            -nan     0.1000    0.0054
##    100        0.2583            -nan     0.1000    0.0043
##    120        0.2136            -nan     0.1000    0.0025
##    140        0.1811            -nan     0.1000    0.0015
##    150        0.1664            -nan     0.1000    0.0014
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1322
##      2        1.5241            -nan     0.1000    0.0843
##      3        1.4674            -nan     0.1000    0.0700
##      4        1.4219            -nan     0.1000    0.0515
##      5        1.3875            -nan     0.1000    0.0481
##      6        1.3558            -nan     0.1000    0.0405
##      7        1.3301            -nan     0.1000    0.0426
##      8        1.3041            -nan     0.1000    0.0379
##      9        1.2806            -nan     0.1000    0.0299
##     10        1.2605            -nan     0.1000    0.0333
##     20        1.1010            -nan     0.1000    0.0162
##     40        0.9307            -nan     0.1000    0.0098
##     60        0.8231            -nan     0.1000    0.0053
##     80        0.7446            -nan     0.1000    0.0045
##    100        0.6814            -nan     0.1000    0.0038
##    120        0.6295            -nan     0.1000    0.0031
##    140        0.5855            -nan     0.1000    0.0018
##    150        0.5670            -nan     0.1000    0.0024
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1821
##      2        1.4905            -nan     0.1000    0.1283
##      3        1.4068            -nan     0.1000    0.1030
##      4        1.3410            -nan     0.1000    0.0815
##      5        1.2882            -nan     0.1000    0.0763
##      6        1.2396            -nan     0.1000    0.0647
##      7        1.1989            -nan     0.1000    0.0639
##      8        1.1592            -nan     0.1000    0.0552
##      9        1.1252            -nan     0.1000    0.0466
##     10        1.0953            -nan     0.1000    0.0492
##     20        0.8910            -nan     0.1000    0.0270
##     40        0.6782            -nan     0.1000    0.0130
##     60        0.5539            -nan     0.1000    0.0067
##     80        0.4706            -nan     0.1000    0.0046
##    100        0.3957            -nan     0.1000    0.0059
##    120        0.3453            -nan     0.1000    0.0039
##    140        0.3041            -nan     0.1000    0.0025
##    150        0.2863            -nan     0.1000    0.0025
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2350
##      2        1.4595            -nan     0.1000    0.1643
##      3        1.3551            -nan     0.1000    0.1209
##      4        1.2790            -nan     0.1000    0.1036
##      5        1.2123            -nan     0.1000    0.0859
##      6        1.1581            -nan     0.1000    0.0781
##      7        1.1087            -nan     0.1000    0.0709
##      8        1.0646            -nan     0.1000    0.0599
##      9        1.0266            -nan     0.1000    0.0527
##     10        0.9928            -nan     0.1000    0.0649
##     20        0.7485            -nan     0.1000    0.0296
##     40        0.5236            -nan     0.1000    0.0136
##     60        0.3980            -nan     0.1000    0.0054
##     80        0.3216            -nan     0.1000    0.0056
##    100        0.2613            -nan     0.1000    0.0043
##    120        0.2174            -nan     0.1000    0.0028
##    140        0.1836            -nan     0.1000    0.0016
##    150        0.1705            -nan     0.1000    0.0012
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1265
##      2        1.5257            -nan     0.1000    0.0840
##      3        1.4696            -nan     0.1000    0.0663
##      4        1.4260            -nan     0.1000    0.0518
##      5        1.3914            -nan     0.1000    0.0437
##      6        1.3627            -nan     0.1000    0.0451
##      7        1.3341            -nan     0.1000    0.0401
##      8        1.3085            -nan     0.1000    0.0330
##      9        1.2872            -nan     0.1000    0.0376
##     10        1.2628            -nan     0.1000    0.0309
##     20        1.1060            -nan     0.1000    0.0196
##     40        0.9338            -nan     0.1000    0.0090
##     60        0.8265            -nan     0.1000    0.0067
##     80        0.7449            -nan     0.1000    0.0045
##    100        0.6833            -nan     0.1000    0.0028
##    120        0.6341            -nan     0.1000    0.0031
##    140        0.5904            -nan     0.1000    0.0019
##    150        0.5709            -nan     0.1000    0.0031
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1841
##      2        1.4886            -nan     0.1000    0.1251
##      3        1.4077            -nan     0.1000    0.1064
##      4        1.3405            -nan     0.1000    0.0868
##      5        1.2864            -nan     0.1000    0.0794
##      6        1.2364            -nan     0.1000    0.0615
##      7        1.1973            -nan     0.1000    0.0517
##      8        1.1645            -nan     0.1000    0.0579
##      9        1.1296            -nan     0.1000    0.0484
##     10        1.0998            -nan     0.1000    0.0425
##     20        0.8948            -nan     0.1000    0.0197
##     40        0.6767            -nan     0.1000    0.0128
##     60        0.5459            -nan     0.1000    0.0083
##     80        0.4603            -nan     0.1000    0.0072
##    100        0.3951            -nan     0.1000    0.0042
##    120        0.3439            -nan     0.1000    0.0033
##    140        0.3015            -nan     0.1000    0.0022
##    150        0.2824            -nan     0.1000    0.0025
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2369
##      2        1.4580            -nan     0.1000    0.1618
##      3        1.3567            -nan     0.1000    0.1265
##      4        1.2754            -nan     0.1000    0.1048
##      5        1.2089            -nan     0.1000    0.0899
##      6        1.1515            -nan     0.1000    0.0735
##      7        1.1046            -nan     0.1000    0.0637
##      8        1.0641            -nan     0.1000    0.0668
##      9        1.0228            -nan     0.1000    0.0538
##     10        0.9886            -nan     0.1000    0.0548
##     20        0.7589            -nan     0.1000    0.0246
##     40        0.5305            -nan     0.1000    0.0092
##     60        0.4043            -nan     0.1000    0.0066
##     80        0.3191            -nan     0.1000    0.0046
##    100        0.2608            -nan     0.1000    0.0033
##    120        0.2165            -nan     0.1000    0.0027
##    140        0.1845            -nan     0.1000    0.0015
##    150        0.1708            -nan     0.1000    0.0017
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1250
##      2        1.5257            -nan     0.1000    0.0888
##      3        1.4685            -nan     0.1000    0.0645
##      4        1.4252            -nan     0.1000    0.0531
##      5        1.3908            -nan     0.1000    0.0505
##      6        1.3581            -nan     0.1000    0.0398
##      7        1.3329            -nan     0.1000    0.0402
##      8        1.3076            -nan     0.1000    0.0327
##      9        1.2862            -nan     0.1000    0.0360
##     10        1.2626            -nan     0.1000    0.0299
##     20        1.1075            -nan     0.1000    0.0146
##     40        0.9394            -nan     0.1000    0.0093
##     60        0.8323            -nan     0.1000    0.0060
##     80        0.7531            -nan     0.1000    0.0065
##    100        0.6885            -nan     0.1000    0.0032
##    120        0.6340            -nan     0.1000    0.0036
##    140        0.5907            -nan     0.1000    0.0028
##    150        0.5711            -nan     0.1000    0.0022
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1881
##      2        1.4896            -nan     0.1000    0.1242
##      3        1.4080            -nan     0.1000    0.1092
##      4        1.3391            -nan     0.1000    0.0841
##      5        1.2836            -nan     0.1000    0.0683
##      6        1.2409            -nan     0.1000    0.0670
##      7        1.1986            -nan     0.1000    0.0576
##      8        1.1630            -nan     0.1000    0.0525
##      9        1.1305            -nan     0.1000    0.0511
##     10        1.0986            -nan     0.1000    0.0435
##     20        0.8999            -nan     0.1000    0.0268
##     40        0.6838            -nan     0.1000    0.0107
##     60        0.5563            -nan     0.1000    0.0088
##     80        0.4671            -nan     0.1000    0.0049
##    100        0.4021            -nan     0.1000    0.0036
##    120        0.3482            -nan     0.1000    0.0030
##    140        0.3062            -nan     0.1000    0.0021
##    150        0.2860            -nan     0.1000    0.0022
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2235
##      2        1.4660            -nan     0.1000    0.1576
##      3        1.3651            -nan     0.1000    0.1324
##      4        1.2816            -nan     0.1000    0.1101
##      5        1.2133            -nan     0.1000    0.0830
##      6        1.1605            -nan     0.1000    0.0790
##      7        1.1108            -nan     0.1000    0.0714
##      8        1.0652            -nan     0.1000    0.0543
##      9        1.0306            -nan     0.1000    0.0632
##     10        0.9921            -nan     0.1000    0.0554
##     20        0.7619            -nan     0.1000    0.0266
##     40        0.5316            -nan     0.1000    0.0133
##     60        0.4043            -nan     0.1000    0.0088
##     80        0.3227            -nan     0.1000    0.0049
##    100        0.2640            -nan     0.1000    0.0031
##    120        0.2183            -nan     0.1000    0.0029
##    140        0.1844            -nan     0.1000    0.0017
##    150        0.1708            -nan     0.1000    0.0011
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1279
##      2        1.5243            -nan     0.1000    0.0885
##      3        1.4652            -nan     0.1000    0.0687
##      4        1.4212            -nan     0.1000    0.0536
##      5        1.3863            -nan     0.1000    0.0497
##      6        1.3535            -nan     0.1000    0.0445
##      7        1.3258            -nan     0.1000    0.0399
##      8        1.3011            -nan     0.1000    0.0372
##      9        1.2769            -nan     0.1000    0.0312
##     10        1.2565            -nan     0.1000    0.0286
##     20        1.0967            -nan     0.1000    0.0164
##     40        0.9245            -nan     0.1000    0.0078
##     60        0.8151            -nan     0.1000    0.0068
##     80        0.7341            -nan     0.1000    0.0049
##    100        0.6696            -nan     0.1000    0.0035
##    120        0.6181            -nan     0.1000    0.0029
##    140        0.5747            -nan     0.1000    0.0016
##    150        0.5549            -nan     0.1000    0.0029
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1874
##      2        1.4876            -nan     0.1000    0.1300
##      3        1.4031            -nan     0.1000    0.1166
##      4        1.3305            -nan     0.1000    0.0904
##      5        1.2742            -nan     0.1000    0.0736
##      6        1.2281            -nan     0.1000    0.0630
##      7        1.1879            -nan     0.1000    0.0607
##      8        1.1502            -nan     0.1000    0.0546
##      9        1.1163            -nan     0.1000    0.0449
##     10        1.0882            -nan     0.1000    0.0462
##     20        0.8799            -nan     0.1000    0.0273
##     40        0.6665            -nan     0.1000    0.0110
##     60        0.5447            -nan     0.1000    0.0111
##     80        0.4550            -nan     0.1000    0.0066
##    100        0.3881            -nan     0.1000    0.0033
##    120        0.3385            -nan     0.1000    0.0019
##    140        0.2958            -nan     0.1000    0.0020
##    150        0.2779            -nan     0.1000    0.0022
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2357
##      2        1.4598            -nan     0.1000    0.1728
##      3        1.3525            -nan     0.1000    0.1348
##      4        1.2694            -nan     0.1000    0.1017
##      5        1.2055            -nan     0.1000    0.0965
##      6        1.1472            -nan     0.1000    0.0712
##      7        1.1012            -nan     0.1000    0.0698
##      8        1.0581            -nan     0.1000    0.0676
##      9        1.0159            -nan     0.1000    0.0619
##     10        0.9769            -nan     0.1000    0.0473
##     20        0.7485            -nan     0.1000    0.0345
##     40        0.5145            -nan     0.1000    0.0132
##     60        0.3914            -nan     0.1000    0.0057
##     80        0.3127            -nan     0.1000    0.0047
##    100        0.2565            -nan     0.1000    0.0039
##    120        0.2132            -nan     0.1000    0.0023
##    140        0.1789            -nan     0.1000    0.0024
##    150        0.1653            -nan     0.1000    0.0008
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1295
##      2        1.5231            -nan     0.1000    0.0904
##      3        1.4630            -nan     0.1000    0.0657
##      4        1.4189            -nan     0.1000    0.0517
##      5        1.3839            -nan     0.1000    0.0515
##      6        1.3515            -nan     0.1000    0.0425
##      7        1.3241            -nan     0.1000    0.0384
##      8        1.3001            -nan     0.1000    0.0372
##      9        1.2768            -nan     0.1000    0.0347
##     10        1.2537            -nan     0.1000    0.0303
##     20        1.0986            -nan     0.1000    0.0174
##     40        0.9278            -nan     0.1000    0.0082
##     60        0.8196            -nan     0.1000    0.0075
##     80        0.7391            -nan     0.1000    0.0054
##    100        0.6740            -nan     0.1000    0.0029
##    120        0.6240            -nan     0.1000    0.0023
##    140        0.5818            -nan     0.1000    0.0030
##    150        0.5630            -nan     0.1000    0.0029
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1931
##      2        1.4863            -nan     0.1000    0.1271
##      3        1.4033            -nan     0.1000    0.1029
##      4        1.3370            -nan     0.1000    0.0868
##      5        1.2824            -nan     0.1000    0.0716
##      6        1.2362            -nan     0.1000    0.0733
##      7        1.1897            -nan     0.1000    0.0587
##      8        1.1523            -nan     0.1000    0.0515
##      9        1.1198            -nan     0.1000    0.0553
##     10        1.0862            -nan     0.1000    0.0426
##     20        0.8862            -nan     0.1000    0.0241
##     40        0.6701            -nan     0.1000    0.0099
##     60        0.5481            -nan     0.1000    0.0070
##     80        0.4547            -nan     0.1000    0.0044
##    100        0.3920            -nan     0.1000    0.0044
##    120        0.3400            -nan     0.1000    0.0028
##    140        0.3005            -nan     0.1000    0.0025
##    150        0.2839            -nan     0.1000    0.0019
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2307
##      2        1.4608            -nan     0.1000    0.1615
##      3        1.3591            -nan     0.1000    0.1297
##      4        1.2775            -nan     0.1000    0.1065
##      5        1.2103            -nan     0.1000    0.0935
##      6        1.1515            -nan     0.1000    0.0839
##      7        1.0999            -nan     0.1000    0.0649
##      8        1.0590            -nan     0.1000    0.0613
##      9        1.0201            -nan     0.1000    0.0642
##     10        0.9805            -nan     0.1000    0.0544
##     20        0.7503            -nan     0.1000    0.0229
##     40        0.5250            -nan     0.1000    0.0113
##     60        0.4013            -nan     0.1000    0.0060
##     80        0.3174            -nan     0.1000    0.0042
##    100        0.2593            -nan     0.1000    0.0021
##    120        0.2156            -nan     0.1000    0.0024
##    140        0.1823            -nan     0.1000    0.0021
##    150        0.1691            -nan     0.1000    0.0016
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1301
##      2        1.5226            -nan     0.1000    0.0873
##      3        1.4638            -nan     0.1000    0.0676
##      4        1.4195            -nan     0.1000    0.0524
##      5        1.3836            -nan     0.1000    0.0456
##      6        1.3538            -nan     0.1000    0.0461
##      7        1.3252            -nan     0.1000    0.0400
##      8        1.3001            -nan     0.1000    0.0352
##      9        1.2775            -nan     0.1000    0.0352
##     10        1.2544            -nan     0.1000    0.0254
##     20        1.0997            -nan     0.1000    0.0172
##     40        0.9292            -nan     0.1000    0.0126
##     60        0.8220            -nan     0.1000    0.0060
##     80        0.7430            -nan     0.1000    0.0059
##    100        0.6804            -nan     0.1000    0.0032
##    120        0.6307            -nan     0.1000    0.0042
##    140        0.5859            -nan     0.1000    0.0023
##    150        0.5651            -nan     0.1000    0.0030
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1912
##      2        1.4867            -nan     0.1000    0.1289
##      3        1.4027            -nan     0.1000    0.1036
##      4        1.3368            -nan     0.1000    0.0864
##      5        1.2816            -nan     0.1000    0.0754
##      6        1.2338            -nan     0.1000    0.0614
##      7        1.1932            -nan     0.1000    0.0627
##      8        1.1532            -nan     0.1000    0.0487
##      9        1.1228            -nan     0.1000    0.0443
##     10        1.0935            -nan     0.1000    0.0462
##     20        0.8850            -nan     0.1000    0.0206
##     40        0.6736            -nan     0.1000    0.0111
##     60        0.5458            -nan     0.1000    0.0073
##     80        0.4571            -nan     0.1000    0.0065
##    100        0.3910            -nan     0.1000    0.0054
##    120        0.3399            -nan     0.1000    0.0031
##    140        0.2984            -nan     0.1000    0.0033
##    150        0.2794            -nan     0.1000    0.0018
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2362
##      2        1.4584            -nan     0.1000    0.1651
##      3        1.3541            -nan     0.1000    0.1238
##      4        1.2763            -nan     0.1000    0.1128
##      5        1.2067            -nan     0.1000    0.0836
##      6        1.1546            -nan     0.1000    0.0849
##      7        1.1024            -nan     0.1000    0.0613
##      8        1.0636            -nan     0.1000    0.0639
##      9        1.0242            -nan     0.1000    0.0527
##     10        0.9908            -nan     0.1000    0.0615
##     20        0.7501            -nan     0.1000    0.0244
##     40        0.5239            -nan     0.1000    0.0153
##     60        0.3993            -nan     0.1000    0.0082
##     80        0.3175            -nan     0.1000    0.0046
##    100        0.2625            -nan     0.1000    0.0029
##    120        0.2195            -nan     0.1000    0.0025
##    140        0.1847            -nan     0.1000    0.0013
##    150        0.1713            -nan     0.1000    0.0021
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1286
##      2        1.5252            -nan     0.1000    0.0853
##      3        1.4676            -nan     0.1000    0.0665
##      4        1.4244            -nan     0.1000    0.0539
##      5        1.3885            -nan     0.1000    0.0436
##      6        1.3597            -nan     0.1000    0.0450
##      7        1.3313            -nan     0.1000    0.0426
##      8        1.3048            -nan     0.1000    0.0331
##      9        1.2831            -nan     0.1000    0.0307
##     10        1.2630            -nan     0.1000    0.0308
##     20        1.1076            -nan     0.1000    0.0187
##     40        0.9340            -nan     0.1000    0.0086
##     60        0.8245            -nan     0.1000    0.0069
##     80        0.7444            -nan     0.1000    0.0056
##    100        0.6800            -nan     0.1000    0.0048
##    120        0.6277            -nan     0.1000    0.0033
##    140        0.5830            -nan     0.1000    0.0020
##    150        0.5633            -nan     0.1000    0.0022
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1914
##      2        1.4886            -nan     0.1000    0.1228
##      3        1.4081            -nan     0.1000    0.1107
##      4        1.3396            -nan     0.1000    0.0875
##      5        1.2847            -nan     0.1000    0.0756
##      6        1.2370            -nan     0.1000    0.0655
##      7        1.1957            -nan     0.1000    0.0647
##      8        1.1562            -nan     0.1000    0.0446
##      9        1.1277            -nan     0.1000    0.0469
##     10        1.0975            -nan     0.1000    0.0416
##     20        0.8993            -nan     0.1000    0.0294
##     40        0.6830            -nan     0.1000    0.0128
##     60        0.5536            -nan     0.1000    0.0069
##     80        0.4617            -nan     0.1000    0.0051
##    100        0.3967            -nan     0.1000    0.0049
##    120        0.3460            -nan     0.1000    0.0030
##    140        0.3049            -nan     0.1000    0.0032
##    150        0.2857            -nan     0.1000    0.0009
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2307
##      2        1.4619            -nan     0.1000    0.1631
##      3        1.3604            -nan     0.1000    0.1230
##      4        1.2829            -nan     0.1000    0.1129
##      5        1.2117            -nan     0.1000    0.0838
##      6        1.1583            -nan     0.1000    0.0746
##      7        1.1097            -nan     0.1000    0.0697
##      8        1.0656            -nan     0.1000    0.0613
##      9        1.0270            -nan     0.1000    0.0502
##     10        0.9952            -nan     0.1000    0.0532
##     20        0.7524            -nan     0.1000    0.0236
##     40        0.5305            -nan     0.1000    0.0121
##     60        0.4061            -nan     0.1000    0.0081
##     80        0.3188            -nan     0.1000    0.0044
##    100        0.2637            -nan     0.1000    0.0034
##    120        0.2201            -nan     0.1000    0.0030
##    140        0.1858            -nan     0.1000    0.0018
##    150        0.1723            -nan     0.1000    0.0016
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1230
##      2        1.5259            -nan     0.1000    0.0846
##      3        1.4699            -nan     0.1000    0.0650
##      4        1.4265            -nan     0.1000    0.0527
##      5        1.3914            -nan     0.1000    0.0503
##      6        1.3591            -nan     0.1000    0.0414
##      7        1.3319            -nan     0.1000    0.0368
##      8        1.3087            -nan     0.1000    0.0385
##      9        1.2853            -nan     0.1000    0.0325
##     10        1.2641            -nan     0.1000    0.0295
##     20        1.1128            -nan     0.1000    0.0164
##     40        0.9399            -nan     0.1000    0.0071
##     60        0.8297            -nan     0.1000    0.0056
##     80        0.7501            -nan     0.1000    0.0074
##    100        0.6847            -nan     0.1000    0.0048
##    120        0.6320            -nan     0.1000    0.0044
##    140        0.5874            -nan     0.1000    0.0025
##    150        0.5678            -nan     0.1000    0.0028
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1838
##      2        1.4903            -nan     0.1000    0.1238
##      3        1.4102            -nan     0.1000    0.1009
##      4        1.3438            -nan     0.1000    0.0910
##      5        1.2868            -nan     0.1000    0.0781
##      6        1.2374            -nan     0.1000    0.0705
##      7        1.1934            -nan     0.1000    0.0530
##      8        1.1593            -nan     0.1000    0.0477
##      9        1.1286            -nan     0.1000    0.0462
##     10        1.0996            -nan     0.1000    0.0468
##     20        0.8964            -nan     0.1000    0.0221
##     40        0.6831            -nan     0.1000    0.0140
##     60        0.5517            -nan     0.1000    0.0072
##     80        0.4658            -nan     0.1000    0.0064
##    100        0.3964            -nan     0.1000    0.0022
##    120        0.3443            -nan     0.1000    0.0038
##    140        0.3025            -nan     0.1000    0.0024
##    150        0.2850            -nan     0.1000    0.0028
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2320
##      2        1.4625            -nan     0.1000    0.1583
##      3        1.3629            -nan     0.1000    0.1183
##      4        1.2878            -nan     0.1000    0.1143
##      5        1.2175            -nan     0.1000    0.0888
##      6        1.1631            -nan     0.1000    0.0762
##      7        1.1147            -nan     0.1000    0.0701
##      8        1.0700            -nan     0.1000    0.0746
##      9        1.0247            -nan     0.1000    0.0519
##     10        0.9913            -nan     0.1000    0.0566
##     20        0.7567            -nan     0.1000    0.0282
##     40        0.5223            -nan     0.1000    0.0105
##     60        0.4015            -nan     0.1000    0.0105
##     80        0.3169            -nan     0.1000    0.0042
##    100        0.2615            -nan     0.1000    0.0022
##    120        0.2169            -nan     0.1000    0.0025
##    140        0.1824            -nan     0.1000    0.0019
##    150        0.1688            -nan     0.1000    0.0019
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1273
##      2        1.5244            -nan     0.1000    0.0863
##      3        1.4663            -nan     0.1000    0.0645
##      4        1.4232            -nan     0.1000    0.0498
##      5        1.3894            -nan     0.1000    0.0532
##      6        1.3563            -nan     0.1000    0.0392
##      7        1.3303            -nan     0.1000    0.0378
##      8        1.3062            -nan     0.1000    0.0347
##      9        1.2838            -nan     0.1000    0.0336
##     10        1.2610            -nan     0.1000    0.0307
##     20        1.1058            -nan     0.1000    0.0173
##     40        0.9351            -nan     0.1000    0.0095
##     60        0.8259            -nan     0.1000    0.0063
##     80        0.7493            -nan     0.1000    0.0047
##    100        0.6841            -nan     0.1000    0.0037
##    120        0.6322            -nan     0.1000    0.0028
##    140        0.5875            -nan     0.1000    0.0029
##    150        0.5669            -nan     0.1000    0.0023
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1862
##      2        1.4895            -nan     0.1000    0.1287
##      3        1.4071            -nan     0.1000    0.0983
##      4        1.3443            -nan     0.1000    0.0863
##      5        1.2891            -nan     0.1000    0.0765
##      6        1.2405            -nan     0.1000    0.0611
##      7        1.2014            -nan     0.1000    0.0614
##      8        1.1633            -nan     0.1000    0.0582
##      9        1.1275            -nan     0.1000    0.0393
##     10        1.1014            -nan     0.1000    0.0429
##     20        0.8996            -nan     0.1000    0.0267
##     40        0.6818            -nan     0.1000    0.0144
##     60        0.5541            -nan     0.1000    0.0108
##     80        0.4639            -nan     0.1000    0.0077
##    100        0.3958            -nan     0.1000    0.0042
##    120        0.3436            -nan     0.1000    0.0022
##    140        0.3027            -nan     0.1000    0.0017
##    150        0.2841            -nan     0.1000    0.0011
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2293
##      2        1.4649            -nan     0.1000    0.1650
##      3        1.3619            -nan     0.1000    0.1206
##      4        1.2850            -nan     0.1000    0.1087
##      5        1.2170            -nan     0.1000    0.0938
##      6        1.1587            -nan     0.1000    0.0851
##      7        1.1053            -nan     0.1000    0.0667
##      8        1.0643            -nan     0.1000    0.0628
##      9        1.0254            -nan     0.1000    0.0544
##     10        0.9917            -nan     0.1000    0.0598
##     20        0.7557            -nan     0.1000    0.0321
##     40        0.5237            -nan     0.1000    0.0140
##     60        0.3992            -nan     0.1000    0.0060
##     80        0.3218            -nan     0.1000    0.0041
##    100        0.2624            -nan     0.1000    0.0032
##    120        0.2227            -nan     0.1000    0.0020
##    140        0.1889            -nan     0.1000    0.0014
##    150        0.1742            -nan     0.1000    0.0007
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1277
##      2        1.5233            -nan     0.1000    0.0861
##      3        1.4659            -nan     0.1000    0.0672
##      4        1.4215            -nan     0.1000    0.0536
##      5        1.3852            -nan     0.1000    0.0453
##      6        1.3563            -nan     0.1000    0.0453
##      7        1.3275            -nan     0.1000    0.0406
##      8        1.3018            -nan     0.1000    0.0351
##      9        1.2786            -nan     0.1000    0.0327
##     10        1.2571            -nan     0.1000    0.0308
##     20        1.1045            -nan     0.1000    0.0220
##     40        0.9289            -nan     0.1000    0.0084
##     60        0.8222            -nan     0.1000    0.0065
##     80        0.7419            -nan     0.1000    0.0046
##    100        0.6789            -nan     0.1000    0.0026
##    120        0.6265            -nan     0.1000    0.0033
##    140        0.5841            -nan     0.1000    0.0038
##    150        0.5647            -nan     0.1000    0.0020
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1863
##      2        1.4895            -nan     0.1000    0.1247
##      3        1.4071            -nan     0.1000    0.1096
##      4        1.3381            -nan     0.1000    0.0793
##      5        1.2860            -nan     0.1000    0.0685
##      6        1.2417            -nan     0.1000    0.0659
##      7        1.1994            -nan     0.1000    0.0614
##      8        1.1616            -nan     0.1000    0.0476
##      9        1.1301            -nan     0.1000    0.0457
##     10        1.1016            -nan     0.1000    0.0486
##     20        0.8904            -nan     0.1000    0.0216
##     40        0.6779            -nan     0.1000    0.0115
##     60        0.5502            -nan     0.1000    0.0080
##     80        0.4619            -nan     0.1000    0.0058
##    100        0.3940            -nan     0.1000    0.0037
##    120        0.3435            -nan     0.1000    0.0019
##    140        0.3008            -nan     0.1000    0.0028
##    150        0.2831            -nan     0.1000    0.0022
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2375
##      2        1.4582            -nan     0.1000    0.1595
##      3        1.3572            -nan     0.1000    0.1326
##      4        1.2743            -nan     0.1000    0.1005
##      5        1.2121            -nan     0.1000    0.0884
##      6        1.1568            -nan     0.1000    0.0782
##      7        1.1077            -nan     0.1000    0.0811
##      8        1.0588            -nan     0.1000    0.0555
##      9        1.0221            -nan     0.1000    0.0596
##     10        0.9856            -nan     0.1000    0.0490
##     20        0.7516            -nan     0.1000    0.0264
##     40        0.5272            -nan     0.1000    0.0103
##     60        0.4038            -nan     0.1000    0.0087
##     80        0.3183            -nan     0.1000    0.0040
##    100        0.2616            -nan     0.1000    0.0033
##    120        0.2176            -nan     0.1000    0.0035
##    140        0.1804            -nan     0.1000    0.0023
##    150        0.1672            -nan     0.1000    0.0013
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1307
##      2        1.5220            -nan     0.1000    0.0871
##      3        1.4643            -nan     0.1000    0.0684
##      4        1.4187            -nan     0.1000    0.0565
##      5        1.3825            -nan     0.1000    0.0520
##      6        1.3490            -nan     0.1000    0.0402
##      7        1.3231            -nan     0.1000    0.0420
##      8        1.2971            -nan     0.1000    0.0387
##      9        1.2736            -nan     0.1000    0.0329
##     10        1.2524            -nan     0.1000    0.0289
##     20        1.0967            -nan     0.1000    0.0198
##     40        0.9242            -nan     0.1000    0.0112
##     60        0.8166            -nan     0.1000    0.0073
##     80        0.7345            -nan     0.1000    0.0044
##    100        0.6717            -nan     0.1000    0.0045
##    120        0.6189            -nan     0.1000    0.0026
##    140        0.5760            -nan     0.1000    0.0026
##    150        0.5569            -nan     0.1000    0.0026
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1916
##      2        1.4864            -nan     0.1000    0.1338
##      3        1.4004            -nan     0.1000    0.1081
##      4        1.3325            -nan     0.1000    0.0867
##      5        1.2767            -nan     0.1000    0.0796
##      6        1.2266            -nan     0.1000    0.0693
##      7        1.1841            -nan     0.1000    0.0676
##      8        1.1431            -nan     0.1000    0.0482
##      9        1.1112            -nan     0.1000    0.0473
##     10        1.0811            -nan     0.1000    0.0418
##     20        0.8775            -nan     0.1000    0.0206
##     40        0.6646            -nan     0.1000    0.0133
##     60        0.5368            -nan     0.1000    0.0059
##     80        0.4481            -nan     0.1000    0.0080
##    100        0.3829            -nan     0.1000    0.0032
##    120        0.3332            -nan     0.1000    0.0032
##    140        0.2953            -nan     0.1000    0.0022
##    150        0.2776            -nan     0.1000    0.0021
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2452
##      2        1.4562            -nan     0.1000    0.1604
##      3        1.3537            -nan     0.1000    0.1232
##      4        1.2750            -nan     0.1000    0.1181
##      5        1.2014            -nan     0.1000    0.0880
##      6        1.1453            -nan     0.1000    0.0820
##      7        1.0943            -nan     0.1000    0.0639
##      8        1.0540            -nan     0.1000    0.0667
##      9        1.0131            -nan     0.1000    0.0579
##     10        0.9760            -nan     0.1000    0.0584
##     20        0.7406            -nan     0.1000    0.0214
##     40        0.5163            -nan     0.1000    0.0118
##     60        0.3898            -nan     0.1000    0.0078
##     80        0.3127            -nan     0.1000    0.0039
##    100        0.2541            -nan     0.1000    0.0046
##    120        0.2128            -nan     0.1000    0.0020
##    140        0.1805            -nan     0.1000    0.0023
##    150        0.1670            -nan     0.1000    0.0013
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1272
##      2        1.5246            -nan     0.1000    0.0896
##      3        1.4663            -nan     0.1000    0.0687
##      4        1.4226            -nan     0.1000    0.0523
##      5        1.3878            -nan     0.1000    0.0527
##      6        1.3550            -nan     0.1000    0.0451
##      7        1.3267            -nan     0.1000    0.0346
##      8        1.3048            -nan     0.1000    0.0347
##      9        1.2827            -nan     0.1000    0.0343
##     10        1.2594            -nan     0.1000    0.0292
##     20        1.1066            -nan     0.1000    0.0195
##     40        0.9338            -nan     0.1000    0.0097
##     60        0.8251            -nan     0.1000    0.0063
##     80        0.7453            -nan     0.1000    0.0066
##    100        0.6823            -nan     0.1000    0.0036
##    120        0.6305            -nan     0.1000    0.0026
##    140        0.5878            -nan     0.1000    0.0044
##    150        0.5688            -nan     0.1000    0.0017
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1867
##      2        1.4868            -nan     0.1000    0.1290
##      3        1.4034            -nan     0.1000    0.1022
##      4        1.3374            -nan     0.1000    0.0922
##      5        1.2799            -nan     0.1000    0.0696
##      6        1.2362            -nan     0.1000    0.0664
##      7        1.1945            -nan     0.1000    0.0522
##      8        1.1609            -nan     0.1000    0.0551
##      9        1.1263            -nan     0.1000    0.0452
##     10        1.0978            -nan     0.1000    0.0402
##     20        0.8972            -nan     0.1000    0.0207
##     40        0.6820            -nan     0.1000    0.0121
##     60        0.5554            -nan     0.1000    0.0077
##     80        0.4688            -nan     0.1000    0.0054
##    100        0.4002            -nan     0.1000    0.0031
##    120        0.3479            -nan     0.1000    0.0039
##    140        0.3060            -nan     0.1000    0.0021
##    150        0.2874            -nan     0.1000    0.0015
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2396
##      2        1.4596            -nan     0.1000    0.1682
##      3        1.3538            -nan     0.1000    0.1309
##      4        1.2722            -nan     0.1000    0.1051
##      5        1.2063            -nan     0.1000    0.0873
##      6        1.1515            -nan     0.1000    0.0735
##      7        1.1049            -nan     0.1000    0.0653
##      8        1.0643            -nan     0.1000    0.0741
##      9        1.0199            -nan     0.1000    0.0496
##     10        0.9880            -nan     0.1000    0.0609
##     20        0.7546            -nan     0.1000    0.0235
##     40        0.5322            -nan     0.1000    0.0126
##     60        0.4038            -nan     0.1000    0.0066
##     80        0.3225            -nan     0.1000    0.0045
##    100        0.2644            -nan     0.1000    0.0045
##    120        0.2201            -nan     0.1000    0.0017
##    140        0.1850            -nan     0.1000    0.0015
##    150        0.1713            -nan     0.1000    0.0019
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1309
##      2        1.5240            -nan     0.1000    0.0846
##      3        1.4664            -nan     0.1000    0.0681
##      4        1.4218            -nan     0.1000    0.0527
##      5        1.3871            -nan     0.1000    0.0502
##      6        1.3548            -nan     0.1000    0.0398
##      7        1.3286            -nan     0.1000    0.0393
##      8        1.3030            -nan     0.1000    0.0332
##      9        1.2807            -nan     0.1000    0.0338
##     10        1.2595            -nan     0.1000    0.0329
##     20        1.1057            -nan     0.1000    0.0159
##     40        0.9305            -nan     0.1000    0.0077
##     60        0.8238            -nan     0.1000    0.0067
##     80        0.7423            -nan     0.1000    0.0041
##    100        0.6788            -nan     0.1000    0.0039
##    120        0.6260            -nan     0.1000    0.0034
##    140        0.5825            -nan     0.1000    0.0023
##    150        0.5631            -nan     0.1000    0.0019
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1851
##      2        1.4893            -nan     0.1000    0.1254
##      3        1.4086            -nan     0.1000    0.1028
##      4        1.3427            -nan     0.1000    0.0820
##      5        1.2904            -nan     0.1000    0.0683
##      6        1.2462            -nan     0.1000    0.0728
##      7        1.2005            -nan     0.1000    0.0574
##      8        1.1634            -nan     0.1000    0.0578
##      9        1.1274            -nan     0.1000    0.0453
##     10        1.0991            -nan     0.1000    0.0418
##     20        0.8926            -nan     0.1000    0.0214
##     40        0.6831            -nan     0.1000    0.0121
##     60        0.5556            -nan     0.1000    0.0067
##     80        0.4650            -nan     0.1000    0.0073
##    100        0.3979            -nan     0.1000    0.0046
##    120        0.3467            -nan     0.1000    0.0018
##    140        0.3064            -nan     0.1000    0.0030
##    150        0.2870            -nan     0.1000    0.0017
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2268
##      2        1.4636            -nan     0.1000    0.1564
##      3        1.3646            -nan     0.1000    0.1248
##      4        1.2865            -nan     0.1000    0.1102
##      5        1.2171            -nan     0.1000    0.0893
##      6        1.1606            -nan     0.1000    0.0762
##      7        1.1125            -nan     0.1000    0.0687
##      8        1.0690            -nan     0.1000    0.0732
##      9        1.0251            -nan     0.1000    0.0532
##     10        0.9924            -nan     0.1000    0.0551
##     20        0.7572            -nan     0.1000    0.0234
##     40        0.5281            -nan     0.1000    0.0120
##     60        0.4056            -nan     0.1000    0.0079
##     80        0.3198            -nan     0.1000    0.0043
##    100        0.2615            -nan     0.1000    0.0033
##    120        0.2178            -nan     0.1000    0.0034
##    140        0.1852            -nan     0.1000    0.0008
##    150        0.1711            -nan     0.1000    0.0012
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1210
##      2        1.5272            -nan     0.1000    0.0874
##      3        1.4697            -nan     0.1000    0.0643
##      4        1.4267            -nan     0.1000    0.0537
##      5        1.3922            -nan     0.1000    0.0526
##      6        1.3588            -nan     0.1000    0.0398
##      7        1.3332            -nan     0.1000    0.0363
##      8        1.3097            -nan     0.1000    0.0393
##      9        1.2858            -nan     0.1000    0.0302
##     10        1.2657            -nan     0.1000    0.0311
##     20        1.1091            -nan     0.1000    0.0176
##     40        0.9379            -nan     0.1000    0.0081
##     60        0.8299            -nan     0.1000    0.0048
##     80        0.7489            -nan     0.1000    0.0043
##    100        0.6867            -nan     0.1000    0.0051
##    120        0.6330            -nan     0.1000    0.0037
##    140        0.5877            -nan     0.1000    0.0026
##    150        0.5684            -nan     0.1000    0.0026
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1839
##      2        1.4909            -nan     0.1000    0.1283
##      3        1.4082            -nan     0.1000    0.1020
##      4        1.3421            -nan     0.1000    0.0817
##      5        1.2896            -nan     0.1000    0.0802
##      6        1.2391            -nan     0.1000    0.0598
##      7        1.2006            -nan     0.1000    0.0654
##      8        1.1602            -nan     0.1000    0.0494
##      9        1.1290            -nan     0.1000    0.0520
##     10        1.0974            -nan     0.1000    0.0415
##     20        0.8961            -nan     0.1000    0.0193
##     40        0.6808            -nan     0.1000    0.0140
##     60        0.5510            -nan     0.1000    0.0089
##     80        0.4626            -nan     0.1000    0.0090
##    100        0.3932            -nan     0.1000    0.0030
##    120        0.3434            -nan     0.1000    0.0035
##    140        0.2992            -nan     0.1000    0.0040
##    150        0.2810            -nan     0.1000    0.0017
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2341
##      2        1.4621            -nan     0.1000    0.1575
##      3        1.3612            -nan     0.1000    0.1282
##      4        1.2812            -nan     0.1000    0.1048
##      5        1.2150            -nan     0.1000    0.0944
##      6        1.1569            -nan     0.1000    0.0865
##      7        1.1020            -nan     0.1000    0.0636
##      8        1.0609            -nan     0.1000    0.0721
##      9        1.0173            -nan     0.1000    0.0551
##     10        0.9811            -nan     0.1000    0.0571
##     20        0.7482            -nan     0.1000    0.0274
##     40        0.5246            -nan     0.1000    0.0105
##     60        0.4022            -nan     0.1000    0.0114
##     80        0.3184            -nan     0.1000    0.0034
##    100        0.2594            -nan     0.1000    0.0027
##    120        0.2149            -nan     0.1000    0.0027
##    140        0.1822            -nan     0.1000    0.0020
##    150        0.1685            -nan     0.1000    0.0016
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1280
##      2        1.5231            -nan     0.1000    0.0887
##      3        1.4651            -nan     0.1000    0.0670
##      4        1.4210            -nan     0.1000    0.0557
##      5        1.3851            -nan     0.1000    0.0491
##      6        1.3534            -nan     0.1000    0.0407
##      7        1.3274            -nan     0.1000    0.0395
##      8        1.3017            -nan     0.1000    0.0380
##      9        1.2783            -nan     0.1000    0.0334
##     10        1.2568            -nan     0.1000    0.0326
##     20        1.1049            -nan     0.1000    0.0184
##     40        0.9282            -nan     0.1000    0.0096
##     60        0.8232            -nan     0.1000    0.0064
##     80        0.7401            -nan     0.1000    0.0046
##    100        0.6797            -nan     0.1000    0.0041
##    120        0.6265            -nan     0.1000    0.0031
##    140        0.5821            -nan     0.1000    0.0023
##    150        0.5617            -nan     0.1000    0.0025
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1858
##      2        1.4895            -nan     0.1000    0.1304
##      3        1.4053            -nan     0.1000    0.1046
##      4        1.3388            -nan     0.1000    0.0853
##      5        1.2844            -nan     0.1000    0.0803
##      6        1.2345            -nan     0.1000    0.0708
##      7        1.1905            -nan     0.1000    0.0487
##      8        1.1587            -nan     0.1000    0.0559
##      9        1.1234            -nan     0.1000    0.0486
##     10        1.0926            -nan     0.1000    0.0463
##     20        0.8910            -nan     0.1000    0.0185
##     40        0.6750            -nan     0.1000    0.0123
##     60        0.5472            -nan     0.1000    0.0109
##     80        0.4559            -nan     0.1000    0.0054
##    100        0.3940            -nan     0.1000    0.0035
##    120        0.3390            -nan     0.1000    0.0031
##    140        0.2973            -nan     0.1000    0.0021
##    150        0.2813            -nan     0.1000    0.0015
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2356
##      2        1.4610            -nan     0.1000    0.1596
##      3        1.3605            -nan     0.1000    0.1300
##      4        1.2797            -nan     0.1000    0.1150
##      5        1.2089            -nan     0.1000    0.0943
##      6        1.1495            -nan     0.1000    0.0818
##      7        1.0991            -nan     0.1000    0.0642
##      8        1.0579            -nan     0.1000    0.0574
##      9        1.0202            -nan     0.1000    0.0631
##     10        0.9810            -nan     0.1000    0.0464
##     20        0.7479            -nan     0.1000    0.0242
##     40        0.5290            -nan     0.1000    0.0141
##     60        0.3949            -nan     0.1000    0.0053
##     80        0.3163            -nan     0.1000    0.0030
##    100        0.2592            -nan     0.1000    0.0028
##    120        0.2177            -nan     0.1000    0.0028
##    140        0.1847            -nan     0.1000    0.0013
##    150        0.1712            -nan     0.1000    0.0014
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1269
##      2        1.5245            -nan     0.1000    0.0874
##      3        1.4663            -nan     0.1000    0.0636
##      4        1.4236            -nan     0.1000    0.0543
##      5        1.3882            -nan     0.1000    0.0495
##      6        1.3559            -nan     0.1000    0.0476
##      7        1.3262            -nan     0.1000    0.0385
##      8        1.3015            -nan     0.1000    0.0356
##      9        1.2792            -nan     0.1000    0.0319
##     10        1.2592            -nan     0.1000    0.0332
##     20        1.0997            -nan     0.1000    0.0188
##     40        0.9281            -nan     0.1000    0.0105
##     60        0.8189            -nan     0.1000    0.0058
##     80        0.7436            -nan     0.1000    0.0046
##    100        0.6795            -nan     0.1000    0.0049
##    120        0.6277            -nan     0.1000    0.0032
##    140        0.5843            -nan     0.1000    0.0023
##    150        0.5654            -nan     0.1000    0.0020
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1866
##      2        1.4883            -nan     0.1000    0.1320
##      3        1.4037            -nan     0.1000    0.1120
##      4        1.3328            -nan     0.1000    0.0885
##      5        1.2765            -nan     0.1000    0.0706
##      6        1.2318            -nan     0.1000    0.0745
##      7        1.1861            -nan     0.1000    0.0647
##      8        1.1451            -nan     0.1000    0.0548
##      9        1.1107            -nan     0.1000    0.0433
##     10        1.0836            -nan     0.1000    0.0386
##     20        0.8862            -nan     0.1000    0.0187
##     40        0.6842            -nan     0.1000    0.0128
##     60        0.5535            -nan     0.1000    0.0058
##     80        0.4684            -nan     0.1000    0.0039
##    100        0.4020            -nan     0.1000    0.0044
##    120        0.3494            -nan     0.1000    0.0038
##    140        0.3037            -nan     0.1000    0.0017
##    150        0.2877            -nan     0.1000    0.0018
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2412
##      2        1.4574            -nan     0.1000    0.1705
##      3        1.3488            -nan     0.1000    0.1268
##      4        1.2678            -nan     0.1000    0.1043
##      5        1.2022            -nan     0.1000    0.0940
##      6        1.1426            -nan     0.1000    0.0768
##      7        1.0941            -nan     0.1000    0.0736
##      8        1.0473            -nan     0.1000    0.0628
##      9        1.0086            -nan     0.1000    0.0569
##     10        0.9721            -nan     0.1000    0.0453
##     20        0.7455            -nan     0.1000    0.0289
##     40        0.5234            -nan     0.1000    0.0101
##     60        0.4034            -nan     0.1000    0.0103
##     80        0.3195            -nan     0.1000    0.0058
##    100        0.2590            -nan     0.1000    0.0040
##    120        0.2164            -nan     0.1000    0.0021
##    140        0.1840            -nan     0.1000    0.0017
##    150        0.1711            -nan     0.1000    0.0019
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1280
##      2        1.5229            -nan     0.1000    0.0816
##      3        1.4664            -nan     0.1000    0.0677
##      4        1.4217            -nan     0.1000    0.0541
##      5        1.3854            -nan     0.1000    0.0429
##      6        1.3570            -nan     0.1000    0.0438
##      7        1.3282            -nan     0.1000    0.0398
##      8        1.3034            -nan     0.1000    0.0343
##      9        1.2810            -nan     0.1000    0.0376
##     10        1.2572            -nan     0.1000    0.0296
##     20        1.1022            -nan     0.1000    0.0187
##     40        0.9288            -nan     0.1000    0.0106
##     60        0.8186            -nan     0.1000    0.0057
##     80        0.7391            -nan     0.1000    0.0057
##    100        0.6749            -nan     0.1000    0.0044
##    120        0.6226            -nan     0.1000    0.0040
##    140        0.5796            -nan     0.1000    0.0022
##    150        0.5596            -nan     0.1000    0.0018
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1915
##      2        1.4857            -nan     0.1000    0.1304
##      3        1.4022            -nan     0.1000    0.0984
##      4        1.3373            -nan     0.1000    0.0908
##      5        1.2800            -nan     0.1000    0.0845
##      6        1.2280            -nan     0.1000    0.0646
##      7        1.1870            -nan     0.1000    0.0608
##      8        1.1491            -nan     0.1000    0.0549
##      9        1.1149            -nan     0.1000    0.0454
##     10        1.0864            -nan     0.1000    0.0475
##     20        0.8827            -nan     0.1000    0.0238
##     40        0.6673            -nan     0.1000    0.0125
##     60        0.5380            -nan     0.1000    0.0058
##     80        0.4530            -nan     0.1000    0.0052
##    100        0.3890            -nan     0.1000    0.0029
##    120        0.3409            -nan     0.1000    0.0031
##    140        0.2990            -nan     0.1000    0.0028
##    150        0.2813            -nan     0.1000    0.0021
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2356
##      2        1.4581            -nan     0.1000    0.1635
##      3        1.3537            -nan     0.1000    0.1344
##      4        1.2690            -nan     0.1000    0.1104
##      5        1.2000            -nan     0.1000    0.0884
##      6        1.1439            -nan     0.1000    0.0763
##      7        1.0960            -nan     0.1000    0.0665
##      8        1.0535            -nan     0.1000    0.0553
##      9        1.0187            -nan     0.1000    0.0586
##     10        0.9832            -nan     0.1000    0.0476
##     20        0.7476            -nan     0.1000    0.0274
##     40        0.5156            -nan     0.1000    0.0098
##     60        0.3940            -nan     0.1000    0.0035
##     80        0.3138            -nan     0.1000    0.0054
##    100        0.2545            -nan     0.1000    0.0030
##    120        0.2092            -nan     0.1000    0.0021
##    140        0.1780            -nan     0.1000    0.0014
##    150        0.1646            -nan     0.1000    0.0016
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1246
##      2        1.5242            -nan     0.1000    0.0887
##      3        1.4666            -nan     0.1000    0.0647
##      4        1.4226            -nan     0.1000    0.0534
##      5        1.3872            -nan     0.1000    0.0529
##      6        1.3544            -nan     0.1000    0.0447
##      7        1.3260            -nan     0.1000    0.0394
##      8        1.3017            -nan     0.1000    0.0327
##      9        1.2809            -nan     0.1000    0.0354
##     10        1.2573            -nan     0.1000    0.0327
##     20        1.1017            -nan     0.1000    0.0180
##     40        0.9298            -nan     0.1000    0.0089
##     60        0.8241            -nan     0.1000    0.0065
##     80        0.7421            -nan     0.1000    0.0040
##    100        0.6782            -nan     0.1000    0.0032
##    120        0.6265            -nan     0.1000    0.0033
##    140        0.5844            -nan     0.1000    0.0022
##    150        0.5652            -nan     0.1000    0.0017
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1837
##      2        1.4889            -nan     0.1000    0.1289
##      3        1.4049            -nan     0.1000    0.1008
##      4        1.3393            -nan     0.1000    0.0880
##      5        1.2828            -nan     0.1000    0.0698
##      6        1.2381            -nan     0.1000    0.0703
##      7        1.1946            -nan     0.1000    0.0569
##      8        1.1583            -nan     0.1000    0.0557
##      9        1.1239            -nan     0.1000    0.0504
##     10        1.0922            -nan     0.1000    0.0443
##     20        0.8855            -nan     0.1000    0.0206
##     40        0.6669            -nan     0.1000    0.0097
##     60        0.5453            -nan     0.1000    0.0061
##     80        0.4573            -nan     0.1000    0.0067
##    100        0.3934            -nan     0.1000    0.0043
##    120        0.3433            -nan     0.1000    0.0033
##    140        0.3011            -nan     0.1000    0.0030
##    150        0.2840            -nan     0.1000    0.0018
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2320
##      2        1.4598            -nan     0.1000    0.1636
##      3        1.3570            -nan     0.1000    0.1237
##      4        1.2779            -nan     0.1000    0.1111
##      5        1.2080            -nan     0.1000    0.0819
##      6        1.1557            -nan     0.1000    0.0806
##      7        1.1048            -nan     0.1000    0.0624
##      8        1.0647            -nan     0.1000    0.0676
##      9        1.0231            -nan     0.1000    0.0493
##     10        0.9922            -nan     0.1000    0.0510
##     20        0.7478            -nan     0.1000    0.0237
##     40        0.5189            -nan     0.1000    0.0139
##     60        0.3953            -nan     0.1000    0.0109
##     80        0.3132            -nan     0.1000    0.0037
##    100        0.2549            -nan     0.1000    0.0032
##    120        0.2130            -nan     0.1000    0.0023
##    140        0.1811            -nan     0.1000    0.0012
##    150        0.1681            -nan     0.1000    0.0013
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1356
##      2        1.5222            -nan     0.1000    0.0922
##      3        1.4629            -nan     0.1000    0.0681
##      4        1.4178            -nan     0.1000    0.0559
##      5        1.3813            -nan     0.1000    0.0462
##      6        1.3497            -nan     0.1000    0.0476
##      7        1.3201            -nan     0.1000    0.0352
##      8        1.2978            -nan     0.1000    0.0352
##      9        1.2757            -nan     0.1000    0.0310
##     10        1.2556            -nan     0.1000    0.0345
##     20        1.1008            -nan     0.1000    0.0177
##     40        0.9306            -nan     0.1000    0.0084
##     60        0.8235            -nan     0.1000    0.0078
##     80        0.7434            -nan     0.1000    0.0048
##    100        0.6813            -nan     0.1000    0.0041
##    120        0.6276            -nan     0.1000    0.0027
##    140        0.5852            -nan     0.1000    0.0026
##    150        0.5655            -nan     0.1000    0.0018
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1829
##      2        1.4897            -nan     0.1000    0.1312
##      3        1.4056            -nan     0.1000    0.1033
##      4        1.3401            -nan     0.1000    0.0789
##      5        1.2879            -nan     0.1000    0.0739
##      6        1.2408            -nan     0.1000    0.0742
##      7        1.1943            -nan     0.1000    0.0535
##      8        1.1604            -nan     0.1000    0.0464
##      9        1.1310            -nan     0.1000    0.0552
##     10        1.0976            -nan     0.1000    0.0365
##     20        0.8949            -nan     0.1000    0.0251
##     40        0.6802            -nan     0.1000    0.0118
##     60        0.5550            -nan     0.1000    0.0064
##     80        0.4653            -nan     0.1000    0.0067
##    100        0.4001            -nan     0.1000    0.0063
##    120        0.3468            -nan     0.1000    0.0039
##    140        0.3027            -nan     0.1000    0.0018
##    150        0.2856            -nan     0.1000    0.0022
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2353
##      2        1.4594            -nan     0.1000    0.1572
##      3        1.3589            -nan     0.1000    0.1258
##      4        1.2795            -nan     0.1000    0.1135
##      5        1.2093            -nan     0.1000    0.0836
##      6        1.1563            -nan     0.1000    0.0750
##      7        1.1083            -nan     0.1000    0.0657
##      8        1.0670            -nan     0.1000    0.0660
##      9        1.0266            -nan     0.1000    0.0504
##     10        0.9935            -nan     0.1000    0.0541
##     20        0.7640            -nan     0.1000    0.0258
##     40        0.5327            -nan     0.1000    0.0118
##     60        0.4041            -nan     0.1000    0.0061
##     80        0.3253            -nan     0.1000    0.0049
##    100        0.2628            -nan     0.1000    0.0051
##    120        0.2202            -nan     0.1000    0.0030
##    140        0.1859            -nan     0.1000    0.0026
##    150        0.1720            -nan     0.1000    0.0021
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1269
##      2        1.5227            -nan     0.1000    0.0852
##      3        1.4648            -nan     0.1000    0.0686
##      4        1.4195            -nan     0.1000    0.0511
##      5        1.3856            -nan     0.1000    0.0525
##      6        1.3513            -nan     0.1000    0.0458
##      7        1.3227            -nan     0.1000    0.0378
##      8        1.2982            -nan     0.1000    0.0363
##      9        1.2758            -nan     0.1000    0.0315
##     10        1.2555            -nan     0.1000    0.0332
##     20        1.0982            -nan     0.1000    0.0181
##     40        0.9248            -nan     0.1000    0.0099
##     60        0.8160            -nan     0.1000    0.0068
##     80        0.7356            -nan     0.1000    0.0044
##    100        0.6715            -nan     0.1000    0.0036
##    120        0.6202            -nan     0.1000    0.0027
##    140        0.5765            -nan     0.1000    0.0024
##    150        0.5573            -nan     0.1000    0.0015
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.1853
##      2        1.4878            -nan     0.1000    0.1256
##      3        1.4059            -nan     0.1000    0.1046
##      4        1.3391            -nan     0.1000    0.0799
##      5        1.2874            -nan     0.1000    0.0744
##      6        1.2400            -nan     0.1000    0.0731
##      7        1.1951            -nan     0.1000    0.0543
##      8        1.1606            -nan     0.1000    0.0575
##      9        1.1243            -nan     0.1000    0.0477
##     10        1.0948            -nan     0.1000    0.0492
##     20        0.8833            -nan     0.1000    0.0184
##     40        0.6652            -nan     0.1000    0.0126
##     60        0.5424            -nan     0.1000    0.0061
##     80        0.4587            -nan     0.1000    0.0051
##    100        0.3915            -nan     0.1000    0.0050
##    120        0.3416            -nan     0.1000    0.0026
##    140        0.3002            -nan     0.1000    0.0026
##    150        0.2814            -nan     0.1000    0.0021
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2336
##      2        1.4606            -nan     0.1000    0.1602
##      3        1.3586            -nan     0.1000    0.1240
##      4        1.2812            -nan     0.1000    0.1127
##      5        1.2125            -nan     0.1000    0.0806
##      6        1.1613            -nan     0.1000    0.0735
##      7        1.1153            -nan     0.1000    0.0710
##      8        1.0697            -nan     0.1000    0.0732
##      9        1.0252            -nan     0.1000    0.0629
##     10        0.9863            -nan     0.1000    0.0611
##     20        0.7467            -nan     0.1000    0.0212
##     40        0.5179            -nan     0.1000    0.0118
##     60        0.3998            -nan     0.1000    0.0083
##     80        0.3149            -nan     0.1000    0.0046
##    100        0.2598            -nan     0.1000    0.0037
##    120        0.2143            -nan     0.1000    0.0018
##    140        0.1817            -nan     0.1000    0.0021
##    150        0.1678            -nan     0.1000    0.0019
## 
## Iter   TrainDeviance   ValidDeviance   StepSize   Improve
##      1        1.6094            -nan     0.1000    0.2370
##      2        1.4600            -nan     0.1000    0.1660
##      3        1.3542            -nan     0.1000    0.1224
##      4        1.2757            -nan     0.1000    0.1034
##      5        1.2102            -nan     0.1000    0.0871
##      6        1.1544            -nan     0.1000    0.0756
##      7        1.1062            -nan     0.1000    0.0677
##      8        1.0644            -nan     0.1000    0.0607
##      9        1.0259            -nan     0.1000    0.0594
##     10        0.9890            -nan     0.1000    0.0457
##     20        0.7614            -nan     0.1000    0.0271
##     40        0.5316            -nan     0.1000    0.0109
##     60        0.4084            -nan     0.1000    0.0067
##     80        0.3237            -nan     0.1000    0.0046
##    100        0.2690            -nan     0.1000    0.0043
##    120        0.2263            -nan     0.1000    0.0030
##    140        0.1926            -nan     0.1000    0.0028
##    150        0.1777            -nan     0.1000    0.0011
```

```r
gbmModel$predictions <- predict(gbmModel$fit, newdata = testingData)
gbmModel$confusionMatrix <- confusionMatrix(gbmModel$predictions, testingData$classe)
```


```r
gbmModel$confusionMatrix
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1344   43    0    0    2
##          B   14  861   34    1    6
##          C    2   25  791   19    7
##          D    4    4   12  755    8
##          E    3    1    1    6  864
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9601          
##                  95% CI : (0.9541, 0.9654)
##     No Information Rate : 0.2844          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9494          
##  Mcnemar's Test P-Value : 0.0001801       
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9832   0.9218   0.9439   0.9667   0.9741
## Specificity            0.9869   0.9858   0.9866   0.9930   0.9972
## Pos Pred Value         0.9676   0.9400   0.9372   0.9642   0.9874
## Neg Pred Value         0.9933   0.9812   0.9881   0.9935   0.9942
## Prevalence             0.2844   0.1943   0.1743   0.1625   0.1845
## Detection Rate         0.2796   0.1791   0.1646   0.1571   0.1797
## Detection Prevalence   0.2890   0.1906   0.1756   0.1629   0.1820
## Balanced Accuracy      0.9850   0.9538   0.9653   0.9799   0.9856
```

## Training model with Random Forests


```r
require('doMC')
```

```
## Loading required package: doMC
## Loading required package: foreach
## Loading required package: iterators
```

```r
registerDoMC(cores = 2)
rfModel <- list()
rfModel$time <- system.time(rfModel$fit <- train( classe ~ ., data=trainingData, method="rf"))
```

```
## Loading required package: randomForest
## randomForest 4.6-10
## Type rfNews() to see new features/changes/bug fixes.
```

```r
rfModel$predictions <- predict(rfModel$fit, newdata = testingData)
rfModel$confusionMatrix <- confusionMatrix(rfModel$predictions, testingData$classe)
```


```r
rfModel$confusionMatrix
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1363   10    0    0    0
##          B    3  922    3    0    0
##          C    0    1  830    6    3
##          D    0    1    5  774    0
##          E    1    0    0    1  884
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9929          
##                  95% CI : (0.9901, 0.9951)
##     No Information Rate : 0.2844          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.9911          
##  Mcnemar's Test P-Value : NA              
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9971   0.9872   0.9905   0.9910   0.9966
## Specificity            0.9971   0.9985   0.9975   0.9985   0.9995
## Pos Pred Value         0.9927   0.9935   0.9881   0.9923   0.9977
## Neg Pred Value         0.9988   0.9969   0.9980   0.9983   0.9992
## Prevalence             0.2844   0.1943   0.1743   0.1625   0.1845
## Detection Rate         0.2835   0.1918   0.1727   0.1610   0.1839
## Detection Prevalence   0.2856   0.1931   0.1747   0.1623   0.1843
## Balanced Accuracy      0.9971   0.9928   0.9940   0.9948   0.9981
```


```r
knitr::kable(rfModel$confusionMatrix['table'])
```



---  ---  -----
A    A     1363
B    A        3
C    A        0
D    A        0
E    A        1
A    B       10
B    B      922
C    B        1
D    B        1
E    B        0
A    C        0
B    C        3
C    C      830
D    C        5
E    C        0
A    D        0
B    D        0
C    D        6
D    D      774
E    D        1
A    E        0
B    E        0
C    E        3
D    E        0
E    E      884
---  ---  -----


Response in 51.305, 0.105, 2218.065, 2089.39, 2.642.

## References

Velloso, E.; Bulling, A.; Gellersen, H.; Ugulino, W.; Fuks, H. Qualitative Activity Recognition of Weight Lifting Exercises. Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human '13) . Stuttgart, Germany: ACM SIGCHI, 2013.

Read more: http://groupware.les.inf.puc-rio.br/har#ixzz3H5QT8FYY
