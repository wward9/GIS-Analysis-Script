#############################################
######### Fuzzy Address Match ###############
#############################################

#Requires 4 vectors: key1, string1, key2, string2
#key1 and string1 must be the same length along with key2 and string2
fuzzystrmatch <- function(key1, string1, key2, string2)
{
  
  #convert all characters to lower case
  string1 <- sapply(string1, tolower)
  string2 <- sapply(string2, tolower)
  
  #Creates distance matrix based on generalized Levenshtein distance
  dist.name <- adist(string1, string2, partial = TRUE, ignore.case = TRUE)
  
  #creates a vector from minimum row values of the dist.name matrix above
  min.name <- apply(dist.name, 1, min)
  
  #Inserts matches into a new matrix
  matchlist <- NULL  
  for (i in 1:nrow(dist.name)) {
    s2.i <- match(min.name[i],dist.name[i,])
    s1.i <- i
    matchlist <- rbind(data.frame(key1 = key1[s1.i], key2 = key2[s2.i],s1.i = s1.i, s2.i = s2.i, list1name = string1[s1.i], list2name = string2[s2.i], adist = min.name[i]),matchlist)
  }
  #Sorts by order of orginal list
  matchlist <- matchlist[order(matchlist$s1.i,decreasing = FALSE),]
  
}