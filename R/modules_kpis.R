# modules_kpis.R
# Modul Shiny dels KPIs principals, mostrats com a targetes a la part
# superior del dashboard.

kpisUI <- function(id) {
  ns <- shiny::NS(id)
  shiny::uiOutput(ns("kpi_cards"))
}

#' Server del modul de KPIs
#'
#' @param id Identificador del modul.
#' @param dades_filtrades Reactiu amb el tibble d'indicadors ja filtrat.
#' @return NULL (renderitza directament la UI de sortida).
kpisServer <- function(id, dades_filtrades) {
  shiny::moduleServer(id, function(input, output, session) {
    output$kpi_cards <- shiny::renderUI({
      kpis <- calculate_kpis(dades_filtrades())

      shiny::tagList(
        shiny::div(
          class = "kpi-grid",
          kpi_card("Municipis seleccionats", format_indicador(kpis$n_municipis, "nombre")),
          kpi_card("Població total", format_indicador(kpis$poblacio_total, "nombre")),
          kpi_card("Renda mitjana ponderada", format_indicador(kpis$renda_mitjana_ponderada, "moneda")),
          kpi_card("Taxa d'envelliment mitjana", format_indicador(kpis$taxa_envelliment_mitjana, "percentatge")),
          kpi_card("Incidència sanitària mitjana", format_indicador(kpis$incidencia_sanitaria_mitjana, "index")),
          kpi_card("Índex de vulnerabilitat mitjà", format_indicador(kpis$index_vulnerabilitat_mitja, "index"))
        )
      )
    })
  })
}

#' Construeix una targeta de KPI individual
#'
#' @param titol Titol de la targeta.
#' @param valor Valor formatat a mostrar.
#' @return Element HTML (div) de la targeta.
kpi_card <- function(titol, valor) {
  shiny::div(
    class = "kpi-card",
    shiny::div(class = "kpi-value", valor),
    shiny::div(class = "kpi-label", titol)
  )
}
