#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#



icon1 = makeIcon(
  iconUrl = "diplome.png",
  iconWidth = 64, iconHeight = 64,
  iconAnchorX = 0, iconAnchorY = 0,
  shadowUrl = NULL,
  shadowWidth = 0, shadowHeight = 0,
  shadowAnchorX = 0, shadowAnchorY = 0
)

icon2 = makeIcon(
  iconUrl = "ubc.png",
  iconWidth = 64, iconHeight = 64,
  iconAnchorX = 0, iconAnchorY = 50,
  shadowUrl = NULL,
  shadowWidth = 0, shadowHeight = 0,
  shadowAnchorX = 0, shadowAnchorY = 0
)

icon3 = makeIcon(
  iconUrl = "cerema.png",
  iconWidth = 64, iconHeight = 64,
  iconAnchorX = 0, iconAnchorY = 50,
  shadowUrl = NULL,
  shadowWidth = 0, shadowHeight = 0,
  shadowAnchorX = 0, shadowAnchorY = 0
)


flux2 <- read_delim("data/flux2.csv", ";", escape_double = FALSE, trim_ws = TRUE)
villes <- read_delim("data/villes.csv", ";",escape_double = FALSE, locale = locale(encoding = "WINDOWS-1252"), trim_ws = TRUE)

server = function(input, output,session) {
  output$map=leaflet::renderLeaflet(
    leaflet::leaflet()%>%addProviderTiles(providers$CartoDB.Positron,options = providerTileOptions(noWrap = TRUE))%>%
      setView(lng =-113.30022267233267 , lat =49.15740833452629, zoom = 03)%>%
      addMarkers(data=villes[3,3:4], 
                 label =HTML(
                   "<p>Intégration de l'ENTPE- 2016<p>
                  
                  <p>Diplôme d'ingénieur de l'ENTPE - 2019<p>
                  
                  <p>Diplôme DataScience Université Lumière Lyon II - 2020 <p>"),
                 
                 icon=~icon1
    )%>%addMarkers(data=villes[4,3:4], 
                     label = HTML("<p>Deuxième année d'école d'ingénieur - 2018 <p>
                    <p>Stage de 6 mois au ReactLAB <p>"),
                     icon=icon2
    )%>%addCircleMarkers(data=villes[1,3:4], 
                     label = "Enfance",
                     opacity = 0,
                     fillOpacity = 0
    )%>%addCircleMarkers(data=villes[2,3:4], 
                     label = HTML("<p>Collège,Lycée <p><p> Classes Préparatoires aux Grandes Ecoles : 2014-2016 <p>"),
                     opacity = 0,
                     fillOpacity = 0
    )%>%addMarkers(data=villes[5,3:4], 
                     icon=icon3,
                     label = HTML("<p>Chargé d'études connaissance de la mobilité et technologies du numérique : 2020-2023<p>")
    )%>%htmlwidgets::onRender(g(flux2))%>%htmlwidgets::onRender("function(el, x){
                                                                                                                 var stripes = new L.StripePattern({options});
                                                                                                                 stripes.addTo(this);
                                                                                                                 var shape = new L.PatternRect({
                                                                                                                   width: 40,
                                                                                                                   height: 40,
                                                                                                                   rx: 10,
                                                                                                                   ry: 10,
                                                                                                                   fill: true
                                                                                                                 });
                                                                                                                 
                                                                                                                 var pattern = new L.Pattern({width:50, height:50});
                                                                                                                 pattern.addShape(shape);
                                                                                                                 pattern.addTo(this);
                                                                                                                 
                                                                                                                 var mapCenter = new L.LatLng(50.68, -120.34);
                                                                                                                 var circle = new L.Circle(mapCenter, 400.0, {
                                                                                                                 fillPattern: pattern,
                                                                                                                 fillOpacity: 1.0});
                                                                                                                 circle.addTo(this);
                                                                                                                 
                                                                                                                 
                                                                                                                 }")
    
    
  )
  
  
}






