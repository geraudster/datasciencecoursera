---
title : OzoneApp
subtitle    : Ozone pollution prediction and global warming
author : Géraud Dugé de Bernonville
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
license     : by-sa
theme       : solarized-light
---




## Intro

* Global warming is a major preoccupation, and recent studies show that temperature raising is
a real concern.
* Ozone pollution is another major concern as our populations became more and more urban, and we can see that Ozone pollution alert are more and more frequent.
* [__OzoneApp__](http://geraudster.shinyapps.io/ozoneApp) aims to analyze the impact of global warming on Ozone pollution and will help predicting Ozone pollution depending on temperature raise.

We use the _airquality_ dataset provided by R, this dataset contains Daily air quality measurements in New York, May to September 1973.

--- .class #id 

## Dataset

The dataset consists of 154 observations on 6 variables:

* `Ozone`: Mean ozone in parts per billion from 1300 to 1500 hours at Roosevelt Island
* `Solar.R`: Solar radiation in Langleys in the frequency band 4000–7700 Angstroms from 0800 to 1200 hours at Central Park
* `Wind`: Average wind speed in miles per hour at 0700 and 1000 hours at LaGuardia Airport
* `Temp`: Maximum daily temperature in degrees Fahrenheit at La Guardia Airport.

* The following correlation matrix shows that Wind and Temperature have strong correlation with Ozone:

![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-2.png) 


--- .class #id 

## Building the prediction model

Below we compare different linear regression models:

```r
library(caret)
set.seed(123)
models <- list(Temp = train(LogOzone ~ Temp, airquality2, method = 'lm'),
               'Temp + Wind' = train(LogOzone ~ Temp + Wind, airquality2, method = 'lm'),
               'Temp + Wind + Solar.R' = train(LogOzone ~ Temp + Wind + Solar.R, airquality2, method = 'lm'))
bwplot(resamples(models))
```

![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-3.png) 

We chose the third (`Temp + Wind + Solar.R`), which has lower RMSE and greater R^2.

--- .class #id 

## How to use / limitations

* Just go to [__OzoneApp__](http://geraudster.shinyapps.io/ozoneApp) and follow the instructions
* Some limitations:
  + __OzoneApp__ uses a small dataset containing only 6 month of data collected in 1973
  + So the next steps will be to use more recent data to have more precise model
  + Also, another step would be to mix Air Quality data with other kind of data like weather, traffic ,..

* Credits for logo : 
"Ozongassmolekyl" by Ingvald Straume - Own work. Licensed under CC BY-SA 3.0 via Wikimedia Commons - http://commons.wikimedia.org/wiki/File:Ozongassmolekyl.png#mediaviewer/File:Ozongassmolekyl.png
