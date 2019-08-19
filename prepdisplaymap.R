library(sf)
library(readxl)
library(stringr)
'%ni%' <- function(x,y)!('%in%'(x,y))
asdf <- as.data.frame

#> Linking to GEOS 3.6.1, GDAL 2.1.3, PROJ 4.9.3
basetracts <- st_read("data/countyPrepped.gpkg")
agreporting <- read_xlsx("data/19\ PERM\ 6-11-19.xlsx")

baseids <- basetracts$FRSTDIVID
#baseids <- basetracts$SECDIVID
#agreporting$SECDIVID_ <- with(agreporting, paste0("CA210", str_sub(T, 1, 2), "0",  str_sub(T, 3, 3), "0", str_sub(R, 1, 2), "0", str_sub(R, 3, 3), "0SN", str_pad(S, 2, "left", "0"), "0", `Site-ID`))
agreporting$FRSTDIVID_ <- with(agreporting, paste0("CA210", str_sub(T, 1, 2), "0",  str_sub(T, 3, 3), "0", str_sub(R, 1, 2), "0", str_sub(R, 3, 3), "0SN", str_pad(S, 2, "left", "0"), "0"))
agids <- agreporting$FRSTDIVID_

sum(agids %in% baseids)
sum(baseids %in% agids)
length(agids)
length(unique(agids))
length(baseids)

asamp <-   unique( agids[ startsWith(agids,   "CA210090N0100E0SN0") ] )
bsamp <- unique( baseids[ startsWith(baseids, "CA210090N0100E0SN0") ] )
asamp
bsamp
asamp[ asamp %ni% bsamp ]

### several reported codes lacking PLSS base map sectiosn
unique( agids[ agids %ni% baseids ] )
sort( baseids[ startsWith(baseids, "CA210100N0010E0SN") ] )

subset(basetracts, startsWith(FRSTDIVID, "CA210080N0020E0SN08") )
as.data.frame( subset(agreporting, startsWith( FRSTDIVID_, "CA210080N0020E0SN08") ) )

plot(basetracts[1])

if (F) {
    for (i in 1:nrow(basetracts)) {
        agfinds = asdf( subset(agreporting, FRSTDIVID_ == basetracts[i,]$FRSTDIVID ) )
        desc = ""
        if (nrow(agfinds) > 0) {
            for (j in 1:nrow(agfinds)) {
                ag <- agfinds[j,]
                desc = paste0(desc, '<a href="https://google.com">', ag$Commodity,'</a><br/>')
            }
        }
        basetracts[i,"Description"] = desc
    }
}
for (i in 1:nrow(basetracts)) {
    commodities = asdf( subset(agreporting, FRSTDIVID_ == basetracts[i,]$FRSTDIVID ) )[,"Commodity"]
    commodities = unique( commodities )
    desc = ""
    if (length(commodities) > 0) {
        for (j in 1:length(commodities)) {
            ag <- commodities[j]
            desc = paste0(desc, '<a href="https://google.com">', ag,'</a><br/>')
        }
    }
    basetracts[i,"Description"] = desc
}
### when building map, be aware of these limits:
###   https://developers.google.com/maps/documentation/javascript/kmllayer#restrictions
###   (e.g. not more than 1000 objects)
system("touch data/countyDisplay.kml") # kludge
write_sf(basetracts, "data/countyDisplay.kml", driver= "kml",  delete_dsn = TRUE)
