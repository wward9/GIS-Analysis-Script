#############################################
######### Fuzzy Address Match ###############
#############################################

#Set your working directory
setwd("C:/Users/wward/Documents/R/R Automation/MappingRCode/input")

#Load list path
#Output will match against all rows in list1

list1 <- "Book1.csv"
list2 <- "Book2.csv"  
outputfile <- "matchaddress.csv"

#Load data from csv files
list1 <- read.csv(list1)
list2 <- read.csv(list2)

#Assign Key Values
key1 <- list1$Mall.Name
key2 <- list2$Address

#Concat all lists as one string change column names as needed
list1$full.address <- paste(list1$Address)
list2$full.address <- paste(list2$Address," ,", list2$City,", ",list2$Province)

#convert all characters to lower case
list1$full.address <- sapply(list1$full.address, tolower)
list2$full.address <- sapply(list2$full.address, tolower)

#Creates distance matrix based on generalized Levenshtein distance
dist.name <- adist(list1$full.address,list2$full.address, partial = TRUE, ignore.case = TRUE)

#creates a vector from minimum row values of the dist.name matrix above
min.name <- apply(dist.name, 1, min)

#Inserts matches into a new matrix
match.s1.s2 <- NULL  
for (i in 1:nrow(dist.name)) {
  s2.i <- match(min.name[i],dist.name[i,])
  s1.i <- i
  match.s1.s2 <- rbind(data.frame(key1 = key1[s1.i], key2 = key2[s2.i], s2.i = s2.i,s1.i = s1.i,list2name = list2[s2.i,]$full.address, list1name = list1[s1.i,]$full.address, adist = min.name[i]),match.s1.s2)
}
rm(dist.name, list1, list2, min.name)
 
#Sorts by order of orginal list
match.s1.s2 <- match.s1.s2[order(match.s1.s2$s1.i,decreasing = FALSE),]

#Write matched list to a csv
write.csv(match.s1.s2, outputfile)
