library(markdown)
shinyUI(
  navbarPage(div(img(src='Ozongassmolekyl.png', height='21px', width='32px'),
                 'OzoneApp'),
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
                          h3('Basic Linear regression'),
                          plotOutput('correl'),
                          h3('Coefficients'),
                          tableOutput('intercept')
                        )
                      )),
             tabPanel('Predict',
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput('temp.diff', 'Temperature raise', 0, 10, 0, step = 0.5),
                          helpText('Choose the temperature raise in degree Fahrenheit, and see the distribution of Ozone pollution.'),
                          helpText('Ozone values are represented by their log(Ozone) function.')
                        ),
                        mainPanel(
                          plotOutput('ts'),
                          textOutput('means')))),
             header = wellPanel(includeMarkdown('intro.md')),
             footer = p(br(), wellPanel(includeHTML('license.html')))))