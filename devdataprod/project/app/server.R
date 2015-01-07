library(ggplot2)
data(airquality)

shinyServer(
    function(input, output) {
        output$correl <- renderPlot({
            var1 <- input$var1
            var2 <- input$var2
            color <- input$color
            qplot(get(var1), get(var2),
                  data = airquality,
                  xlab = var1,
                  ylab = var2,
                  col = get(color)) +
                geom_abline() +
                scale_colour_gradientn(colours=rainbow(4))
        })
        
    }
)