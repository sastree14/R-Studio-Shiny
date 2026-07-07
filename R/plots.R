# plots.R
# Construccio dels grafics interactius (ggplot2 + plotly) mostrats a la
# pestanya de grafics: evolucio temporal, ranquing, comparacio per
# comarca i distribucio de l'indicador seleccionat.

#' Tema ggplot2 sobri i consistent amb l'estil de l'aplicacio
#'
#' @return Objecte theme de ggplot2.
theme_indicadors <- function() {
  ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major = ggplot2::element_line(color = "#E4E7EC"),
      plot.title = ggplot2::element_text(color = COLOR_PRIMARY, face = "bold", size = 13),
      axis.text = ggplot2::element_text(color = COLOR_MUTED),
      axis.title = ggplot2::element_text(color = COLOR_PRIMARY),
      legend.position = "none"
    )
}

#' Grafic d'evolucio temporal de la mitjana de l'indicador seleccionat
#'
#' @param dades Tibble d'indicadors (tipicament sense filtrar per any).
#' @param indicador_id Identificador de l'indicador.
#' @return Objecte plotly.
plot_evolucio_temporal <- function(dades, indicador_id) {
  def <- get_indicador_def(indicador_id)

  resum <- dades %>%
    dplyr::group_by(.data$any) %>%
    dplyr::summarise(valor = mean(.data[[indicador_id]], na.rm = TRUE), .groups = "drop")

  p <- ggplot2::ggplot(resum, ggplot2::aes(x = .data$any, y = .data$valor)) +
    ggplot2::geom_line(color = COLOR_SECONDARY, linewidth = 1) +
    ggplot2::geom_point(color = COLOR_PRIMARY, size = 2) +
    ggplot2::scale_x_continuous(breaks = resum$any) +
    ggplot2::labs(title = "Evolució temporal", x = "Any", y = def$label) +
    theme_indicadors()

  plotly::ggplotly(p, tooltip = c("x", "y")) %>%
    plotly::config(displayModeBar = FALSE)
}

#' Grafic de rànquing de municipis segons l'indicador seleccionat
#'
#' @param dades Tibble d'indicadors ja filtrat.
#' @param indicador_id Identificador de l'indicador.
#' @param top_n Nombre maxim de municipis a mostrar.
#' @return Objecte plotly.
plot_ranking_municipis <- function(dades, indicador_id, top_n = 15) {
  def <- get_indicador_def(indicador_id)

  resum <- dades %>%
    dplyr::group_by(.data$municipi) %>%
    dplyr::summarise(valor = mean(.data[[indicador_id]], na.rm = TRUE), .groups = "drop") %>%
    dplyr::arrange(dplyr::desc(.data$valor)) %>%
    utils::head(top_n)

  resum$municipi <- factor(resum$municipi, levels = rev(resum$municipi))

  p <- ggplot2::ggplot(resum, ggplot2::aes(x = .data$municipi, y = .data$valor)) +
    ggplot2::geom_col(fill = COLOR_SECONDARY) +
    ggplot2::coord_flip() +
    ggplot2::labs(title = "Rànquing de municipis", x = NULL, y = def$label) +
    theme_indicadors()

  plotly::ggplotly(p, tooltip = c("x", "y")) %>%
    plotly::config(displayModeBar = FALSE)
}

#' Grafic de comparacio de l'indicador seleccionat per comarca
#'
#' @param dades Tibble d'indicadors ja filtrat.
#' @param indicador_id Identificador de l'indicador.
#' @return Objecte plotly.
plot_comparacio_comarca <- function(dades, indicador_id) {
  def <- get_indicador_def(indicador_id)

  resum <- dades %>%
    dplyr::group_by(.data$comarca) %>%
    dplyr::summarise(valor = mean(.data[[indicador_id]], na.rm = TRUE), .groups = "drop") %>%
    dplyr::arrange(dplyr::desc(.data$valor))

  resum$comarca <- factor(resum$comarca, levels = resum$comarca)

  p <- ggplot2::ggplot(resum, ggplot2::aes(x = .data$comarca, y = .data$valor)) +
    ggplot2::geom_col(fill = COLOR_PRIMARY) +
    ggplot2::labs(title = "Comparació per comarca", x = NULL, y = def$label) +
    theme_indicadors() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 40, hjust = 1))

  plotly::ggplotly(p, tooltip = c("x", "y")) %>%
    plotly::config(displayModeBar = FALSE)
}

#' Grafic de distribucio de l'indicador seleccionat
#'
#' @param dades Tibble d'indicadors ja filtrat.
#' @param indicador_id Identificador de l'indicador.
#' @return Objecte plotly.
plot_distribucio <- function(dades, indicador_id) {
  def <- get_indicador_def(indicador_id)

  p <- ggplot2::ggplot(dades, ggplot2::aes(x = .data[[indicador_id]])) +
    ggplot2::geom_histogram(fill = COLOR_SECONDARY, color = "white", bins = 20) +
    ggplot2::labs(title = "Distribució de l'indicador", x = def$label, y = "Freqüència") +
    theme_indicadors()

  plotly::ggplotly(p, tooltip = c("x", "y")) %>%
    plotly::config(displayModeBar = FALSE)
}
