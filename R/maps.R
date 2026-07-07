# maps.R
# Construccio del mapa interactiu (leaflet + sf) que mostra l'indicador
# seleccionat per municipi.

#' Prepara les dades agregades per municipi per mostrar al mapa
#'
#' Com que el mapa mostra un unic valor per municipi, quan hi ha mes
#' d'un any seleccionat es fa la mitjana dels valors de l'indicador
#' pel periode seleccionat.
#'
#' @param dades_filtrades Tibble d'indicadors ja filtrat.
#' @param geometries Objecte sf amb les geometries municipals.
#' @param indicador_id Identificador de l'indicador a mostrar.
#' @return Objecte sf amb una fila per municipi i la columna `valor`.
prepare_map_data <- function(dades_filtrades, geometries, indicador_id) {
  if (nrow(dades_filtrades) == 0) {
    return(NULL)
  }

  agregat <- dades_filtrades %>%
    dplyr::group_by(.data$municipi_id, .data$municipi, .data$comarca) %>%
    dplyr::summarise(
      valor = mean(.data[[indicador_id]], na.rm = TRUE),
      .groups = "drop"
    )

  join_indicadors_geometries(agregat, geometries)
}

#' Construeix el mapa territorial interactiu amb leaflet
#'
#' @param dades_sf Objecte sf retornat per `prepare_map_data()`.
#' @param indicador_id Identificador de l'indicador mostrat.
#' @return Objecte leaflet.
build_territorial_map <- function(dades_sf, indicador_id) {
  if (is.null(dades_sf) || nrow(dades_sf) == 0) {
    return(
      leaflet::leaflet() %>%
        leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) %>%
        leaflet::setView(lng = 1.75, lat = 41.7, zoom = 7)
    )
  }

  def <- get_indicador_def(indicador_id)
  pal <- palette_for_indicador(indicador_id, dades_sf$valor)

  etiquetes <- sprintf(
    "<strong>%s</strong><br/>Comarca: %s<br/>%s: %s",
    dades_sf$municipi,
    dades_sf$comarca,
    def$label,
    vapply(dades_sf$valor, format_indicador, character(1), format = def$format)
  )
  etiquetes <- lapply(etiquetes, htmltools::HTML)

  leaflet::leaflet(dades_sf) %>%
    leaflet::addProviderTiles(leaflet::providers$CartoDB.Positron) %>%
    leaflet::addPolygons(
      fillColor = ~ pal(valor),
      color = "#FFFFFF",
      weight = 1,
      opacity = 1,
      fillOpacity = 0.85,
      label = etiquetes,
      labelOptions = leaflet::labelOptions(
        style = list("font-size" = "12px"),
        direction = "auto"
      ),
      highlightOptions = leaflet::highlightOptions(
        weight = 2.5,
        color = COLOR_PRIMARY,
        bringToFront = TRUE
      )
    ) %>%
    leaflet::addLegend(
      pal = pal,
      values = ~valor,
      title = def$label,
      position = "bottomright",
      opacity = 0.9
    )
}
