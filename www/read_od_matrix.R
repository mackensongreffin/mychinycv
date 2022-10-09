library(viridis)

f=function(ligne){
  texte=paste0("new L.swoopyArrow([",ligne[1],",", ligne[2],"],[",ligne[3],",",ligne[4],"],{label:'',labelFontSize: 1,iconAnchor: [0, 0],weight:", ligne[5],",color:","'",ligne[6],"'",",opacity : 1,factor: 1,arrowFilled: true,keyboard:false,iconSize: [1, 1]}).addTo(this);")
  return(texte)
}


g=function(data){
  data=arrange(data,flux)
  data$couleur=viridis_pal()(nrow(data))
  #data$flux=(data$flux/max(data$flux))*30
  data$flux=10
  print(data)
  paste("function(el, x){",paste(apply(data, 1, f),collapse=""),"}")
  }


h=function(ligne){
  #texte=paste0("{'from':[",ligne[2],",",ligne[1],"],'to':[",ligne[4],",",ligne[3],"],'labels':['',''],'color':'",ligne[6],"',","'value':",ligne[5],"}")                            
  texte=paste0("{'from':[",ligne[2],",",ligne[1],"],'to':[",ligne[4],",",ligne[3],"],'labels':['',''],'color':'",ligne[6],"',","'value':",ligne[5],"}") 
  return(texte)
}


l=function(data){
  data=arrange(data,flux)
  data$couleur=viridis_pal()(nrow(data))
  data$flux=(data$flux/max(data$flux))*50
  texte=paste(apply(data,1,h),collapse=",")
  texte=paste("[",texte,"]")
  
  texte=paste0("function(el, x){var lrmap = this;var data =",texte,";var migrationLayer = new L.migrationLayer({map: lrmap,data: data,pulseRadius:15,pulseBorderWidth:1,arcWidth:20,arcLabel:true,arcLabelFont:'10px sans-serif',maxWidth:10});migrationLayer.addTo(lrmap);}")
  return(texte)
}


