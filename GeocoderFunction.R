inputfile <- "input/Walmart.csv"
outputfile <- "output/Walmart.csv"

#Install package
#devtools::install_github("gsk3/taRifx.geo")
setwd("C:/Users/wward/Documents/R/R Automation/MappingRCode")

#Read in intput file
inputfile <- read.csv(inputfile)

#Load package
require(taRifx.geo)

#Specify API Key
options(BingMapsKey='4vN5i7NOCAdYdCCvNd5J~BsrfspiO64LJg1i65T_imw~AuabdtbMdct5_2GPGZbjcdLLiAjbC1sWGMjPjtnO-1_1mls7ULPG-Js-EJ5EG_RZ')

#Geocode coordinates (change addresscol to reference the coloumn you need geocoded)
output <- geocode(inputfile, service="bing", returntype = "coordinates",
        addresscol = "Full.Address")

#Wrtie outputfile
write.csv(output, outputfile)
