# load library and data
library(shiny)
library(plyr)
library(maps)
library(ggplot2)
library(R.utils)

# create map
map <- map_data("county")
map <- rename(map, replace=c("region"="state", "subregion"="county"))
# capitalize entries
map$county <- capitalize(map$county)
map$state <- capitalize(map$state)
# subset out AK and HI (only continental U.S.)
death <- subset(death,  ! state %in% c("HI", "AK"))
# merge datasets
map <- join(map, census, by = c("county", "state"))

# shiny app
shinyServer(
function(input,output){
  # render plot output
  output$map <- renderPlot({
    
    # create input variables 
    map$vars <- switch(input$var,
                       "Black population (%)" = map$blackPopPercent,
                       "Median income ($)" = map$medianIncome)
    
    # open ggplot
    ggplot() +
      # fill polygons based on latitude and longitude
      geom_polygon(data = map, aes(x = long, y = lat, group = group, fill = vars)) +
      # create points for each recorded death
      geom_point(data = death, aes(x = long, y = lat), color = "red", size = 2) +
      # alter theme
      # no axis lines or text
      theme(axis.line = element_blank(), axis.text.x=element_blank(),
            axis.text.y=element_blank(), axis.ticks=element_blank(),
            axis.title.x=element_blank(), axis.title.y=element_blank(),
            # remove panel background
            panel.background=element_blank(), panel.border=element_blank(),
            panel.grid.major=element_blank(), panel.grid.minor=element_blank(),
            plot.background=element_blank()) +
      # generate scale fill to fill polygons
      scale_fill_continuous(guide = guide_legend(title = " ",
                            title.position = "left",label.position = "bottom"),
                            low="grey80", high="grey10")
    
    # determine height of map output
  }, height = 550)
})