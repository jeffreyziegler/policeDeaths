# begin shiny app
shinyUI(
  # start page
  fluidPage(
    # add title to plot
    titlePanel("Police Related Deaths in the U.S. in 2015"),
    # select what variable will overlay on top of the map
    selectInput("var",
                # label the selection box
                label = "Choose a variable to display",
                # choose which variables to include
                choices = c("Black population (%)", "Median income ($)"),
                # set default option
                selected = "Black population (%)"),
    # select object for output with dimensions
    plotOutput("map", width = 950)
  )
)