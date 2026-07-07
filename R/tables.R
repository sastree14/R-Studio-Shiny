# tables.R
# Construccio de la taula interactiva (reactable) amb els indicadors
# territorials filtrats.

#' Construeix la taula interactiva d'indicadors
#'
#' @param dades Tibble d'indicadors ja filtrat.
#' @param indicador_id Identificador de l'indicador seleccionat (es
#'   ressalta la columna corresponent).
#' @return Widget reactable.
build_indicadors_table <- function(dades, indicador_id = NULL) {
  columnes <- list(
    municipi_id = reactable::colDef(show = FALSE),
    municipi = reactable::colDef(name = "Municipi", minWidth = 140, sticky = "left"),
    comarca = reactable::colDef(name = "Comarca", minWidth = 130),
    any = reactable::colDef(name = "Any", width = 80),
    poblacio = reactable::colDef(
      name = "Població",
      format = reactable::colFormat(separators = TRUE, locale = "ca-ES"),
      align = "right"
    ),
    renda_mitjana = reactable::colDef(
      name = "Renda mitjana (EUR)",
      format = reactable::colFormat(separators = TRUE, locale = "ca-ES", digits = 0),
      align = "right"
    ),
    taxa_envelliment = reactable::colDef(
      name = "Taxa d'envelliment (%)",
      format = reactable::colFormat(digits = 1),
      align = "right"
    ),
    incidencia_sanitaria = reactable::colDef(
      name = "Incidència sanitària",
      format = reactable::colFormat(digits = 0),
      align = "right"
    ),
    index_vulnerabilitat = reactable::colDef(
      name = "Índex de vulnerabilitat",
      format = reactable::colFormat(digits = 1),
      align = "right"
    ),
    accessibilitat_serveis = reactable::colDef(
      name = "Accessibilitat a serveis",
      format = reactable::colFormat(digits = 1),
      align = "right"
    )
  )

  if (!is.null(indicador_id) && indicador_id %in% names(columnes)) {
    columnes[[indicador_id]]$style <- list(fontWeight = "700", color = COLOR_PRIMARY, background = "#EEF2FA")
    columnes[[indicador_id]]$headerStyle <- list(color = COLOR_PRIMARY)
  }

  reactable::reactable(
    dades,
    columns = columnes,
    filterable = TRUE,
    searchable = TRUE,
    sortable = TRUE,
    resizable = TRUE,
    striped = TRUE,
    highlight = TRUE,
    bordered = FALSE,
    defaultPageSize = 12,
    showPageSizeOptions = TRUE,
    pageSizeOptions = c(12, 25, 50, 100),
    language = reactable::reactableLang(
      searchPlaceholder = "Cercar...",
      noData = "No hi ha dades disponibles",
      pageInfo = "{rowStart}–{rowEnd} de {rows} files",
      pagePrevious = "Anterior",
      pageNext = "Següent"
    ),
    theme = reactable::reactableTheme(
      borderColor = "#E4E7EC",
      stripedColor = "#F8F9FB",
      highlightColor = "#EEF2FA",
      headerStyle = list(color = COLOR_PRIMARY, fontWeight = "700")
    )
  )
}
