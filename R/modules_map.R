# modules_map.R
# Modul Shiny del mapa territorial interactiu (leaflet + sf).

mapUI <- function(id) {
  ns <- shiny::NS(id)
  shiny::div(
    class = "card-panel",
    shiny::h4("Mapa territorial", class = "panel-title"),
    leaflet::leafletOutput(ns("mapa"), height = 480)
  )
}

#' Server del modul de mapa
#'
#' @param id Identificador del modul.
#' @param dades_filtrades Reactiu amb el tibble d'indicadors ja filtrat.
#' @param geometries Objecte sf amb les geometries municipals (estatic).
#' @param indicador Reactiu amb l'identificador de l'indicador seleccionat.
#' @return NULL (renderitza directament la UI de sortida).
mapServer <- function(id, dades_filtrades, geometries, indicador) {
  shiny::moduleServer(id, function(input, output, session) {
    output$mapa <- leaflet::renderLeaflet({
      dades_map <- prepare_map_data(dades_filtrades(), geometries, indicador())
      build_territorial_map(dades_map, indicador())
    })
  })
}
