options(encoding = "UTF-8")

# load packages
req_pkg <- c("tidyverse", "leaflet", "shiny", "priceR", "plotly", "leafem")

for (i in req_pkg) {

  library(i, character.only = TRUE)

}


# Source
source("helpers.R")



# UI

ui <- fluidPage(
  
  headerPanel("Twin Cities Fiscal Disparities Revenue Sharing"),
  
  sidebarLayout(position = "right",
                sidebarPanel(includeHTML("sidebar_text.html")),
                mainPanel(uiOutput("tab"))
                )
            )


# Server

server <- function(input, output, session){
  
  options(warn = -1)
  
  output$map1 <- renderLeaflet(
    
    leaflet() %>%
      addProviderTiles(provider = "CartoDB.PositronNoLabels", options = tileOptions(minZoom = 8, maxZoom = 16)) %>%
      addProviderTiles(provider = "CartoDB.PositronOnlyLabels", options = providerTileOptions(pane = "markerPane")) %>%
      addPolygons(data = base, 
                  weight = 0.2,
                  color = "grey",
                  fillColor = ~pal1(ci_pct_change_bin),
                  fillOpacity = 0.8,
                  label = mapLabels) %>%
      addLegend(pal = pal1,
                values = base$ci_pct_change_bin,
                position = "bottomleft")
    
  )
  
  output$map2 <- renderLeaflet(
    
    leaflet() %>%
      addProviderTiles(provider = "CartoDB.PositronNoLabels", options = tileOptions(minZoom = 8, maxZoom = 16)) %>%
      addProviderTiles(provider = "CartoDB.PositronOnlyLabels", options = providerTileOptions(pane = "markerPane")) %>%
      addPolygons(data = base, 
                  weight = 0.2,
                  color = "grey",
                  fillColor = ~pal2(bivar_ci_medinc),
                  fillOpacity = 0.8,
                  label = mapLabels) %>%
      addLogo("https://user-images.githubusercontent.com/7897840/101764167-5bda9a80-3aa5-11eb-8ac0-d875be7491c6.png", position = "bottomleft", width = 270, height = 180)
  )
  
  output$scatterplot <- renderPlotly(
    
    plot1 <- plot_ly(
      type = "scatter",
      mode = "markers",
      x = base$pct_change_ci_base,
      y = base$med_income,
      marker = list(size = 10),
      color = base$community_designation_thrive_msp2040,
      text = base$community,
      hovertemplate = paste0("<b>%{text}</b></br>",
                             "Percent Change CI Tax Base: %{x}%<br>",
                             "Median Household Income: %{y:$,.0f}")) %>%
      layout(legend = list(itemclick = "toggleothers"),
             xaxis = list(range = c(-100, 500), fixedrange = TRUE, title = "% Change in Commercial/Industrial Tax Base"),
             yaxis = list(range = c(0, 200000), fixedrange = TRUE, title = "Median Household Income"))
    
  )
  
  output$tab <- renderUI({
    tabsetPanel(
      tabPanel("Revenue Redistribution", 
               tags$head(tags$style(type = "text/css", "#map1 {height:80vh !important;}")),
               leafletOutput("map1")),
      tabPanel("Change in Tax Base by Median Income", 
               tags$head(tags$style(type = "text/css", "#map2 {height:80vh !important;}")),
               leafletOutput("map2")),
      tabPanel("Change in Tax Base by Median Income by Community Type",
               tags$head(tags$style(type = "text/css", "#scatterplot {height:80vh !important;}")),
               plotlyOutput("scatterplot"))
    )
    
  })
}

# Run
shinyApp(ui, server)


