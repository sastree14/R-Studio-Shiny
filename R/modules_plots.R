# modules_plots.R
# Modul Shiny dels grafics interactius (plotly): evolucio temporal,
# rànquing de municipis, comparacio per comarca i distribucio.

plotsUI <- function(id) {
  ns <- shiny::NS(id)

  shiny::tagList(
    shiny::div(
      class = "plots-grid",
      shiny::div(
        class = "card-panel",
        shiny::h4("Evolució temporal", class = "panel-title"),
        plotly::plotlyOutput(ns("evolucio"), height = 320)
      ),
      shiny::div(
        class = "card-panel",
        shiny::h4("Rànquing de municipis", class = "panel-title"),
        plotly::plotlyOutput(ns("ranking"), height = 320)
      ),
      shiny::div(
        class = "card-panel",
        shiny::h4("Comparació per comarca", class = "panel-title"),
        plotly::plotlyOutput(ns("comarca"), height = 320)
      ),
      shiny::div(
        class = "card-panel",
        shiny::h4("Distribució de l'indicador", class = "panel-title"),
        plotly::plotlyOutput(ns("distribucio"), height = 320)
      )
    )
  )
}

#' Server del modul de grafics
#'
#' @param id Identificador del modul.
#' @param dades_filtrades Reactiu amb el tibble d'indicadors filtrat per
#'   any, comarca i municipi (usat per ranquing, comarca i distribucio).
#' @param dades_tendencia Reactiu amb el tibble d'indicadors filtrat
#'   nomes per comarca/municipi (sense filtrar per any), usat per
#'   mostrar la tendencia temporal completa.
#' @param indicador Reactiu amb l'identificador de l'indicador seleccionat.
#' @return NULL (renderitza directament les sortides).
plotsServer <- function(id, dades_filtrades, dades_tendencia, indicador) {
  shiny::moduleServer(id, function(input, output, session) {
    output$evolucio <- plotly::renderPlotly({
      shiny::req(nrow(dades_tendencia()) > 0)
      plot_evolucio_temporal(dades_tendencia(), indicador())
    })

    output$ranking <- plotly::renderPlotly({
      shiny::req(nrow(dades_filtrades()) > 0)
      plot_ranking_municipis(dades_filtrades(), indicador())
    })

    output$comarca <- plotly::renderPlotly({
      shiny::req(nrow(dades_filtrades()) > 0)
      plot_comparacio_comarca(dades_filtrades(), indicador())
    })

    output$distribucio <- plotly::renderPlotly({
      shiny::req(nrow(dades_filtrades()) > 0)
      plot_distribucio(dades_filtrades(), indicador())
    })
  })
}
