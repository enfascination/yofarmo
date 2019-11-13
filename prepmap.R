library(sf)
library(readxl)
library(stringr)
library(dplyr)
'%ni%' <- function(x,y)!('%in%'(x,y))
asdf <- as.data.frame

### load base map info
#> Linking to GEOS 3.6.1, GDAL 2.1.3, PROJ 4.9.3
basetracts <- st_read("data/countyPrepped.gpkg")
excludes <- c(
	"UNCULTIVATED AG", 
	"RECREATION AREA", 
	"RIGHTS OF WAY", 
	"N-OUTDR PLANTS", 
	"ORG UNCULTIVATED AG", 
	"N-GRNHS PLANT", 
	"COMM. FUMIGATN", 
	"LANDSCAPE MAIN", 
	"UNCUL NON-AG", 
	"N-GRNHS TRANSPL"
	)

### prep commodity info
agreportingall <- read_xlsx("data/19\ PERM\ 6-11-19.xlsx")
agreportingall$FRSTDIVID_ <- with(agreportingall, paste0("CA210", str_sub(T, 1, 2), "0",  str_sub(T, 3, 3), "0", str_sub(R, 1, 2), "0", str_sub(R, 3, 3), "0SN", str_pad(S, 2, "left", "0"), "0"))

### prep spray data
agreportingspray <- read_xlsx("data/PUR\ 6-11-19.xlsx")
agreportingspray$FRSTDIVID_ <- with(agreportingspray, paste0("CA210", str_sub(T, 1, 2), "0",  str_sub(T, 3, 3), "0", str_sub(R, 1, 2), "0", str_sub(R, 3, 3), "0SN", str_pad(S, 2, "left", "0"), "0"))
spray <- (asdf(agreportingspray)) %>% group_by(`Permit #`, Commodity, `Planted Amount`, M, `T`, R, S, FRSTDIVID_) 
spray_info <- spray %>% summarize(permit = list(`Permit #`), spray = list(`Product Name`), sprayid = list(`EPA Reg No`), amt = list(`Quantity Used`), unit = list(`Quantity Units`))

### merge agricultural spray data into basetract thorugh the description field, which gets proceessed correctly in conversion to KML for use by Google Maps.
### merge agricultural commodity data on top of that 
for (i in 1:nrow(basetracts)) {
    ### spray part
    farm = asdf( subset(spray_info, FRSTDIVID_ == basetracts[i,]$FRSTDIVID ) )
    desc = ""
    if (nrow(farm) > 0) {
        for (j in 1:nrow(farm)) {
			if (length(farm[j,"spray"][[1]]) > 0 ) {
				sprays <- paste0( '<ul>', paste0( "<li>", farm[j,"spray"][[1]], " (", farm[j,"sprayid"][[1]], ")</li>", collapse=''),'</ul>' )
				### connect to this api somehow: https://ofmpub.epa.gov/apex/pesticides/ppls/66551-1
			} else {
				sprays <- ""
			}
            desc = paste0(desc, '<p>', farm[j,"Commodity"],sprays,'</p>')
            #desc = paste0(desc, '<a href="https://google.com">', ag,'</a><br/>')
        }
    }

    ### commodity part
    agreportingmatch = asdf( subset(agreportingall, FRSTDIVID_ == basetracts[i,]$FRSTDIVID ) )
    commodities <- subset(agreportingmatch, Commodity %ni% excludes )
    desc_nospray = ""
    if (nrow(commodities) > 0) {
        for (j in 1:nrow(commodities)) {
            ### add commodoties that aren't already listed inthe spray list (spray only includes pesticitdes that are sprayed.  Commoditites includes all registered commoditires.
            if (commodities[j, "Commodity"] %ni% farm[,"Commodity"]) {
                ag <- commodities[j, "Commodity"]
                desc_nospray = paste0(desc_nospray, '<p>', ag,'</p>')
                #desc_nospray = paste0(desc_nospray, '<a href="https://google.com">', ag,'</a><br/>')
            }
        }
    }

    ### build description element for visualizatin in gmaps
	#print( desc )
    basetracts[i,"Description"] = paste0(desc_nospray , desc)
}

# filter out empty sections
basetracts = subset( basetracts, Description != "" )

### when building map, be aware of these limits:
###   https://developers.google.com/maps/documentation/javascript/kmllayer#restrictions
###   (e.g. not more than 1000 objects)
system("touch data/yoloAgWSpray.kml") # kludge
write_sf(basetracts, "data/yoloAgWSpray.kml", driver= "kml",  delete_dsn = TRUE)
