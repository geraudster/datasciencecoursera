library(ggplot2)
library(RColorBrewer)
data(airquality)

shinyServer(
    function(input, output) {
        output$correl <- renderPlot({
            variable <- input$variable
            outcome <- input$outcome
            color <- input$color
            qplot(get(variable), get(outcome),
                  data = airquality,
                  xlab = variable,
                  ylab = outcome,
                  col = get(color)) +
                stat_smooth(method="lm", formula = y ~ poly(x, 2)) +
                scale_colour_gradientn(name = color, colours=rev(brewer.pal(4, 'RdYlGn')))
        })
        
    }
)