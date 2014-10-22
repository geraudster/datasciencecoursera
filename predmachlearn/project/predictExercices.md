## Data loading


```r
library(reshape)
library(caret)
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```r
library(plyr)
```

```
## 
## Attaching package: 'plyr'
## 
## The following objects are masked from 'package:reshape':
## 
##     rename, round_any
```

```r
source('loadData.R')
trainingUrl <- 'https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv'
testingUrl <- 'https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv'
  
loadDataFile(trainingUrl, "data/pml-training.csv", unzip=FALSE)
loadDataFile(testingUrl, "data/pml-testing.csv", unzip=FALSE)

data <- read.csv("data/pml-training.csv")
data$timestamp <- paste0(data$raw_timestamp_part_1, data$raw_timestamp_part_2)
inTrain <- createDataPartition(y=data$classe, p=0.75, list=FALSE)

training <- data[inTrain,]
testing <- data[-inTrain,]

validation <- read.csv("data/pml-testing.csv")
```

## Some queries


```r
head(training[,seq(1,7)], 20)
```

```
##     X user_name raw_timestamp_part_1 raw_timestamp_part_2   cvtd_timestamp
## 1   1  carlitos           1323084231               788290 05/12/2011 11:23
## 3   3  carlitos           1323084231               820366 05/12/2011 11:23
## 4   4  carlitos           1323084232               120339 05/12/2011 11:23
## 5   5  carlitos           1323084232               196328 05/12/2011 11:23
## 6   6  carlitos           1323084232               304277 05/12/2011 11:23
## 7   7  carlitos           1323084232               368296 05/12/2011 11:23
## 9   9  carlitos           1323084232               484323 05/12/2011 11:23
## 10 10  carlitos           1323084232               484434 05/12/2011 11:23
## 11 11  carlitos           1323084232               500302 05/12/2011 11:23
## 12 12  carlitos           1323084232               528316 05/12/2011 11:23
## 14 14  carlitos           1323084232               576390 05/12/2011 11:23
## 15 15  carlitos           1323084232               604281 05/12/2011 11:23
## 16 16  carlitos           1323084232               644302 05/12/2011 11:23
## 17 17  carlitos           1323084232               692324 05/12/2011 11:23
## 19 19  carlitos           1323084232               740353 05/12/2011 11:23
## 21 21  carlitos           1323084232               876301 05/12/2011 11:23
## 22 22  carlitos           1323084232               892313 05/12/2011 11:23
## 23 23  carlitos           1323084232               932285 05/12/2011 11:23
## 25 25  carlitos           1323084233                28311 05/12/2011 11:23
## 26 26  carlitos           1323084233                56286 05/12/2011 11:23
##    new_window num_window
## 1          no         11
## 3          no         11
## 4          no         12
## 5          no         12
## 6          no         12
## 7          no         12
## 9          no         12
## 10         no         12
## 11         no         12
## 12         no         12
## 14         no         12
## 15         no         12
## 16         no         12
## 17         no         12
## 19         no         12
## 21         no         12
## 22         no         12
## 23         no         12
## 25         no         13
## 26         no         13
```

Several columns contain lots of NAs values:

```r
str(training)
```

```
## 'data.frame':	14718 obs. of  161 variables:
##  $ X                       : int  1 3 4 5 6 7 9 10 11 12 ...
##  $ user_name               : Factor w/ 6 levels "adelmo","carlitos",..: 2 2 2 2 2 2 2 2 2 2 ...
##  $ raw_timestamp_part_1    : int  1323084231 1323084231 1323084232 1323084232 1323084232 1323084232 1323084232 1323084232 1323084232 1323084232 ...
##  $ raw_timestamp_part_2    : int  788290 820366 120339 196328 304277 368296 484323 484434 500302 528316 ...
##  $ cvtd_timestamp          : Factor w/ 20 levels "02/12/2011 13:32",..: 9 9 9 9 9 9 9 9 9 9 ...
##  $ new_window              : Factor w/ 2 levels "no","yes": 1 1 1 1 1 1 1 1 1 1 ...
##  $ num_window              : int  11 11 12 12 12 12 12 12 12 12 ...
##  $ roll_belt               : num  1.41 1.42 1.48 1.48 1.45 1.42 1.43 1.45 1.45 1.43 ...
##  $ pitch_belt              : num  8.07 8.07 8.05 8.07 8.06 8.09 8.16 8.17 8.18 8.18 ...
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
##  $ gyros_belt_x            : num  0 0 0.02 0.02 0.02 0.02 0.02 0.03 0.03 0.02 ...
##  $ gyros_belt_y            : num  0 0 0 0.02 0 0 0 0 0 0 ...
##  $ gyros_belt_z            : num  -0.02 -0.02 -0.03 -0.02 -0.02 -0.02 -0.02 0 -0.02 -0.02 ...
##  $ accel_belt_x            : int  -21 -20 -22 -21 -21 -22 -20 -21 -21 -22 ...
##  $ accel_belt_y            : int  4 5 3 2 4 3 2 4 2 2 ...
##  $ accel_belt_z            : int  22 23 21 24 21 21 24 22 23 23 ...
##  $ magnet_belt_x           : int  -3 -2 -6 -6 0 -4 1 -3 -5 -2 ...
##  $ magnet_belt_y           : int  599 600 604 600 603 599 602 609 596 602 ...
##  $ magnet_belt_z           : int  -313 -305 -310 -302 -312 -311 -312 -308 -317 -319 ...
##  $ roll_arm                : num  -128 -128 -128 -128 -128 -128 -128 -128 -128 -128 ...
##  $ pitch_arm               : num  22.5 22.5 22.1 22.1 22 21.9 21.7 21.6 21.5 21.5 ...
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
##  $ gyros_arm_x             : num  0 0.02 0.02 0 0.02 0 0.02 0.02 0.02 0.02 ...
##  $ gyros_arm_y             : num  0 -0.02 -0.03 -0.03 -0.03 -0.03 -0.03 -0.03 -0.03 -0.03 ...
##  $ gyros_arm_z             : num  -0.02 -0.02 0.02 0 0 0 -0.02 -0.02 0 0 ...
##  $ accel_arm_x             : int  -288 -289 -289 -289 -289 -289 -288 -288 -290 -288 ...
##  $ accel_arm_y             : int  109 110 111 111 111 111 109 110 110 111 ...
##  $ accel_arm_z             : int  -123 -126 -123 -123 -122 -125 -122 -124 -123 -123 ...
##  $ magnet_arm_x            : int  -368 -368 -372 -374 -369 -373 -369 -376 -366 -363 ...
##  $ magnet_arm_y            : int  337 344 344 337 342 336 341 334 339 343 ...
##  $ magnet_arm_z            : int  516 513 512 506 513 509 518 516 509 520 ...
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
##  $ roll_dumbbell           : num  13.1 12.9 13.4 13.4 13.4 ...
##  $ pitch_dumbbell          : num  -70.5 -70.3 -70.4 -70.4 -70.8 ...
##  $ yaw_dumbbell            : num  -84.9 -85.1 -84.9 -84.9 -84.5 ...
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
colsPercent <- sapply(colnamesForFilter, function(x) { na <- is.na(training[,x]); sum(na)/length(na) })

