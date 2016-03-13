# shiny
shinyUI(
  fluidPage(
    titlePanel("Police Related Deaths in the U.S. in 2015"),
    
    selectInput("var",
                label = "Choose a variable to display",
                choices = c("Black population (%)", "Median income ($)"),
                selected = "Black population (%)"),
    plotOutput("map", width = 950)
  )
)