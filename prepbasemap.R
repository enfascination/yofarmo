### this script takes a giant .gdb file (a standard GIS archive format) of PLSS tracts of many states and filters down to a specific type of tract data for a specific area.
### it uses R's sf, which is impressive and easy and made the impossible possible

#setwd("~/projecto/research_projects/hacking/yofarmo/")
#install.packages("devtools")
#devtools::install_github("tidyverse/ggplot2")
#install.packages("sf")

library("sf")
library("dplyr")
library("rnaturalearth")
library("rnaturalearthdata")
library("ggplot2")
theme_set(theme_bw())
#library(data.table)


# https://gis.stackexchange.com/questions/184013/read-a-table-from-an-esri-file-geodatabase-gdb-using-r
#sf::st_layers(dsn = "data/CadRef_v10.gdb")
#CAPLSSmetadata <- sf::st_read(dsn = "data/CadRef_v10.gdb", layer = "MetadataGlance")
#CAPLSStownship <- sf::st_read(dsn = "data/CadRef_v10.gdb", layer = "PLSSTownship")
CAPLSSsection <- sf::st_read(dsn = "data/CadRef_v10.gdb", layer = "PLSSFirstDivision")
#CAPLSSintrsct <- sf::st_read(dsn = "data/CadRef_v10.gdb", layer = "PLSSIntersected")
#CAPLSSpoints <- sf::st_read(dsn = "data/CadRef_v10.gdb", layer = "PLSSPoint")

#setnames( DavisPLSS2, c("POINTID", "XCOORD", "YCOORD", "SHAPE"), c("ID", "X", "Y", "geometry"))


#DavisPLSSsect <- subset(CAPLSSsection, startsWith(FRSTDIVID,"CA210080N0020E0"))
### Yolo county stretches roughly from 7-11N and 2W to 3E
DavisPLSSsect <- subset(CAPLSSsection, str_detect(FRSTDIVID,"CA210(06|07|08|09|10|11|12)0N00[1234]0[EW]0"))
#  finer sections can't resolve from county data, so use coardser section/firstdivision data instead
#DavisPLSSqrtsect <- subset(CAPLSSintrsct, startsWith(SECDIVID,"CA210080N0020E0"))
#DavisPLSSqrtsect$HiUmHello = 'sqzz?'
#DavisPLSSqrtsect$Description = '<a href="https://google.com">a link</a><br/><a href="https://google.com">a nother link</a>'


# exploratory plotting
if (FALSE) {
    # sf and shape files
    # plotting cribbed from https://www.r-spatial.org/r/2018/10/25/ggplot2-sf-2.html
    world <- ne_countries(scale = "medium", returnclass = "sf")

    # township (spatial scale of ~ 6 mile sq)
    ggplot(data = world) +
        geom_sf() +
        geom_sf(data = st_as_sf( vessel ), fill = NA) + 
        coord_sf(xlim = c(-121.82, -121.68), ylim = c(38.48, 38.59), expand = FALSE)

    # section (spatial scale of ~1 mile sq)
    ggplot(data = world) +
        geom_sf() +
        geom_sf(data = st_as_sf( DavisPLSSsect ), fill = NA) + 
        coord_sf(xlim = c(-121.82, -121.68), ylim = c(38.48, 38.59), expand = FALSE)

    # quartersection (spatial scale of <1 mile sq. This is the finest scale, and the scale of reporting)
    ggplot(data = world) +
        geom_sf() +
        geom_sf(data = st_as_sf( DavisPLSSqrtsect ), fill = NA) + 
        coord_sf(xlim = c(-121.82, -121.68), ylim = c(38.48, 38.59), expand = FALSE)
}

### write to kml
#system("touch data/countyPrepped.kml") # kludge
#write_sf(DavisPLSSqrtsect, "data/countyPrepped.kml", driver = "kml", delete_dsn = TRUE)
write_sf(DavisPLSSsect, "data/countyPrepped.gpkg", delete_dsn = TRUE)
