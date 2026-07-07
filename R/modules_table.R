# modules_table.R
# Modul Shiny de la taula interactiva d'indicadors (reactable).

tableUI <- function(id) {
  ns <- shiny::NS(id)
  shiny::div(
    class = "card-panel",
    shiny::h4("Taula d'indicadors", class = "panel-title"),
    reactable::reactableOutput(ns("taula"))
  )
}

#' Server del modul de taula
#'
#' @param id Identificador del modul.
#' @param dades_filtrades Reactiu amb el tibble d'indicadors ja filtrat.
#' @param indicador Reactiu amb l'identificador de l'indicador seleccionat.
#' @return NULL (renderitza directament la UI de sortida).
tableServer <- function(id, dades_filtrades, indicador) {
  shiny::moduleServer(id, function(input, output, session) {
    output$taula <- reactable::renderReactable({
      build_indicadors_table(dades_filtrades(), indicador())
    })
  })
}
