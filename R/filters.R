# filters.R
# Funcio pura d'aplicacio de filtres sobre el dataset d'indicadors.
# S'utilitza tant des dels modols Shiny com des dels tests.

#' Filtra el dataset d'indicadors segons any, comarques i municipis
#'
#' @param indicadors Tibble d'indicadors territorials.
#' @param anys Vector d'anys a incloure.
#' @param comarques Vector de comarques a incloure (buit = totes).
#' @param municipis Vector de municipis a incloure (buit = tots els de les comarques).
#' @return Tibble filtrat.
apply_filters <- function(indicadors, anys = NULL, comarques = NULL, municipis = NULL) {
  dades <- indicadors

  if (!is.null(anys) && length(anys) > 0) {
    dades <- dades[dades$any %in% anys, ]
  }

  if (!is.null(comarques) && length(comarques) > 0) {
    dades <- dades[dades$comarca %in% comarques, ]
  }

  if (!is.null(municipis) && length(municipis) > 0) {
    dades <- dades[dades$municipi %in% municipis, ]
  }

  tibble::as_tibble(dades)
}
