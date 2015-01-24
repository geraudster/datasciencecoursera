library(markdown)
shinyUI(
  navbarPage('Ozone pollution',
             tabPanel('About',
                      includeMarkdown('about.md')),
             tabPanel('Explore data',
                      sidebarLayout(
                        sidebarPanel(
                          selectInput('variable', 'Choose your variable', 
                                      choices = c('Solar.R', 'Wind', 'Temp'),
                                      selected = 'Solar.R'),
                          selectInput('color', 'Coloured by',
                                      choices = c('Ozone', 'Solar.R', 'Wind', 'Temp', 'Month', 'Day'),
                                      selected = 'Temp'),
                          helpText('Selecting a variable will draw the scatter plot against Ozone measurement and show the regression line that fits the data')
                        ),
                        mainPanel(
                          plotOutput('correl'),
                          tableOutput('intercept')
                        )
                      )),
             tabPanel('Predict',
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput('temp.diff', 'Temperature raise', 0, 10, 0, step = 0.5)
                        ),
                        mainPanel(
                          plotOutput('ts')))),
             header = wellPanel(includeMarkdown('intro.md'))))