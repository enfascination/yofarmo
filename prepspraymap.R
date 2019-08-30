library(sf)
library(readxl)
library(stringr)
'%ni%' <- function(x,y)!('%in%'(x,y))
asdf <- as.data.frame

#> Linking to GEOS 3.6.1, GDAL 2.1.3, PROJ 4.9.3
basetracts <- st_read("data/countyPrepped.gpkg")
agreporting <- read_xlsx("data/PUR\ 6-11-19.xlsx")

baseids <- basetracts$FRSTDIVID
#baseids <- basetracts$SECDIVID
#agreporting$SECDIVID_ <- with(agreporting, paste0("CA210", str_sub(T, 1, 2), "0",  str_sub(T, 3, 3), "0", str_sub(R, 1, 2), "0", str_sub(R, 3, 3), "0SN", str_pad(S, 2, "left", "0"), "0", `Site-ID`))
agreporting$FRSTDIVID_ <- with(agreporting, paste0("CA210", str_sub(T, 1, 2), "0",  str_sub(T, 3, 3), "0", str_sub(R, 1, 2), "0", str_sub(R, 3, 3), "0SN", str_pad(S, 2, "left", "0"), "0"))

spray <- (asdf(agreporting)) %>% group_by(`Permit #`, Commodity, `Planted Amount`, M, `T`, R, S, FRSTDIVID_) 
spray_info <- spray %>% summarize(spray = list(`Product Name`), sprayid = list(`EPA Reg No`), amt = list(`Quantity Used`), unit = list(`Quantity Units`))

### merge agricultural commodity data into basetract thorugh the description field, which gets proceessed correctly in conversion to KML for use by Google Maps.
for (i in 1:nrow(basetracts)) {
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
	#print( desc )
    basetracts[i,"Description"] = desc
}

# filter out empty sections
basetracts = subset( basetracts, Description != "" )

### when building map, be aware of these limits:
###   https://developers.google.com/maps/documentation/javascript/kmllayer#restrictions
###   (e.g. not more than 1000 objects)
system("touch data/countyDispray.kml") # kludge
write_sf(basetracts, "data/countyDispray.kml", driver= "kml",  delete_dsn = TRUE)
