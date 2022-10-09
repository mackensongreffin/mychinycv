library(shiny)
library(shinyWidgets)
library(htmltools)
library(viridis)
library(shinyjs)
library(leaflet)
library(readr)
library(dplyr)


titre=tags$a(href="https://www.cerema.fr",tags$img(src="Image1.png",height='50',width='100'))
source("www/create_map.R")
source("www/read_od_matrix.R")
jsfile="swoopy.js"


a=list(tags$head(tags$style()), HTML('<img src="me.jpg", height="500px"
                                   style="float:right"/>','<p style="color:black"></p>'))
js <- '
$(document).on("shiny:connected", function(){
  $("#map").css({
    width: window.innerWidth, 
    height: window.innerHeight
  });
  $(window).on("resize", function(e){
    if(e.target instanceof Window){
      $("#map").css({width: window.innerWidth, height: window.innerHeight});
    }
  });
})
'



   
bootstrapPage(
    tags$head(tags$script(src = jsfile)),
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")),
    tags$head(
      tags$style(HTML("html,body {margin: 0; overflow: hidden;}")),
      tags$style(HTML("#controls::-webkit-scrollbar {display: none;}")),
      tags$style(HTML("#condrols {-ms-overflow-style: none;scrollbar-width: none;}")),
      tags$script(HTML(js))),
    leafletOutput("map"),
    absolutePanel(id = "controls",
                  class = "panel panel-default",
                  fixed = FALSE,
                  draggable = FALSE, top = 0, left = 0,
                  width =500,
                  height = "100%",
                  style="overflow-y: auto;",
                  a,
                  column(12,
                  h3( HTML("<b>Ingénieur en études de la mobilité et Data Scientist<b>" )),
                  tags$ul(h4(HTML("<b>Mes expériences : <b>")),
                          h4(a(icon("car"),"2020-2023 : Cerema-Chargé d'études connaissance de la mobilité et technologies du numérique",style = 'color:black;text-decoration: none;')),
                          h4(a(icon("camera"),"2020 : Explain-stage de 6 mois : développement d'une application de comptage directionnel de véhicules et usagers par traitement d'images (YOLO4, Deepsort)",style = 'color:black;text-decoration: none;')),
                          h4(a(icon("building"),"2019 : Travaux de Fin d'Etudes d'école d'ingénieur : modélisation du choix de localisation des entreprises autour des QPV (choix discrets et modèle de survie)",style = 'color:black;text-decoration: none;')),
                          h4(a(icon("bicycle"),"2018 : University of British Columbia, stage de 6 mois : developpement d'un algorithme de map-matching pour traiter des données de cyclistes de la ville de Vancouver ",style = 'color:black;text-decoration: none;')),
                          h4(a(icon("plane"),"2017 : Aéroports de Lyon : stage ouvrier d'un mois, équipe des moyens généraux",style = 'color:black;text-decoration: none;'))),
                  br(),
                  tags$ul(h4(HTML("<b>Mes formations : <b>")),
                          h4(a(icon("graduation-cap"),"2019-2020 : Master 2 SISE (Statistique et InformatiquE pour la Science des donnEs),Université Lumière Lyon II",style = 'color:black;text-decoration: none;')),
                          h4(a(icon("graduation-cap"),"2017-2019 : Diplôme d'ingénieur de l'ENTPE, spécalisation : économie des transports",style = 'color:black;text-decoration: none;'))),
                  br(),
                  tags$ul(h4(HTML("<b>Mes centres d'intéret : <b>")),
                          h4(a(icon("hand-holding-heart"),"Escalade en bloc ,peinture, dessin",style='color:black;text-decoration: none;')))))
  
)

      


          