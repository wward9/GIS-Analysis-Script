##############################################################################################
############                 Address from Lat Long                            ################
##############################################################################################

#Set function with a 
revgeocodedf <- function(key, lat, long){
  
require(ggmap)
result <- do.call(rbind,
                  lapply(1:length(lat),
                         function(i)revgeocode(as.numeric(c(long[i],lat[i])))))
as.data.frame(cbind(key,lat,long,result))

}
 