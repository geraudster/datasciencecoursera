library(ggplot2)
library(RColorBrewer)
library(reshape2)
library(mice)
library(plyr)
data(airquality)
# Impute missing values
imputed <- mice(airquality, m = 1)
airquality$Solar.R[is.na(airquality$Solar.R)] <- imputed$imp$Solar.R[[1]]
airquality$Ozone[is.na(airquality$Ozone)] <- imputed$imp$Ozone[[1]]

shinyServer(
  function(input, output) {
    output$correl <- renderPlot({
      variable <- input$variable
      outcome <- 'Ozone'
      color <- input$color
      qplot(get(variable), log(get(outcome)),
            data = airquality,
            xlab = variable,
            ylab = outcome,
            col = get(color)) +
        stat_smooth(method="lm", formula = y ~ x) +
        scale_colour_gradientn(name = color, colours=rev(brewer.pal(4, 'RdYlGn')))
    })
    output$intercept <- renderTable({
      variable <- input$variable
      outcome <- 'Ozone'
      color <- input$color
      model <- lm(log(get(outcome)) ~ get(variable), airquality)
      model.summary <- summary(model)
      data.frame(Intercept = coef(model.summary)[1],
                 Slope = coef(model.summary)[2],
                 P = signif(coef(model.summary)[2,4],5),
                 R2 = model.summary$r.squared)
    })
    
    model.reactive <- reactive({
      temp.diff <- input$temp.diff
      result <- list()
      result$model <- lm(log(Ozone) ~ Temp + Temp * Wind + Solar.R, airquality)
      result$predictions <- predict(result$model, data.frame( Temp = airquality$Temp + temp.diff,
                                                              Wind = airquality$Wind,
                                                              Solar.R = airquality$Solar.R))
      airquality$Predictions <- result$predictions
      airquality$LogOzone <- log(airquality$Ozone)
      
      result$melt <- melt(airquality[, c('Month', 'Day',
                                         'LogOzone', 'Predictions')],
                          id=c('Month', 'Day'))
      result$means <- ddply(result$melt, 'variable', summarise, variable.mean=mean(value))
      result
    })
    
    output$ts <- renderPlot({
      temp.diff <- input$temp.diff
      model.full <- model.reactive()
      
      model <- model.full$model
      predictions <- model.full$predictions
      means <- model.full$means
      
      ggplot(model.full$melt,
             aes(x=value, fill = variable)) +
        geom_histogram(binwidth=.25, alpha=.5, position="identity") +
        geom_vline(data = means, aes(xintercept=variable.mean, color=variable),   # Ignore NA values for mean
                   linetype="dashed", size=1) +
        ggtitle(paste0('Ozone prediction for +', temp.diff, '°F temperature raise')) +
        scale_y_continuous(limits = c(0, 30)) +
        scale_x_continuous(limits = c(0, 8)) +
        xlab('Log(Ozone)') +
        ylab('Numbers of day') +
        guides(fill = guide_legend(title=NULL))
    })
    
    output$means <- renderText({
      model.full <- model.reactive()
      paste0('The expected raise of Ozone in ppb will be ',
             round(exp(model.full$means[2,2]) - exp(model.full$means[1,2]), 2))
    })
  }
)

# model <- lm(Ozone ~ Temp, airquality)
# model.summary <- summary(model)
# qplot(Temp, Ozone,
#       data = airquality,
#       xlab = 'Temp',
#       ylab = 'Ozone',
#       col = Temp) +
#   stat_smooth(method="lm") +
#   scale_colour_gradientn(name = 'Temp', colours=rev(brewer.pal(4, 'RdYlGn'))) +
#   geom_text(aes(x = 2, y = 10, label = paste('Intercept:', coef(model.summary)[1])), hjust = 0) +
#   geom_text(aes(x = 2, y = 9.5, label = 'Todo'), hjust = 0, parse = TRUE )

# ggplot(airquality.melt[airquality.melt$variable %in% c('Ozone', 'Predictions'),],
#        aes(x=paste0(Month, Day), y=value, group=1, color = variable)) +
#   geom_bar(stat="identity", position = "dodge")
# 
# ggplot(dfbound,
#        aes(x=paste0(Month, Day), y=Rollpredictions - RollOzone, group=1)) +
#   geom_bar(stat="identity")
#     })
