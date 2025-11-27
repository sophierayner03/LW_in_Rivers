#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      14/11/2025                             ##
##                  Creating a ShinyApp                        ##
##                        Global.R                             ##
##                                                             ##
#################################################################


# G1 Load large wood, river, and bridge data ----
lw_points <- st_read("LWtype.shp")
river <- st_read("River.shp")
river <- st_union(river)
river<- st_sf(geometry = st_sfc(river))
river <- st_zm(river, drop = TRUE, what = "ZM")
bridges <- st_read("Bridges.shp")
bridges <- bridges[!st_is_empty(bridges$geometry), ]
bridges <- st_read("bridges_with_LW.shp")
distance<-st_read("LWDistance.shp")
captures<-st_read("Captures.shp")


#Convert vectors to CRS 4326
lw_points <- st_transform(lw_points, crs = 4326)
river <- st_transform(river, crs = 4326)
bridges <- st_transform(bridges, crs = 4326)
distance<-st_transform(distance, crs=4326)
captures<-st_transform(captures, crs=4326)


clusters <- st_read("LWClusters.shp")
clusters <- st_transform(clusters, crs = 4326)

# Dynamically generate colours based on number of unique clusters
num_clusters <- length(unique(clusters$CLUSTER_ID))
pal_clusters <- colorFactor(palette = colorRampPalette(brewer.pal(12, "Paired"))(num_clusters), domain = clusters$CLUSTER_ID)
cluster_labels<-paste("Cluster", 1:length(num_clusters))

heatmap <- rast("Heatmap.tif")
heatmap <- project(heatmap, crs(river))

pal_heatmap <- colorNumeric(palette = "inferno", domain = na.omit(values(heatmap)), na.color = "transparent")

slope <- rast("slope.tif")
aspect <- rast("aspect.tif")

# Aggregate for Leaflet display (reduce resolution)
slope_display <- aggregate(slope, fact = 10, fun = mean)

aspect_display <- aggregate(aspect, fact = 10, fun = mean)

# Create color palettes for slope and aspect
pal_slope <- colorNumeric(palette = "RdPu", domain = values(slope_display), na.color = "transparent")
pal_aspect <- colorNumeric(palette = "Purples", domain = values(aspect_display), na.color = "transparent")