trainingColnames <- names(which(colsPercent < 0.95))
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
## 5   9  carlitos 1323084232484323
## 6  10  carlitos 1323084232484434
## 7  11  carlitos 1323084232500302
## 8  12  carlitos 1323084232528316
## 9  14  carlitos 1323084232576390
## 10 15  carlitos 1323084232604281
## 11 16  carlitos 1323084232644302
## 12 17  carlitos 1323084232692324
## 13 19  carlitos 1323084232740353
## 14 21  carlitos 1323084232876301
## 15 22  carlitos 1323084232892313
## 16 23  carlitos 1323084232932285
```

ACP try:

```r
dat <- sapply(training[, trainingColnames[c(-1, -2, -93, -94)]], as.numeric)
preProc <- preProcess(dat, method="pca", thresh = 0.80)
preProc$rotation
```

```
##                                PC1        PC2        PC3        PC4
## raw_timestamp_part_1    -0.0002462 -0.1373882  1.430e-01  1.854e-01
## raw_timestamp_part_2     0.0446295  0.0001174  3.633e-03 -5.310e-03
## cvtd_timestamp          -0.0016339  0.2800071  8.306e-02  5.539e-02
## new_window               0.1864086  0.0023578  4.454e-03 -7.455e-04
## num_window               0.0014064 -0.0353596 -7.953e-02 -2.419e-02
## roll_belt                0.0027465 -0.3120730  3.069e-02  7.202e-02
## pitch_belt              -0.0015567  0.1101166  2.671e-01  6.421e-02
## yaw_belt                 0.0023884 -0.2780030 -1.259e-01  2.613e-02
## total_accel_belt         0.0029463 -0.2988550  4.678e-02  9.618e-02
## kurtosis_roll_belt       0.1658306 -0.0005629  1.300e-04  5.103e-03
## kurtosis_picth_belt      0.1665134  0.0056527  5.013e-05 -4.765e-04
## kurtosis_yaw_belt        0.1864086  0.0023578  4.454e-03 -7.455e-04
## skewness_roll_belt       0.1639016  0.0027354  1.099e-03  1.905e-03
## skewness_roll_belt.1     0.1651256  0.0024764 -1.635e-03  1.590e-03
## skewness_yaw_belt        0.1864086  0.0023578  4.454e-03 -7.455e-04
## max_yaw_belt             0.1647995 -0.0002313 -1.625e-03  5.683e-03
## min_yaw_belt             0.1647995 -0.0002313 -1.625e-03  5.683e-03
## amplitude_yaw_belt       0.1859696  0.0019005  3.348e-03 -2.141e-04
## gyros_belt_x             0.0018376 -0.0101782 -2.196e-01 -1.991e-01
## gyros_belt_y             0.0036946 -0.1778102 -1.356e-01 -8.311e-02
## gyros_belt_z             0.0007431  0.1263695 -1.250e-01 -1.030e-01
## accel_belt_x             0.0019830 -0.1233331 -2.639e-01 -8.714e-02
## accel_belt_y             0.0021521 -0.2789730  1.158e-01  9.864e-02
## accel_belt_z            -0.0025588  0.3096752 -5.538e-02 -6.259e-02
## magnet_belt_x            0.0024702 -0.1364424 -2.478e-01 -4.482e-02
## magnet_belt_y           -0.0012263  0.0551052 -1.194e-01  1.367e-01
## magnet_belt_z           -0.0002787 -0.0151022 -1.222e-01  1.223e-01
## roll_arm                -0.0022112  0.1276371  1.197e-01 -8.103e-02
## pitch_arm                0.0009742  0.0031945 -7.101e-02  1.929e-01
## yaw_arm                  0.0003886  0.0958951  7.474e-02 -3.700e-02
## total_accel_arm         -0.0021116  0.1075858 -1.878e-02 -3.828e-02
## gyros_arm_x             -0.0004647 -0.0316016 -3.888e-02  1.281e-03
## gyros_arm_y             -0.0001155  0.0980873  3.359e-02 -1.811e-03
## gyros_arm_z              0.0013887 -0.2135720 -9.007e-02 -6.315e-02
## accel_arm_x             -0.0001939 -0.0819062  1.701e-01 -1.166e-01
## accel_arm_y             -0.0012166  0.2829663 -1.556e-02  9.914e-02
## accel_arm_z              0.0015873 -0.1017499  6.664e-02  2.263e-01
## magnet_arm_x             0.0010803 -0.0686750  5.100e-02 -2.063e-01
## magnet_arm_y             0.0008642  0.0463789 -4.800e-02  3.158e-01
## magnet_arm_z             0.0007292  0.0151036 -3.548e-02  2.391e-01
## kurtosis_roll_arm        0.1642275  0.0117652  1.196e-03  6.786e-03
## kurtosis_picth_arm       0.1644050  0.0107968 -2.671e-03  7.977e-03
## kurtosis_yaw_arm         0.1639984  0.0010795  1.508e-05 -1.568e-04
## skewness_roll_arm        0.1658086  0.0094453 -4.243e-03  2.328e-03
## skewness_pitch_arm       0.1660976  0.0108513 -2.190e-03  5.665e-03
## skewness_yaw_arm         0.1640546  0.0044430  2.864e-03  3.309e-03
## roll_dumbbell            0.0006563  0.0163108 -1.508e-01 -2.693e-02
## pitch_dumbbell          -0.0022898 -0.0333525  1.742e-01 -1.194e-01
## yaw_dumbbell            -0.0028153  0.0062216  2.853e-01 -3.199e-02
## kurtosis_roll_dumbbell   0.1655139  0.0024730  5.860e-03 -7.291e-03
## kurtosis_picth_dumbbell  0.1619674  0.0030508  5.481e-03 -7.970e-03
## kurtosis_yaw_dumbbell    0.1864086  0.0023578  4.454e-03 -7.455e-04
## skewness_roll_dumbbell   0.1655576  0.0020375  6.809e-03 -5.668e-03
## skewness_pitch_dumbbell  0.1633598  0.0008203  5.907e-03 -4.113e-03
## skewness_yaw_dumbbell    0.1864086  0.0023578  4.454e-03 -7.455e-04
## max_yaw_dumbbell         0.1485708  0.0023847  7.314e-03 -8.625e-03
## min_yaw_dumbbell         0.1485708  0.0023847  7.314e-03 -8.625e-03
## amplitude_yaw_dumbbell   0.1861569  0.0025429  4.487e-03 -1.037e-03
## total_accel_dumbbell     0.0022829  0.0888287 -1.982e-01  1.664e-01
## gyros_dumbbell_x         0.0019498  0.0344235  2.806e-02  1.656e-01
## gyros_dumbbell_y         0.0003185 -0.0311885 -4.450e-02 -2.788e-02
## gyros_dumbbell_z        -0.0018995 -0.0573101  2.968e-03 -1.238e-01
## accel_dumbbell_x        -0.0024378 -0.0926905  1.894e-01 -1.765e-01
## accel_dumbbell_y         0.0013483  0.0788577 -2.372e-01  4.995e-02
## accel_dumbbell_z        -0.0027190 -0.0279072  2.771e-01 -1.173e-01
## magnet_dumbbell_x       -0.0013157 -0.0483958  2.521e-01  1.387e-01
## magnet_dumbbell_y        0.0011366  0.0410063 -2.246e-01 -1.987e-01
## magnet_dumbbell_z       -0.0015337  0.1608659 -7.636e-02 -2.289e-01
## roll_forearm            -0.0009884  0.0790746  1.691e-02  1.752e-01
## pitch_forearm            0.0009226 -0.0754718  1.557e-01 -8.494e-02
## yaw_forearm             -0.0020641  0.1153440 -1.828e-02  1.330e-01
## kurtosis_roll_forearm    0.1697196 -0.0066137 -4.822e-03 -9.941e-04
## kurtosis_picth_forearm   0.1688731 -0.0070876 -5.218e-03  1.943e-03
## kurtosis_yaw_forearm     0.1864086  0.0023578  4.454e-03 -7.455e-04
## skewness_roll_forearm    0.1669631 -0.0062528 -6.020e-03 -6.177e-05
## skewness_pitch_forearm   0.1679663 -0.0075361 -2.768e-03 -1.208e-03
## skewness_yaw_forearm     0.1864086  0.0023578  4.454e-03 -7.455e-04
## max_yaw_forearm          0.1744530 -0.0073870 -6.200e-03 -1.615e-03
## min_yaw_forearm          0.1744530 -0.0073870 -6.200e-03 -1.615e-03
## amplitude_yaw_forearm    0.1807113 -0.0067588 -5.634e-03 -1.725e-03
## total_accel_forearm     -0.0018148 -0.0446858 -8.235e-02  1.129e-02
## gyros_forearm_x          0.0005992 -0.1435742 -1.396e-01  7.840e-02
## gyros_forearm_y         -0.0002387 -0.0293979 -2.053e-02 -1.816e-02
## gyros_forearm_z         -0.0016182 -0.0418330 -6.083e-02 -5.008e-02
## accel_forearm_x         -0.0026857  0.2024991 -8.155e-03  1.160e-01
## accel_forearm_y         -0.0014268 -0.0115546 -9.574e-02  1.159e-01
## accel_forearm_z         -0.0005952 -0.0353473 -4.166e-02 -2.810e-01
## magnet_forearm_x        -0.0007641  0.0931595 -4.132e-02 -2.994e-02
## magnet_forearm_y        -0.0014012 -0.0014223 -5.705e-02  1.326e-01
## magnet_forearm_z         0.0006422 -0.0810892 -6.378e-02  2.619e-01
##                                PC5        PC6        PC7        PC8
## raw_timestamp_part_1    -1.442e-01  0.0922639 -0.0594417  0.1286245
## raw_timestamp_part_2    -8.973e-03 -0.0110399 -0.0054105 -0.0233146
## cvtd_timestamp          -6.556e-02 -0.0701638  0.0299466 -0.0412846
## new_window              -4.177e-04  0.0008355 -0.0021419  0.0002884
## num_window              -2.162e-02  0.1084436 -0.0510695 -0.0086467
## roll_belt                3.026e-02 -0.0413573  0.0437144 -0.1018272
## pitch_belt              -5.048e-02  0.1810873 -0.0887054 -0.0702346
## yaw_belt                 4.174e-02 -0.1360725  0.0792653 -0.0322329
## total_accel_belt         1.534e-02 -0.0426965  0.0492311 -0.1168506
## kurtosis_roll_belt       1.445e-05 -0.0055794  0.0025014 -0.0016539
## kurtosis_picth_belt     -3.767e-04  0.0071180  0.0009342  0.0048331
## kurtosis_yaw_belt       -4.177e-04  0.0008355 -0.0021419  0.0002884
## skewness_roll_belt      -1.200e-03  0.0013562 -0.0041107  0.0011712
## skewness_roll_belt.1    -1.116e-03  0.0072313 -0.0019350  0.0042412
## skewness_yaw_belt       -4.177e-04  0.0008355 -0.0021419  0.0002884
## max_yaw_belt             6.834e-06 -0.0050901  0.0030108 -0.0014651
## min_yaw_belt             6.834e-06 -0.0050901  0.0030108 -0.0014651
## amplitude_yaw_belt       5.816e-04  0.0003747 -0.0010915 -0.0008776
## gyros_belt_x             3.646e-02  0.1705850 -0.0491165  0.0438294
## gyros_belt_y             3.700e-02  0.1231500  0.0042407 -0.0248676
## gyros_belt_z             1.316e-02  0.1110804 -0.0702639  0.0328774
## accel_belt_x             6.833e-02 -0.1698593  0.0759676  0.0472135
## accel_belt_y             1.576e-02  0.0112740  0.0216254 -0.1128077
## accel_belt_z            -4.572e-02  0.0421677 -0.0351393  0.1049054
## magnet_belt_x            7.549e-02 -0.2016447  0.0878429 -0.0106123
## magnet_belt_y           -2.268e-01  0.1718623  0.0033315  0.1407060
## magnet_belt_z           -2.105e-01  0.2044321 -0.0428896  0.2049885
## roll_arm                 6.196e-02 -0.2064938 -0.0104433  0.1282283
## pitch_arm                2.450e-01  0.0130918  0.0640458 -0.0002338
## yaw_arm                  9.958e-02 -0.1315290 -0.0009311  0.0606803
## total_accel_arm         -8.567e-02 -0.0151781 -0.0766409 -0.3185585
## gyros_arm_x              1.301e-02 -0.0132688 -0.4171510  0.0435251
## gyros_arm_y              7.533e-03  0.0315445  0.3960635 -0.0281843
## gyros_arm_z             -8.169e-04  0.0745543 -0.1527224 -0.0564578
## accel_arm_x             -2.989e-01 -0.2172074  0.0445338  0.0184651
## accel_arm_y              1.481e-01  0.0042846  0.0269606  0.1262136
## accel_arm_z              2.434e-01  0.0372473  0.1164322  0.2348048
## magnet_arm_x            -3.054e-01 -0.1084532  0.0707568  0.1379896
## magnet_arm_y             2.907e-01  0.1022111  0.0079826  0.0136068
## magnet_arm_z             3.494e-01  0.1480217  0.0305087  0.1725168
## kurtosis_roll_arm       -1.167e-02  0.0023175  0.0003543 -0.0071664
## kurtosis_picth_arm      -1.019e-02  0.0004481 -0.0044607 -0.0080360
## kurtosis_yaw_arm         4.592e-04  0.0078402 -0.0033923 -0.0021677
## skewness_roll_arm       -8.087e-03  0.0020776  0.0058758  0.0007552
## skewness_pitch_arm      -1.224e-02  0.0021035  0.0129918  0.0025991
## skewness_yaw_arm         4.385e-03  0.0005816  0.0060060 -0.0033680
## roll_dumbbell           -1.048e-01 -0.0511864  0.1026302  0.3017592
## pitch_dumbbell           5.056e-02 -0.0700893  0.0225391  0.2971644
## yaw_dumbbell             3.488e-02  0.0386667 -0.0855341  0.0679656
## kurtosis_roll_dumbbell   5.474e-03  0.0024147 -0.0084490 -0.0012958
## kurtosis_picth_dumbbell  8.644e-04  0.0027425 -0.0080836 -0.0059372
## kurtosis_yaw_dumbbell   -4.177e-04  0.0008355 -0.0021419  0.0002884
## skewness_roll_dumbbell   2.620e-03  0.0057609 -0.0075988 -0.0064890
## skewness_pitch_dumbbell  6.795e-03  0.0053562 -0.0036213 -0.0018107
## skewness_yaw_dumbbell   -4.177e-04  0.0008355 -0.0021419  0.0002884
## max_yaw_dumbbell         7.349e-03  0.0075053 -0.0123533 -0.0057474
## min_yaw_dumbbell         7.349e-03  0.0075053 -0.0123533 -0.0057474
## amplitude_yaw_dumbbell   1.093e-04  0.0006954 -0.0026404  0.0003907
## total_accel_dumbbell    -1.287e-01 -0.1259488  0.1180984 -0.0490993
## gyros_dumbbell_x        -8.270e-02 -0.1664691  0.2507007 -0.0393264
## gyros_dumbbell_y        -3.001e-02  0.1010281 -0.1436849 -0.1319247
## gyros_dumbbell_z         9.600e-02  0.1369664 -0.1701213  0.0814178
## accel_dumbbell_x         1.213e-01 -0.0451396 -0.0232462  0.2139064
## accel_dumbbell_y        -1.463e-01 -0.0832186  0.1132681  0.1624418
## accel_dumbbell_z         1.340e-01 -0.0076778 -0.0888026  0.0639581
## magnet_dumbbell_x       -1.305e-02 -0.2144337  0.0747063  0.0223868
## magnet_dumbbell_y       -1.326e-02  0.2170849 -0.0332429  0.1167088
## magnet_dumbbell_z        1.707e-01 -0.2389178  0.0546809  0.0259016
## roll_forearm            -1.318e-01 -0.1235327 -0.0828084 -0.0044825
## pitch_forearm           -9.166e-02  0.0716946  0.1086528  0.2089516
## yaw_forearm             -1.626e-02 -0.2319090 -0.2031812  0.0718671
## kurtosis_roll_forearm    3.715e-03 -0.0066548  0.0084768  0.0111716
## kurtosis_picth_forearm  -7.355e-04 -0.0057651 -0.0027745  0.0034104
## kurtosis_yaw_forearm    -4.177e-04  0.0008355 -0.0021419  0.0002884
## skewness_roll_forearm    1.866e-03 -0.0101001 -0.0013695  0.0054227
## skewness_pitch_forearm   1.712e-03 -0.0107230  0.0050202  0.0051851
## skewness_yaw_forearm    -4.177e-04  0.0008355 -0.0021419  0.0002884
## max_yaw_forearm          3.912e-03 -0.0088552  0.0057665  0.0095842
## min_yaw_forearm          3.912e-03 -0.0088552  0.0057665  0.0095842
## amplitude_yaw_forearm    2.647e-03 -0.0098567  0.0010730  0.0037838
## total_accel_forearm      1.282e-02 -0.1729494 -0.0614143  0.2601213
## gyros_forearm_x          3.716e-02 -0.1386089  0.0921855  0.1347316
## gyros_forearm_y         -3.158e-02 -0.0343160 -0.0858971 -0.1428486
## gyros_forearm_z          1.402e-02 -0.1645490 -0.0731727 -0.0960705
## accel_forearm_x          1.358e-02 -0.1481355 -0.0443821 -0.2036478
## accel_forearm_y          3.026e-02 -0.3309388 -0.2986983  0.0924706
## accel_forearm_z          2.613e-01 -0.1088899 -0.0241689 -0.0764869
## magnet_forearm_x         9.018e-02 -0.0081817  0.1577570 -0.2956422
## magnet_forearm_y         2.635e-02 -0.1503828 -0.4225398  0.0145852
## magnet_forearm_z        -2.577e-01  0.0369398 -0.0813154  0.0153395
##                                PC9       PC10       PC11       PC12
## raw_timestamp_part_1    -0.1584702  0.1682659 -0.0844817  0.1814362
## raw_timestamp_part_2     0.0094597 -0.0161770  0.0050395 -0.0351012
## cvtd_timestamp           0.0942576 -0.1332686  0.0577917 -0.1959442
## new_window               0.0004469 -0.0009321 -0.0009218  0.0003391
## num_window               0.0858587 -0.1498737 -0.0152497 -0.0644878
## roll_belt                0.0134770 -0.0103410  0.0152498 -0.0515649
## pitch_belt               0.0681520 -0.0598723  0.0199667 -0.1033943
## yaw_belt                -0.0353024  0.0300764 -0.0033288  0.0521174
## total_accel_belt         0.0299857 -0.0182720  0.0245976 -0.0744630
## kurtosis_roll_belt      -0.0002765  0.0138299  0.0135732 -0.0145820
## kurtosis_picth_belt     -0.0045268  0.0030638  0.0060869 -0.0031563
## kurtosis_yaw_belt        0.0004469 -0.0009321 -0.0009218  0.0003391
## skewness_roll_belt       0.0056458  0.0022097  0.0012613  0.0086649
## skewness_roll_belt.1    -0.0047203  0.0055724  0.0018129  0.0056862
## skewness_yaw_belt        0.0004469 -0.0009321 -0.0009218  0.0003391
## max_yaw_belt             0.0008610  0.0164016  0.0160651 -0.0147182
## min_yaw_belt             0.0008610  0.0164016  0.0160651 -0.0147182
## amplitude_yaw_belt       0.0013339  0.0004875  0.0010954 -0.0015270
## gyros_belt_x            -0.0045644 -0.0153319 -0.0421461  0.0025505
## gyros_belt_y             0.1341186 -0.0147127 -0.0666810  0.1634679
## gyros_belt_z             0.1441217 -0.0712332 -0.0811230  0.2523825
## accel_belt_x            -0.0490277  0.0407111 -0.0267526  0.0794290
## accel_belt_y             0.0351323 -0.0208432  0.0331568 -0.0723360
## accel_belt_z            -0.0111406  0.0073195 -0.0012277  0.0613095
## magnet_belt_x           -0.0213281  0.0092266  0.0066551 -0.0048222
## magnet_belt_y           -0.0306047  0.0226985  0.1017902  0.1830693
## magnet_belt_z           -0.0874971  0.0704198  0.0613393  0.2275860
## roll_arm                 0.0001217 -0.0019683 -0.0149423  0.1597959
## pitch_arm               -0.0484853 -0.0686919  0.1408721 -0.0321903
## yaw_arm                  0.0558342 -0.0496554 -0.0384101  0.0699337
## total_accel_arm         -0.0973040  0.1635326  0.1141675 -0.0625771
## gyros_arm_x              0.2987984  0.0745377  0.3772325 -0.0035583
## gyros_arm_y             -0.2812226 -0.0743527 -0.3783416 -0.0039878
## gyros_arm_z              0.1407171  0.0350650  0.1626878 -0.0289796
## accel_arm_x              0.0720051 -0.0472103 -0.0164346 -0.0284152
## accel_arm_y              0.0137398 -0.0525221  0.0319880 -0.0272648
## accel_arm_z              0.0140918 -0.1370196 -0.0119153  0.0045149
## magnet_arm_x             0.0825236 -0.1092616 -0.0703071  0.0188313
## magnet_arm_y            -0.0172095  0.0173102  0.1163350 -0.0553667
## magnet_arm_z            -0.0053796 -0.0830000  0.0204048  0.0250938
## kurtosis_roll_arm        0.0047123 -0.0089766  0.0009121 -0.0155873
## kurtosis_picth_arm       0.0088462 -0.0027548  0.0158903 -0.0178288
## kurtosis_yaw_arm         0.0044744  0.0115635  0.0050826 -0.0006995
## skewness_roll_arm        0.0085970 -0.0143260  0.0098581 -0.0164929
## skewness_pitch_arm      -0.0042754 -0.0084646  0.0012990 -0.0169864
## skewness_yaw_arm        -0.0124653 -0.0013556 -0.0100860  0.0007207
## roll_dumbbell           -0.1253313  0.1996690  0.2204181 -0.2378318
## pitch_dumbbell          -0.1470833  0.2604038  0.2002455 -0.0421324
## yaw_dumbbell            -0.0432479  0.0866020  0.0299478  0.0084632
## kurtosis_roll_dumbbell  -0.0047748 -0.0149390 -0.0238665  0.0356030
## kurtosis_picth_dumbbell  0.0031280 -0.0083585 -0.0090983  0.0016493
## kurtosis_yaw_dumbbell    0.0004469 -0.0009321 -0.0009218  0.0003391
## skewness_roll_dumbbell   0.0038754 -0.0091885 -0.0166978  0.0143982
## skewness_pitch_dumbbell  0.0083279 -0.0022222 -0.0118843  0.0119456
## skewness_yaw_dumbbell    0.0004469 -0.0009321 -0.0009218  0.0003391
## max_yaw_dumbbell        -0.0097631 -0.0234008 -0.0356657  0.0455535
## min_yaw_dumbbell        -0.0097631 -0.0234008 -0.0356657  0.0455535
## amplitude_yaw_dumbbell  -0.0001954 -0.0016875 -0.0012869  0.0005437
## total_accel_dumbbell     0.0051231 -0.0564057  0.1400028 -0.2329893
## gyros_dumbbell_x         0.2765347 -0.0911269  0.1496800  0.2582734
## gyros_dumbbell_y        -0.2333277  0.0049170 -0.0969646 -0.4665386
## gyros_dumbbell_z        -0.2675871  0.1335722 -0.1645971 -0.0900634
## accel_dumbbell_x        -0.1253168  0.1945887  0.1114772  0.1137727
## accel_dumbbell_y        -0.0642821  0.0638229  0.1898560 -0.2322484
## accel_dumbbell_z        -0.0385599  0.0590176  0.0170894  0.0428795
## magnet_dumbbell_x       -0.0424292  0.0580989  0.1651719 -0.1488916
## magnet_dumbbell_y       -0.0153802  0.0154715  0.0353470 -0.0322308
## magnet_dumbbell_z        0.0378532 -0.0364395  0.0695330 -0.0514251
## roll_forearm             0.0107354 -0.0198421 -0.0268497  0.0745292
## pitch_forearm            0.0395526 -0.2571202  0.0391706 -0.0928303
## yaw_forearm             -0.0154318 -0.0847889 -0.0992574 -0.0055096
## kurtosis_roll_forearm   -0.0054470  0.0133283  0.0119416 -0.0117783
## kurtosis_picth_forearm  -0.0045273  0.0063337  0.0082281  0.0001236
## kurtosis_yaw_forearm     0.0004469 -0.0009321 -0.0009218  0.0003391
## skewness_roll_forearm   -0.0032774  0.0006405  0.0017942  0.0017069
## skewness_pitch_forearm  -0.0008383  0.0118810  0.0050027 -0.0022314
## skewness_yaw_forearm     0.0004469 -0.0009321 -0.0009218  0.0003391
## max_yaw_forearm         -0.0058428  0.0140969  0.0098187 -0.0078942
## min_yaw_forearm         -0.0058428  0.0140969  0.0098187 -0.0078942
## amplitude_yaw_forearm   -0.0035397  0.0109028  0.0041384 -0.0011869
## total_accel_forearm     -0.0544894 -0.0662312 -0.0625145 -0.0352474
## gyros_forearm_x          0.1539887  0.2447317 -0.1961429 -0.0165026
## gyros_forearm_y         -0.4487143 -0.3194180  0.2904700  0.2095081
## gyros_forearm_z         -0.3998100 -0.2678878  0.2426122  0.2210695
## accel_forearm_x         -0.0639181  0.3332487 -0.0497007  0.1011052
## accel_forearm_y         -0.0690375  0.0337769 -0.2481271  0.0594257
## accel_forearm_z          0.1022947 -0.1258719  0.0334456 -0.0356467
## magnet_forearm_x        -0.0429297  0.4225415  0.0961720  0.1818183
## magnet_forearm_y        -0.0105071 -0.0780773 -0.2509468 -0.0555426
## magnet_forearm_z        -0.0752537  0.0305876 -0.0424739  0.0378724
##                               PC13       PC14
## raw_timestamp_part_1    -0.0519880  1.721e-01
## raw_timestamp_part_2    -0.0593804  7.884e-03
## cvtd_timestamp           0.0343874 -1.230e-02
## new_window              -0.0013366 -6.070e-03
## num_window               0.1222071 -2.677e-01
## roll_belt                0.0132828 -5.144e-02
## pitch_belt              -0.0226325 -1.204e-01
## yaw_belt                 0.0143381  4.727e-02
## total_accel_belt         0.0189775 -7.386e-02
## kurtosis_roll_belt       0.0122429  1.027e-01
## kurtosis_picth_belt     -0.0046593  6.424e-03
## kurtosis_yaw_belt       -0.0013366 -6.070e-03
## skewness_roll_belt       0.0030312 -4.607e-03
## skewness_roll_belt.1     0.0048903  2.222e-02
## skewness_yaw_belt       -0.0013366 -6.070e-03
## max_yaw_belt             0.0126654  1.119e-01
## min_yaw_belt             0.0126654  1.119e-01
## amplitude_yaw_belt       0.0004017  3.210e-03
## gyros_belt_x            -0.0184652 -8.127e-02
## gyros_belt_y            -0.0035182 -1.729e-01
## gyros_belt_z             0.0186245 -5.279e-02
## accel_belt_x             0.0263179  9.055e-02
## accel_belt_y             0.0036264 -8.130e-02
## accel_belt_z            -0.0141755  5.087e-02
## magnet_belt_x            0.0202053  7.899e-02
## magnet_belt_y           -0.0126366 -1.320e-02
## magnet_belt_z           -0.0717612  3.419e-02
## roll_arm                 0.0389159  1.949e-01
## pitch_arm               -0.2181964  8.107e-02
## yaw_arm                  0.2146391  1.019e-01
## total_accel_arm         -0.4637469  3.927e-02
## gyros_arm_x              0.1039538  1.691e-01
## gyros_arm_y             -0.1293063 -1.433e-01
## gyros_arm_z             -0.0178433 -3.490e-02
## accel_arm_x              0.1331770  6.269e-02
## accel_arm_y              0.1020844  4.978e-02
## accel_arm_z              0.2763088 -9.895e-03
## magnet_arm_x             0.2770695  2.513e-02
## magnet_arm_y            -0.0113724 -4.610e-03
## magnet_arm_z             0.1369762 -2.990e-02
## kurtosis_roll_arm        0.0021194 -1.976e-03
## kurtosis_picth_arm       0.0020599  2.065e-02
## kurtosis_yaw_arm        -0.0001141  3.497e-02
## skewness_roll_arm        0.0050168  9.894e-05
## skewness_pitch_arm       0.0009556  1.790e-02
## skewness_yaw_arm        -0.0033884 -1.280e-02
## roll_dumbbell           -0.0152811 -1.939e-01
## pitch_dumbbell          -0.0725344 -2.284e-01
## yaw_dumbbell            -0.0392350 -1.202e-01
## kurtosis_roll_dumbbell  -0.0106654 -1.587e-01
## kurtosis_picth_dumbbell -0.0114876 -7.618e-02
## kurtosis_yaw_dumbbell   -0.0013366 -6.070e-03
## skewness_roll_dumbbell  -0.0072639 -9.298e-02
## skewness_pitch_dumbbell -0.0054309 -7.369e-02
## skewness_yaw_dumbbell   -0.0013366 -6.070e-03
## max_yaw_dumbbell        -0.0124250 -2.131e-01
## min_yaw_dumbbell        -0.0124250 -2.131e-01
## amplitude_yaw_dumbbell  -0.0020816 -9.802e-03
## total_accel_dumbbell     0.0567139 -4.439e-03
## gyros_dumbbell_x        -0.1685208 -1.579e-01
## gyros_dumbbell_y         0.1868349  7.060e-02
## gyros_dumbbell_z         0.1577598  1.902e-01
## accel_dumbbell_x        -0.0507384 -1.500e-01
## accel_dumbbell_y         0.0436910 -1.422e-01
## accel_dumbbell_z        -0.0452390 -9.726e-02
## magnet_dumbbell_x       -0.0180416 -7.044e-02
## magnet_dumbbell_y       -0.0040636 -1.872e-01
## magnet_dumbbell_z        0.0170768 -4.965e-02
## roll_forearm             0.1581311 -2.051e-01
## pitch_forearm            0.0271582  7.285e-02
## yaw_forearm             -0.0908514 -7.326e-03
## kurtosis_roll_forearm    0.0030455  7.476e-02
## kurtosis_picth_forearm   0.0056140  5.093e-02
## kurtosis_yaw_forearm    -0.0013366 -6.070e-03
## skewness_roll_forearm    0.0022370  3.846e-02
## skewness_pitch_forearm   0.0034859  5.366e-02
## skewness_yaw_forearm    -0.0013366 -6.070e-03
## max_yaw_forearm          0.0035353  7.127e-02
## min_yaw_forearm          0.0035353  7.127e-02
## amplitude_yaw_forearm    0.0044884  5.198e-02
## total_accel_forearm     -0.3166856  1.397e-01
## gyros_forearm_x         -0.0341973  8.390e-02
## gyros_forearm_y          0.1002979 -1.168e-02
## gyros_forearm_z          0.0513625 -6.889e-03
## accel_forearm_x          0.2293775 -9.183e-02
## accel_forearm_y         -0.0044132 -1.295e-01
## accel_forearm_z          0.0035299 -2.006e-01
## magnet_forearm_x         0.3095738 -5.768e-02
## magnet_forearm_y        -0.0816711 -2.478e-01
## magnet_forearm_z         0.1434164 -1.590e-01
```

## First model


```r
set.seed(32343)
#modelFit <- train(classe ~ ., data=training, method="glm")
#modelFit
```
