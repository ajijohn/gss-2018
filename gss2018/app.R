#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(htmltools)
library(htmlwidgets)
library(raster)
#library(virtualspecies)


# Define UI for application that draws a histogram
ui <- fluidPage(
   
  leafletOutput('myMap')
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  r <- raster(xmn=-2.8, xmx=-2.79, ymn=54.04, ymx=54.05, nrows=30, ncols=30)
  values(r) <- matrix(1:900, nrow(r), ncol(r), byrow = TRUE)
  crs(r) <- CRS("+init=epsg:4326")
  
  worldclim <- getData("worldclim", var = "bio", res = 2.5)
  
  map =  leaflet() %>%
    addProviderTiles(providers$Esri.WorldStreetMap) %>%
    addMiniMap(tiles = providers$Esri.WorldStreetMap,
               toggleDisplay = TRUE) %>% 
      addEasyButton(easyButton(
      icon="fa-globe", title="Zoom to Level 1",
      onClick=JS("function(btn, map)
                {
                 map.setZoom(1); 
                 }"))) %>%
    addEasyButton(easyButton(
      icon="fa-crosshairs", title="Locate Me",
      onClick=JS("function(btn, map){ map.locate({setView: true}); }")))    %>%
    setView(-122.36, 47.67, zoom = 10) %>%
    htmlwidgets::onRender("
    function(el, x) {
      var myMap = this;
      myMap.on('moveend',
        function (e) {
          alert('changed')

        })
    }")%>%
    addRasterImage(r, colors = "Spectral", opacity = 0.8)
  
  output$myMap = renderLeaflet(map)
}

# Run the application 
shinyApp(ui = ui, server = server)

