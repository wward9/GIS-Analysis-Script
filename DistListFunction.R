##############################################
######## Distance Between two lists ##########
##############################################

dist.list <- function(key1, lat1, long1, key2, lat2, long2, maxdist){
  
#convert all coordinates to be numeric
 coor <- c(lat1, long1, lat2, long2)
 for(i in 1:4){
   coor[i] <- as.numeric(coor[i])
 }
 
 #Turn inputs from the first and second list into a data frame
list1 <- cbind(key1, lat1, long1) 
list2 <- cbind(key2, lat2, long2)

#create a dataframe that contains every combination of values
combinedlist <- merge(list1, list2, by = NULL)
  
deg2rad <- function(deg) return(deg*pi/180) ## converts degrees to radians for distance formula
  
  combinedlist$distance <- acos(cos(deg2rad(90-combinedlist$lat1))*cos(deg2rad(90-combinedlist$lat2))+sin(deg2rad(90-combinedlist$lat1))
                                *sin(deg2rad(90-combinedlist$lat2))*cos(deg2rad(combinedlist$long1-combinedlist$long2)))*3958.756
  
  combinedlistfiltered <- combinedlist[ which(combinedlist$distance <= dist),]
  
}