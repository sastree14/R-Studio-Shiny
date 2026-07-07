# data_load.R
# Carrega de les dades processades (indicadors i geometries) des de disc.
# Es crida una unica vegada a l'inici de l'aplicacio (app.R), mai dins
# de reactives, per evitar lectures redundants.

#' Carrega el dataset d'indicadors territorials
#'
#' @param path Ruta al fitxer .rds amb els indicadors.
#' @return Tibble amb els indicadors territorials.
load_indicadors <- function(path = PATH_INDICADORS) {
  if (!file.exists(path)) {
    stop(
      "No s'ha trobat el fitxer de dades: ", path, ". ",
      "Executa 'Rscript scripts/01_generate_demo_data.R' per generar-lo."
    )
  }
  readRDS(path)
}

#' Carrega les geometries territorials municipals
#'
#' @param path Ruta al fitxer .rds amb les geometries sf.
#' @return Objecte sf amb les geometries municipals.
load_geometries <- function(path = PATH_GEOMETRIES) {
  if (!file.exists(path)) {
    stop(
      "No s'ha trobat el fitxer de geometries: ", path, ". ",
      "Executa 'Rscript scripts/01_generate_demo_data.R' per generar-lo."
    )
  }
  readRDS(path)
}

#' Carrega totes les dades necessaries per a l'aplicacio
#'
#' @return Llista amb `indicadors` i `geometries`.
load_app_data <- function() {
  list(
    indicadors = load_indicadors(),
    geometries = load_geometries()
  )
}
