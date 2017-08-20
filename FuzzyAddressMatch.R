#############################################
######### Fuzzy Address Match ###############
#############################################

#Requires 4 vectors: key1, string1, key2, string2
#key1 and string1 must be the same length along with key2 and string2
fuzzystrmatch <- function(key1, string1, key2, string2)
{
	
#convert all characters to lower case
list1$string1 <- sapply(list1$string1, tolower)
list2$string2 <- sapply(list2$string2, tolower)

#Creates distance matrix based on generalized Levenshtein distance
dist.name <- adist(list1$string1,list2$string, partial = TRUE, ignore.case = TRUE)

#creates a vector from minimum row values of the dist.name matrix above
min.name <- apply(dist.name, 1, min)

#Inserts matches into a new matrix
match.s1.s2 <- NULL  
for (i in 1:nrow(dist.name)) {
  s2.i <- match(min.name[i],dist.name[i,])
  s1.i <- i
  matchlist <- rbind(data.frame(key1 = key1[s1.i], key2 = key2[s2.i],s1.i = s1.i, s2.i = s2.i, list1name = list1[s1.i,]$string1,list2name = list2[s2.i,]$string2, adist = min.name[i]),match.s1.s2)
}
rm(dist.name, list1, list2, min.name)
 
#Sorts by order of orginal list
matchlist <- matchlist[order(match.s1.s2$s1.i,decreasing = FALSE),]

}