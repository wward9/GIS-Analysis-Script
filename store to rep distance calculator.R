setwd("C:/Users/wward/Documents/R/R Automation/MappingRCode")

inputfile1 <- "input/Book2.csv"  ## file should be three columns: storeid, lat1, long1. storeid needs to be unique
inputfile2 <- "input/RepList.csv"    ## file should be three columns: repid, lat2, long2. repid needs to be unique
dist <- 20                        ## filter the distance matrix to only combinations within dist miles
Outputfile <- "output/MarketMatching.csv"


list1 <- read.csv(inputfile1,header=TRUE,sep=",",row.names=NULL) 

list2 <- read.csv(inputfile2,header=TRUE,sep=",",row.names=NULL) 

combinedlist <- merge(list1, list2, by = NULL) ## creates every combination

deg2rad <- function(deg) return(deg*pi/180) ## converts degrees to radians for distance formula

combinedlist$distance <- acos(cos(deg2rad(90-combinedlist$lat1))*cos(deg2rad(90-combinedlist$lat2))+sin(deg2rad(90-combinedlist$lat1))
                              *sin(deg2rad(90-combinedlist$lat2))*cos(deg2rad(combinedlist$long1-combinedlist$long2)))*3958.756

combinedlistfiltered <- combinedlist[ which(combinedlist$distance <= dist),]
  
#write.csv(combinedlist,Outputfile)

write.csv(combinedlistfiltered,Outputfile)
