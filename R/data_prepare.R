# data_prepare.R
# Preparacio de dades derivades a partir del dataset carregat: llistes
# de seleccio pels filtres i estructures auxiliars de consulta rapida.

#' Construeix les opcions disponibles pels filtres a partir de les dades
#'
#' @param indicadors Tibble d'indicadors territorials.
#' @return Llista amb `anys`, `comarques` i `municipis_per_comarca`.
prepare_filter_choices <- function(indicadors) {
  anys <- sort(unique(indicadors$any))
  comarques <- sort(unique(indicadors$comarca))

  municipis_per_comarca <- lapply(comarques, function(cmr) {
    sort(unique(indicadors$municipi[indicadors$comarca == cmr]))
  })
  names(municipis_per_comarca) <- comarques

  list(
    anys = anys,
    comarques = comarques,
    municipis_per_comarca = municipis_per_comarca
  )
}

#' Retorna els municipis disponibles per a un conjunt de comarques
#'
#' @param choices Llista retornada per `prepare_filter_choices()`.
#' @param comarques_seleccionades Vector de comarques seleccionades.
#' @return Vector ordenat de municipis disponibles.
municipis_for_comarques <- function(choices, comarques_seleccionades) {
  if (length(comarques_seleccionades) == 0) {
    return(character(0))
  }
  municipis <- unlist(choices$municipis_per_comarca[comarques_seleccionades], use.names = FALSE)
  sort(unique(municipis))
}

#' Uneix el dataset d'indicadors amb les geometries territorials
#'
#' @param indicadors Tibble d'indicadors (ja filtrat, tipicament d'un sol any).
#' @param geometries Objecte sf amb les geometries municipals.
#' @return Objecte sf amb indicadors i geometria combinats.
join_indicadors_geometries <- function(indicadors, geometries) {
  geometries_sel <- geometries[, c("municipi_id", "geometry")]
  merged <- dplyr::inner_join(geometries_sel, indicadors, by = "municipi_id")
  sf::st_as_sf(merged)
}
