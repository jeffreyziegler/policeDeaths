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
# subset out AK and HI
death <- subset(death,  ! state %in% c("HI", "AK"))
# merge datasets
map <- join(map, census, by = c("county", "state"))

# shiny
shinyServer(
function(input,output){
  
  output$map <- renderPlot({
    
    # create input variables 
    map$vars <- switch(input$var,
                       "Black population (%)" = map$blackPopPercent,
                       "Median income ($)" = map$medianIncome)
    
    # plot
    ggplot() + geom_polygon(data = map, aes(x = long, y = lat, group = group, fill = vars)) +
      geom_point(data = death, aes(x = long, y = lat), color = "red", size = 2) +
      theme(axis.line = element_blank(),axis.text.x=element_blank(), axis.text.y=element_blank(), axis.ticks=element_blank(), axis.title.x=element_blank(), axis.title.y=element_blank(), panel.background=element_blank(), panel.border=element_blank(), panel.grid.major=element_blank(), panel.grid.minor=element_blank(), plot.background=element_blank()) +
      scale_fill_continuous(guide = guide_legend(title = " ", title.position = "left", label.position = "bottom"), low="grey80", high="grey10")
    
    
  }, height = 550)
})