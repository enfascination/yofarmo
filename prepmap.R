library("ggplot2")
theme_set(theme_bw())
library("sf")
library("rnaturalearth")
library("rnaturalearthdata")

world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)
library(data.table)

# https://gis.stackexchange.com/questions/184013/read-a-table-from-an-esri-file-geodatabase-gdb-using-r
install.packages("sf")
library(sf)
sf::st_layers(dsn = "~/Downloads/CadRef_v10.gdb")
CAPLSSmetadata <- sf::st_read(dsn = "~/Downloads/CadRef_v10.gdb", layer = "MetadataGlance")
CAPLSStownship <- sf::st_read(dsn = "~/Downloads/CadRef_v10.gdb", layer = "PLSSTownship")
CAPLSSsection <- sf::st_read(dsn = "~/Downloads/CadRef_v10.gdb", layer = "PLSSFirstDivision")
CAPLSSintrsct <- sf::st_read(dsn = "~/Downloads/CadRef_v10.gdb", layer = "PLSSIntersected")
CAPLSSpoints <- sf::st_read(dsn = "~/Downloads/CadRef_v10.gdb", layer = "PLSSPoint")

CAPLSS <- sf::st_read(dsn = "~/Downloads/CadRef_v10.gdb", layer = "PLSSTownship")
CAPLSSpoints <- sf::st_read(dsn = "~/Downloads/CadRef_v10.gdb", layer = "PLSSPoint")

YoloPLSS <- subset(CAPLSSpoints, (XCOORD > -122.55) & (XCOORD < -122.34) & (YCOORD < 38.45) & (YCOORD > 38.28) )

DavisPLSS <- subset(CAPLSSpoints, (XCOORD > -122.47) & (XCOORD < -122.41) & (YCOORD < 38.34) & (YCOORD > 38.32) )


DavisPLSS2 <- subset(CAPLSSpoints, (XCOORD > -122.78) & (XCOORD < -122.68) & (YCOORD < 38.56) & (YCOORD > 38.53) )

CAPLSS


DavisPLSSsection <- subset(CAPLSSsection, startsWith(FRSTDIVID,"CA210080N0020E0"))

#setnames( DavisPLSS2, c("POINTID", "XCOORD", "YCOORD", "SHAPE"), c("ID", "X", "Y", "geometry"))


DavisPLSSqrtsect <- subset(CAPLSSintrsct, startsWith(SECDIVID,"CA210080N0020E0"))
DavisPLSSqrtsect$HiUmHello = 'sqzz?'
DavisPLSSqrtsect$Description = '<a href="https://google.com">a link</a><br/><a href="https://google.com">a nother link</a>'



# maybe good)




# https://www.r-spatial.org/r/2018/10/25/ggplot2-sf-2.html
# sf and shape files


library("ggplot2")
theme_set(theme_bw())
library("sf")

library("rnaturalearth")
library("rnaturalearthdata")

world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)


(sites <- data.frame(longitude = c(-122.78, -122.68), latitude = c(38.53, 
    38.56)))


ggplot(data = world) +
    geom_sf() +
    geom_sf(data = st_as_sf( WDavisPLSS ), fill = NA) + 
    coord_sf(xlim = c(-122.78, -122.68), ylim = c(38.53, 38.56), expand = FALSE)



ggplot(data = world) +    geom_sf() +    geom_sf(data = st_as_sf( vessel4 ), fill = NA) +     coord_sf(xlim = c(-123, -122), ylim = c(38, 39), expand = FALSE)ggplot(data = world) +    geom_sf() +    geom_sf(data = st_as_sf( WDavisPLSS ), fill = NA) +     coord_sf(xlim = c(-123, -122), ylim = c(38, 39), expand = FALSE)# townshipggplot(data = world) +
    geom_sf() +
    geom_sf(data = st_as_sf( vessel ), fill = NA) + 
    coord_sf(xlim = c(-121.82, -121.68), ylim = c(38.48, 38.59), expand = FALSE)# sectionggplot(data = world) +    geom_sf() +    geom_sf(data = st_as_sf( DavisPLSSsection ), fill = NA) +     coord_sf(xlim = c(-121.82, -121.68), ylim = c(38.48, 38.59), expand = FALSE)# quartersectionggplot(data = world) +    geom_sf() +    geom_sf(data = st_as_sf( DavisPLSSqrtsect ), fill = NA) +     coord_sf(xlim = c(-121.82, -121.68), ylim = c(38.48, 38.59), expand = FALSE)# write to kmol
system("touch ~/Downloads/test.kml")
write_sf(DavisPLSSqrtsect, "~/Downloads/test.kml", driver = "kml", delete_dsn = TRUE)
