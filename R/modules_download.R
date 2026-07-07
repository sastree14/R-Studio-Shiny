# modules_download.R
# Modul Shiny de descarrega de les dades filtrades en format CSV.

downloadUI <- function(id) {
  ns <- shiny::NS(id)
  shiny::downloadButton(ns("descarregar"), "Descarregar dades", class = "btn-primary")
}

#' Server del modul de descarrega
#'
#' @param id Identificador del modul.
#' @param dades_filtrades Reactiu amb el tibble d'indicadors ja filtrat.
#' @return NULL (registra directament el downloadHandler).
downloadServer <- function(id, dades_filtrades) {
  shiny::moduleServer(id, function(input, output, session) {
    output$descarregar <- shiny::downloadHandler(
      filename = function() {
        build_filename_with_date("indicadors_territorials", "csv")
      },
      content = function(file) {
        readr::write_csv(dades_filtrades(), file)
      }
    )
  })
}
