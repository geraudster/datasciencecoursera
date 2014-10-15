
Loading libraries

```r
#install.packages('caret')
#install.packages('kernlab')
#install.packages('e1071', dependencies=TRUE)
library(caret)
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```r
library(kernlab)
data(spam)
set.seed(32323)

inTrain <- createDataPartition(y=spam$type, p=0.75, list=FALSE)

training <- spam[inTrain,]
testing <- spam[-inTrain,]

dim(training)
```

```
## [1] 3451   58
```

```r
dim(testing)
```

```
## [1] 1150   58
```

1st attempt to fit a glm model:


```r
set.seed(32343)
modelFit <- train(type ~ ., data=training, method="glm")
```

```
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: algorithm did not converge
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
## Warning: glm.fit: fitted probabilities numerically 0 or 1 occurred
```

```r
modelFit
```

```
## Generalized Linear Model 
## 
## 3451 samples
##   57 predictors
##    2 classes: 'nonspam', 'spam' 
## 
## No pre-processing
## Resampling: Bootstrapped (25 reps) 
## 
## Summary of sample sizes: 3451, 3451, 3451, 3451, 3451, 3451, ... 
## 
## Resampling results
## 
##   Accuracy  Kappa  Accuracy SD  Kappa SD
##   0.9       0.8    0.01         0.02    
## 
## 
```

Try some predictions with the model:


```r
predictions <- predict(modelFit, newdata=testing)
predictions
```

```
##    [1] spam    spam    spam    spam    spam    spam    nonspam spam   
##    [9] spam    spam    spam    spam    spam    spam    spam    spam   
##   [17] spam    spam    spam    spam    nonspam spam    spam    spam   
##   [25] spam    spam    spam    spam    spam    spam    spam    spam   
##   [33] spam    spam    spam    spam    spam    spam    spam    nonspam
##   [41] spam    spam    spam    spam    spam    spam    spam    spam   
##   [49] nonspam spam    nonspam spam    spam    spam    spam    spam   
##   [57] spam    spam    spam    spam    spam    spam    spam    spam   
##   [65] spam    spam    spam    spam    nonspam nonspam spam    nonspam
##   [73] nonspam spam    spam    spam    spam    spam    spam    spam   
##   [81] spam    nonspam spam    spam    spam    spam    spam    spam   
##   [89] spam    spam    spam    nonspam spam    spam    spam    spam   
##   [97] spam    spam    spam    spam    spam    spam    spam    nonspam
##  [105] spam    spam    spam    spam    nonspam spam    spam    nonspam
##  [113] spam    spam    spam    spam    spam    spam    spam    spam   
##  [121] spam    spam    nonspam spam    spam    spam    nonspam spam   
##  [129] spam    spam    spam    nonspam spam    spam    spam    spam   
##  [137] spam    spam    spam    spam    nonspam spam    spam    spam   
##  [145] spam    spam    nonspam spam    spam    spam    spam    spam   
##  [153] spam    spam    spam    spam    spam    spam    spam    spam   
##  [161] spam    spam    spam    spam    spam    spam    spam    spam   
##  [169] spam    spam    spam    spam    spam    spam    spam    spam   
##  [177] spam    spam    spam    nonspam spam    spam    nonspam spam   
##  [185] spam    spam    spam    spam    spam    spam    spam    spam   
##  [193] spam    spam    spam    spam    spam    spam    spam    spam   
##  [201] spam    spam    spam    spam    spam    spam    spam    spam   
##  [209] spam    spam    spam    spam    spam    spam    nonspam spam   
##  [217] spam    spam    spam    spam    spam    spam    spam    spam   
##  [225] spam    spam    spam    nonspam spam    spam    spam    spam   
##  [233] spam    spam    spam    spam    spam    spam    spam    spam   
##  [241] spam    spam    spam    spam    spam    spam    spam    spam   
##  [249] spam    spam    spam    spam    spam    spam    spam    spam   
##  [257] spam    spam    spam    spam    spam    spam    spam    spam   
##  [265] spam    spam    spam    spam    spam    spam    spam    spam   
##  [273] spam    spam    spam    spam    spam    nonspam spam    spam   
##  [281] nonspam spam    spam    spam    nonspam spam    spam    spam   
##  [289] spam    spam    spam    spam    spam    spam    spam    spam   
##  [297] nonspam spam    spam    spam    spam    spam    spam    spam   
##  [305] spam    spam    spam    spam    spam    spam    spam    spam   
##  [313] spam    spam    spam    spam    spam    spam    spam    spam   
##  [321] spam    spam    nonspam spam    spam    spam    spam    spam   
##  [329] spam    spam    spam    spam    spam    spam    spam    spam   
##  [337] spam    spam    spam    spam    spam    spam    spam    nonspam
##  [345] spam    spam    spam    nonspam spam    spam    spam    nonspam
##  [353] nonspam spam    spam    spam    spam    spam    spam    spam   
##  [361] spam    spam    spam    spam    nonspam nonspam spam    spam   
##  [369] spam    spam    spam    spam    spam    spam    spam    spam   
##  [377] spam    spam    spam    spam    spam    spam    spam    spam   
##  [385] spam    spam    spam    spam    nonspam spam    spam    spam   
##  [393] spam    nonspam spam    nonspam nonspam spam    spam    spam   
##  [401] spam    spam    nonspam spam    nonspam spam    spam    nonspam
##  [409] nonspam spam    nonspam spam    spam    nonspam spam    nonspam
##  [417] spam    nonspam spam    spam    spam    spam    spam    nonspam
##  [425] spam    spam    nonspam spam    spam    spam    spam    spam   
##  [433] spam    spam    spam    spam    spam    spam    spam    spam   
##  [441] spam    spam    spam    spam    spam    spam    spam    spam   
##  [449] spam    spam    spam    spam    spam    nonspam nonspam nonspam
##  [457] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [465] nonspam nonspam nonspam nonspam nonspam nonspam spam    nonspam
##  [473] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [481] spam    nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [489] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [497] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [505] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [513] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [521] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [529] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [537] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [545] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [553] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [561] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [569] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [577] nonspam nonspam nonspam nonspam nonspam spam    nonspam spam   
##  [585] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [593] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [601] spam    nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [609] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [617] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [625] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [633] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [641] nonspam nonspam nonspam nonspam nonspam nonspam spam    nonspam
##  [649] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [657] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [665] nonspam nonspam nonspam spam    nonspam nonspam nonspam nonspam
##  [673] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [681] nonspam nonspam nonspam spam    nonspam nonspam nonspam nonspam
##  [689] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [697] nonspam nonspam nonspam nonspam nonspam spam    nonspam nonspam
##  [705] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [713] nonspam nonspam nonspam nonspam nonspam nonspam spam    nonspam
##  [721] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [729] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [737] nonspam nonspam nonspam nonspam nonspam nonspam spam    nonspam
##  [745] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [753] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [761] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [769] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [777] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [785] nonspam nonspam nonspam nonspam spam    nonspam nonspam nonspam
##  [793] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [801] nonspam nonspam spam    nonspam nonspam nonspam nonspam nonspam
##  [809] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [817] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [825] spam    nonspam spam    spam    nonspam nonspam nonspam nonspam
##  [833] nonspam nonspam nonspam nonspam nonspam nonspam spam    nonspam
##  [841] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [849] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [857] spam    nonspam spam    nonspam nonspam nonspam nonspam nonspam
##  [865] nonspam nonspam nonspam nonspam nonspam nonspam nonspam spam   
##  [873] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [881] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [889] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [897] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [905] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [913] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [921] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [929] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [937] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [945] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [953] nonspam spam    nonspam spam    nonspam nonspam nonspam nonspam
##  [961] nonspam nonspam nonspam spam    nonspam nonspam nonspam nonspam
##  [969] nonspam nonspam nonspam nonspam nonspam nonspam spam    nonspam
##  [977] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [985] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
##  [993] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
## [1001] nonspam spam    nonspam nonspam nonspam nonspam nonspam nonspam
## [1009] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
## [1017] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
## [1025] nonspam nonspam nonspam nonspam spam    nonspam nonspam nonspam
## [1033] nonspam nonspam spam    nonspam nonspam spam    nonspam nonspam
## [1041] spam    nonspam nonspam nonspam nonspam nonspam nonspam nonspam
## [1049] nonspam nonspam nonspam nonspam nonspam nonspam spam    nonspam
## [1057] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
## [1065] spam    nonspam nonspam spam    nonspam nonspam nonspam nonspam
## [1073] nonspam spam    nonspam nonspam nonspam nonspam nonspam nonspam
## [1081] nonspam nonspam nonspam nonspam spam    nonspam nonspam nonspam
## [1089] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
## [1097] nonspam nonspam nonspam nonspam nonspam spam    nonspam spam   
## [1105] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
## [1113] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
## [1121] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
## [1129] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
## [1137] nonspam nonspam nonspam nonspam nonspam nonspam nonspam nonspam
## [1145] nonspam nonspam nonspam nonspam nonspam nonspam
## Levels: nonspam spam
```

Evalute the model:


```r
confusionMatrix(predictions, testing$type)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction nonspam spam
##    nonspam     661   48
##    spam         36  405
##                                        
##                Accuracy : 0.927        
##                  95% CI : (0.91, 0.941)
##     No Information Rate : 0.606        
##     P-Value [Acc > NIR] : <2e-16       
##                                        
##                   Kappa : 0.846        
##  Mcnemar's Test P-Value : 0.23         
##                                        
##             Sensitivity : 0.948        
##             Specificity : 0.894        
##          Pos Pred Value : 0.932        
##          Neg Pred Value : 0.918        
##              Prevalence : 0.606        
##          Detection Rate : 0.575        
##    Detection Prevalence : 0.617        
##       Balanced Accuracy : 0.921        
##                                        
##        'Positive' Class : nonspam      
## 
```
