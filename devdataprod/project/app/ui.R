shinyUI(pageWithSidebar(
    headerPanel("Example plot"),
    sidebarPanel(
#        sliderInput('mu', 'Guess at the mu',value = 70, min = 60, max = 80, step = 0.05,)
        selectInput('variable', 'Variable', 
                    choices = c('Ozone', 'Solar.R', 'Wind', 'Temp', 'Month', 'Day'),
                    selected = 'Solar.R'),
        selectInput('outcome', 'Outcome',
                    choices = c('Ozone', 'Solar.R', 'Wind', 'Temp', 'Month', 'Day')),
        selectInput('color', 'Coloured by',
                    choices = c('Ozone', 'Solar.R', 'Wind', 'Temp', 'Month', 'Day'),
                    selected = 'Temp')
    ),
    mainPanel(
        plotOutput('correl')
    )
))