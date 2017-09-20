#Install package
#devtools::install_github("gsk3/taRifx.geo")

#Load package
require(taRifx.geo)

#Set working directory
setwd("C:/Users/wward/Documents/R/Example Files")

#Set input and output files
inputfile <- "Test_Store_List.csv" #Update with your input file
outputfile <- "Test_Store_Listout.csv" #update with your output file

#Read in intput file
inputfile <- read.csv(inputfile)
inputfile$Full.Address <- paste(inputfile$Address," ", inputfile$City, ", ", inputfile$State, " ", inputfile$ZIP) #Create Full.Address column

#Specify API Key
options(BingMapsKey='4vN5i7NOCAdYdCCvNd5J~BsrfspiO64LJg1i65T_imw~AuabdtbMdct5_2GPGZbjcdLLiAjbC1sWGMjPjtnO-1_1mls7ULPG-Js-EJ5EG_RZ')

#Geocode coordinates (change addresscol to reference the coloumn you need geocoded)
output <- geocode(inputfile, service="bing", returntype = "coordinates",
        addresscol = "Full.Address")

#Wrtie outputfile
write.csv(output, outputfile)
