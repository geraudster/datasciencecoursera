shinyUI(pageWithSidebar(
    headerPanel("Example plot"),
    sidebarPanel(
#        sliderInput('mu', 'Guess at the mu',value = 70, min = 60, max = 80, step = 0.05,)
        selectInput('var1', 'First variable', 
                    choices = c('Ozone', 'Solar.R', 'Wind', 'Temp', 'Month', 'Day')),
        selectInput('var2', 'Second variable',
                    choices = c('Ozone', 'Solar.R', 'Wind', 'Temp', 'Month', 'Day')),
        selectInput('color', 'Coloured by',
                    choices = c('Ozone', 'Solar.R', 'Wind', 'Temp', 'Month', 'Day'))
    ),
    mainPanel(
        plotOutput('correl')
    )
))