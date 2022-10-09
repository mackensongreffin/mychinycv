
create_map=function(carte,type_representation,type_representation_2,opacity,opacity_line,arriere_plan,etiquette,legende,titre_legende,add_graphic=F,var_add_graphic=NULL,var_taille_graphic="uniforme",coef_taille_graphique=1,palette=NULL,taille_etiquette=10,palette_graphic=NULL){
  #print(arriere_plan)
  print(type_representation_2)
  if(palette_graphic %in% c("viridis","magma","inferno","plasma","cividis")){palette_graphic_=viridis_pal(option = palette_graphic)(15)}
  else if(palette_graphic %in% c("Blues","Reds","Paired","plasma","Set1")){palette_graphic_=brewer_pal(palette=palette_graphic)(10)}
  
  # if(palette %in% c("viridis","magma","inferno","plasma","cividis")){palette_=viridis_pal(option = palette_graphic)(15)}
  # else if(palette%in% c("Blues","Reds","Paired","plasma","Set1")){palette_=brewer_pal(palette=palette_graphic)(10)}
  

  
  
  

  if (type_representation=="degrade" & type_representation_2 %in% colnames(carte@data) ){a=leaflet(carte) %>%addPolygons(color = "#444444", weight = opacity_line, smoothFactor = 0.5,opacity =1.0 ,
                                                                                                                                            fillOpacity = opacity,
                                                                                                                                            fillColor = ~leaflet::colorNumeric(palette,domain = carte@data[,type_representation_2])(carte@data[,type_representation_2]),
                                                                                                                                            highlightOptions = highlightOptions(color = "white", weight = 2,bringToFront = TRUE))}


  else if (type_representation=="classe" & type_representation_2 %in% colnames(carte@data)){a= leaflet(carte) %>%addPolygons(

    fillColor=~colorFactor(palette = palette,domain = carte@data[,type_representation_2])(carte@data[,type_representation_2]),
    col="#444444",
    weight = opacity_line,
    smoothFactor =1,
    opacity =1,
    fillOpacity = opacity,
    highlightOptions = highlightOptions(color = "white", weight = 2,bringToFront = TRUE))}


  else {a=leaflet(carte) %>%addPolygons(fillColor = type_representation_2,
                                          col="#444444",weight =opacity_line,
                                          smoothFactor =1,opacity =1, fillOpacity = opacity,
                                          highlightOptions = highlightOptions(color = "white", weight = opacity_line,bringToFront = F)) }

  if(arriere_plan){a=a%>%addTiles()}
  else{a=a%>% setMapWidgetStyle(list(background= "white"))}

  if(etiquette!="aucune"){a=a%>%addLabelOnlyMarkers(~carte@data$long, ~carte@data$lat, label =  ~as.character(carte@data[,etiquette]),labelOptions = labelOptions(noHide = T, direction = 'top', textOnly = T,textsize = paste(taille_etiquette,"px",sep="")))}

  
  if(legende & type_representation=="degrade"){
    a=a%>% addLegend("topleft",
                     #pal = leaflet::colorNumeric("YlOrRd",domain = carte@data[,type_representation2]),
                     pal = leaflet::colorNumeric(palette,domain = carte@data[,type_representation_2]),
                     values = ~carte@data[,type_representation_2],
                     title =titre_legende,
                     labFormat = labelFormat(prefix = ""),
                     opacity = 1
    )}


  else if (legende & type_representation=="classe"){
    a=a%>% addLegend("topleft",
                     pal = colorFactor(palette = palette,domain = carte@data[,type_representation_2]),
                     values = ~carte@data[,type_representation_2],
                     title =titre_legende,
                     labFormat = labelFormat(prefix = ""),
                     opacity = 1
    )}

  
  if(add_graphic & !is.null(var_add_graphic) & var_taille_graphic=="uniforme"){
    a=a%>%addMinicharts(
      
        carte@data$long, carte@data$lat,
        type = "pie",
        chartdata = carte@data[,var_add_graphic ],
        legendPosition="bottomleft",
        colorPalette=palette_graphic_,
        width = coef_taille_graphique *50
        )
  }
  
  else if(add_graphic & !is.null(var_add_graphic) & var_taille_graphic!="uniforme"){
    #print(0.00001*coef_taille_graphique * abs(carte@data[,var_taille_graphic]))
    a=a%>%addMinicharts(
      
      carte@data$long, carte@data$lat,
      type = "pie",
      chartdata = carte@data[,var_add_graphic ],
      legendPosition="bottomleft",
      colorPalette=palette_graphic_,
      width = coef_taille_graphique *100* (abs(carte@data[,var_taille_graphic])/max(carte@data[,var_taille_graphic]))
    )}
    
  
  #b=leaflet()  %>% addTiles() %>%onRender(g(flux3)) 
  a=a%>%onRender(g(flux3)) 

  return(a)
}





spread_data=function(data,ID){

  if(ncol(data)<=2){df=data}
  
  else{
    char_var=colnames(data)[-length(colnames(data))]
    index=which(char_var==ID)
    char_var=char_var[-index]
    
    values=colnames(data)[length(colnames(data))]
    
    df=pivot_wider(data,names_from = char_var, values_from = values)
    df[is.na(df)]=0


    new_names=function(nom_ini,vec){
      nom_ini=strsplit(nom_ini,split="_")[[1]]
      nom_ini=paste(vec,nom_ini,sep=".")
      nom_ini=paste(nom_ini,collapse="_")
      return(nom_ini)}
    
    colnames(df)[2:ncol(df)]=sapply(colnames(df)[-1],new_names,vec=char_var)
    colnames(df)[1]=ID
    
    df=data.frame(df)}
  
    return(df)}




ma_jolie_carte=function(){
  m=leaflet() %>% setView(lng = 2.336753053480731, lat = 48.86351731573684, zoom = 5)%>% addProviderTiles(providers$CartoDB.DarkMatter)
  return(m)

}


join_table_data_to_map_data=function(map_data,ID_map_data,table_data,ID_table_data){
  table_data=spread_data(table_data,ID_table_data)
  vec=c(ID_table_data)
  names(vec)=ID_map_data
  return(map_data %>% left_join(table_data, by =vec ))
}


#"C:/Users/mackenson.greffin/Box/Dossier Personnel de Mackenson GREFFIN/Fluo/epinal"
l_path=function(path){
  vec_path1=list.files(path=path, pattern=".shp", all.files=TRUE,full.names=TRUE)

    read_map=function(path){
    map= readOGR(path,layer = gsub('.{4}$', '',strsplit(path,split='/',fixed=T)[[1]][length(strsplit(path,split='/',fixed=T)[[1]])]))
    map@data[,c("long","lat")]=coordinates(map)
    return(map)
  }
  
  L=lapply(vec_path1, read_map)
  names(L)=gsub(".shp","",list.files(path=path, pattern=".shp", all.files=TRUE,full.names=FALSE))
  
  #return(vec_path)
}


