##############################################################################################
##############################################################################################
############      Function that Creates distance matrix from Lat and Long     ################
##############################################################################################
##############################################################################################

MarketCluster <- function(data, StoreID, lat, long, dist, method="complete")
  {
 
require(cluster)
dat <- data[,c(StoreID,lat,long)]
colnames(dat) <- c("StoreID", "lat", "long")

#Creates
ReplaceLowerOrUpperTriangle <- function(m, triangle.to.replace){
  # If triangle.to.replace="lower", replaces the lower triangle of a square matrix with its upper triangle.
  # If triangle.to.replace="upper", replaces the upper triangle of a square matrix with its lower triangle.
  
  if (nrow(m) != ncol(m)) stop("Supplied matrix must be square.")
  if      (tolower(triangle.to.replace) == "lower") tri <- lower.tri(m)
  else if (tolower(triangle.to.replace) == "upper") tri <- upper.tri(m)
  else stop("triangle.to.replace must be set to 'lower' or 'upper'.")
  m[tri] <- t(m)[tri]
  return(m)
}

GeoDistanceInMetresMatrix <- function(df.geopoints){
  # Returns a matrix (M) of distances between geographic points.
  # M[i,j] = M[j,i] = Distance between (df.geopoints$lat[i], df.geopoints$lon[i]) and
  # (df.geopoints$lat[j], df.geopoints$long[j]).
  # The row and column names are given by df.geopoints$name.
  
  GeoDistanceInMetres <- function(g1, g2){
    # Returns a vector of distances. (But if g1$index > g2$index, returns zero.)
    # The 1st value in the returned vector is the distance between g1[[1]] and g2[[1]].
    # The 2nd value in the returned vector is the distance between g1[[2]] and g2[[2]]. Etc.
    # Each g1[[x]] or g2[[x]] must be a list with named elements "index", "lat" and "lon".
    # E.g. g1 <- list(list("index"=1, "lat"=12.1, "lon"=10.1), list("index"=3, "lat"=12.1, "lon"=13.2))
    DistM <- function(g1, g2){
      require("Imap")
      return(ifelse(g1$StoreID > g2$StoreID, 0, gdist(lat.1=g1$lat, lon.1=g1$long, lat.2=g2$lat, lon.2=g2$long, units="m")))
    }
    return(mapply(DistM, g1, g2))
  }
  n.geopoints <- nrow(df.geopoints)
  
  # The index column is used to ensure we only do calculations for the upper triangle of points
  df.geopoints$index <- 1:n.geopoints
  
  # Create a list of lists
  list.geopoints <- by(df.geopoints[,c("StoreID", "lat", "long")], 1:n.geopoints, function(x){return(list(x))})
  
  # Get a matrix of distances (in metres)
  mat.distances <- ReplaceLowerOrUpperTriangle(outer(list.geopoints, list.geopoints, GeoDistanceInMetres), "lower")
  
  # Set the row and column names
  rownames(mat.distances) <- df.geopoints$name
  colnames(mat.distances) <- df.geopoints$name
  
  return(mat.distances)
}

##############################################################################################
##############################################################################################
############             Turns store data into distance matrix by Mile        ################
##############################################################################################
##############################################################################################

dmatrix <- (GeoDistanceInMetresMatrix(dat) / 1609.34)# creates large matrix with distance in miles between every combination of stores

##############################################################################################
##############################################################################################
############                          Clustering Based on distance                        ################
##############################################################################################
##############################################################################################

#Clusters data using hier methods based off of distance matrix
#Uses complete linkage method which defines the distance between clusters as the distance between the two furthest points
clus <- agnes(dmatrix,
                   stand = FALSE,diss = TRUE, method = method, keep.diss=TRUE, trace.lev = 0)
clus <- as.hclust(clus)

plot(clus, ylab = "Distance(Miles)")

dat$MarketID <- cutree(clus, h = dist)
}


