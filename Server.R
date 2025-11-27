#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      14/11/2025                             ##
##                  Creating a ShinyApp                        ##
##                       Server.R                              ##
##                                                             ##
#################################################################

# S1 Render leaflet map ----
# Leaflet map output


output$map <- renderLeaflet({
  
  leaflet() %>% 
    
    setView(lng=-4.1592, lat=50.9168, zoom=10.5)%>%
    
    addProviderTiles(providers$OpenStreetMap, group = "Colour") %>%
  
    addCircles(data = bridges,
               color = "black",
               fillColor="brown",
               fillOpacity=0.8,
               weight = 1,
               radius = 50,
               popup = ~paste("<b>Bridge Name:</b>", BRIDGE_, "<br><b>Owner:</b>", OWNER, "<br><b>Large Wood Upstream:</b>", LW_pstr),
               group = "Bridges") %>%
    
    addCircles(data=captures, 
               color="yellow",
               weight=3, radius=50, fillOpacity = 1,
               popup=("<b>Large Wood Capture</b>"),
               group="Captures") %>%
    
    addLegend(
      position = "topleft",
      colors = c("brown", "yellow"),
      labels = c("Bridges", "Large Wood Captures"),
      title = "Points of Interest",
      opacity = 0.8
    ) %>%

    
    addPolylines(data=river, 
                 color="deepskyblue", 
                 weight=5, 
                 popup=~paste("<b>River Torridge</b>"),
                 group="River") %>%
    
    addPolylines(data=distance, 
                 color="black",
                 weight=2, 
                 group="Nearest distance") %>%
    
    addRasterImage(heatmap, colors = pal_heatmap, opacity = 0.7, group = "Heatmap") %>%
    addImageQuery(
      heatmap,
      layerId = "Heatmap",
      prefix = "Value: ",
      digits = 2,
      position = "topright",
      type = "mousemove",  # Show values on mouse movement
      options = queryOptions(position = "topright"),  # Remove the TRUE text
      group = "Heatmap"
    ) %>%
    
    addLegend(
      position="bottomright", 
      pal=pal_heatmap,
      values=values(heatmap),
      title="Large Wood Denisty Heatmap", 
      opacity=0.7,
      group="Heatmap"
    ) %>%
      
    # Add Slope raster
    addRasterImage(slope_display, colors = pal_slope, opacity = 0.7, group = "Slope") %>%
    addImageQuery(
      slope_display,
      layerId = "Slope",
      prefix = "Slope: ",
      digits = 1,
      position = "topright",
      type = "mousemove",
      options = queryOptions(position = "topright"),
      group = "Slope"
    ) %>%
    
    # Add Aspect raster
    addRasterImage(aspect_display, colors = pal_aspect, opacity = 0.7, group = "Aspect") %>%
    addImageQuery(
      aspect_display,
      layerId = "Aspect",
      prefix = "Aspect: ",
      digits = 1,
      position = "topright",
      type = "mousemove",
      options = queryOptions(position = "topright"),
      group = "Aspect"
    ) %>%
    
    addLayersControl(
      baseGroups = c("Colour"),
      overlayGroups = c("River", "Bridges", "Nearest distance", "Large Wood Clusters", "Large Wood Captures", "Heatmap", "Aspect", "Slope"),
      options = layersControlOptions(collapsed = FALSE)
    ) 
    
  })

# Add popups for large wood points
observe({
  leafletProxy("map") %>%
    clearMarkers() %>%
    addCircleMarkers(data = clusters, fillColor = ~pal_clusters(CLUSTER_ID), color = "black", 
                     weight = 1, radius = 5, stroke = TRUE, fillOpacity = 0.7,
                     popup = ~paste("<b>Type:</b>", LW_Type, "<br><b>Cluster ID:</b>", CLUSTER_ID),
                     group = "Large Wood") %>%
    addLegend(
      position="bottomleft", 
      pal=pal_clusters,
      values=clusters$CLUSTER_ID,
      title="Large Wood Clusters",
      opacity=0.7,
      group="Large Wood Clusters"
    ) 
    
})


