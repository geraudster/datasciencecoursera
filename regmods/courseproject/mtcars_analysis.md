# Analysis of relationship between car transmission and fuel consumption

## Synopsis

We will use the mtcars dataset to determine the kind of transmission (automatic/manual)
that has the most Miles per Gallon, and in which proportion.

## Data processing

We will use the mtcars dataset included in the R core.

Format is: 
    
* TODO

First we load the data:


```r
data(mtcars)
names(mtcars)
```

```
##  [1] "mpg"  "cyl"  "disp" "hp"   "drat" "wt"   "qsec" "vs"   "am"   "gear"
## [11] "carb"
```

```r
nrow(mtcars)
```

```
## [1] 32
```

```r
head(mtcars)
```

```
##                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
## Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
## Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
## Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
## Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
## Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
## Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```

Next we prepare the data (to have proper label when drawing plots):

```r
mtcars <- transform(mtcars, transmission = factor(mtcars$am,
                                                     levels = c(0,1),
                                                     labels = c("Automatic", "Manual")))
```

## Exploratory analysis

We would like to determine if there is a relationship between transmission an mpg.


```r
boxplot(mpg~transmission,data=mtcars, main="Car Milage Data",
   xlab="Transmission type", ylab="Miles Per Gallon") 
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3.png) 

So it seems there is a relation between transmission and mpg: cars use more fuel when
transmission is manual than automatic


```r
cor(mtcars$am, mtcars$mpg)
```

```
## [1] 0.5998
```

## Regression model


```r
model <- lm(mpg~am, data=mtcars)
model.summary <- summary(model)
model.summary
```

```
## 
## Call:
## lm(formula = mpg ~ am, data = mtcars)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -9.392 -3.092 -0.297  3.244  9.508 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept)    17.15       1.12   15.25  1.1e-15 ***
## am              7.24       1.76    4.11  0.00029 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 4.9 on 30 degrees of freedom
## Multiple R-squared:  0.36,	Adjusted R-squared:  0.338 
## F-statistic: 16.9 on 1 and 30 DF,  p-value: 0.000285
```

This model shows that:

* the coefficient is statistically significant (with a p-value of 2.8502 &times; 10<sup>-4</sup>)
* transmission explains 35.9799% of the variance
* when the transmision change from automatic (0) to manual(1), there is an increase in mpg of
7.2449

Next the confidence interval:


```r
confint(model)
```

```
##              2.5 % 97.5 %
## (Intercept) 14.851  19.44
## am           3.642  10.85
```

Let's plot the residuals:


```r
plot(resid(model))
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7.png) 
