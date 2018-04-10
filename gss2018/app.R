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
library(sp)
#library(virtualspecies)
library(RColorBrewer)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
  leafletOutput('myMap')
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
 
  
  tmean_raster <- raster(file.path(getwd(), "wc2/MOD11C1_D_LSTDA_2017-03-27_rgb_3600x1800.TIFF"))
 
  pal <- colorNumeric("RdYlBu", values(tmean_raster), na.color = "transparent")
  
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
          //alert('changed')

        })
    }")%>%
    addRasterImage(tmean_raster, colors = "Spectral", opacity = 0.8) %>%
    addLegend(pal = pal, values = values(tmean_raster), title = "Mean Temp.")
  
  output$myMap = renderLeaflet(map)
}

# Run the application 
shinyApp(ui = ui, server = server)

