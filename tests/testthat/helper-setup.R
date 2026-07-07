# helper-setup.R
# Es carrega automaticament abans dels tests (convencio testthat
# "helper-*.R"). Sourceja el codi de R/ necessari per als tests,
# assumint que testthat s'executa des de l'arrel del projecte.

suppressPackageStartupMessages({
  library(dplyr)
  library(purrr)
  library(tibble)
  library(scales)
  library(sf)
})

source("R/config.R")
source("R/utils.R")
source("R/data_generate.R")
source("R/filters.R")
source("R/kpis.R")

#' Genera un conjunt de dades demo petit per a us exclusiu en tests
test_demo_data <- function(n_municipis = 12, n_comarques = 3) {
  geometries <- generate_geometries(n_municipis = n_municipis, n_comarques = n_comarques)
  indicadors <- generate_indicadors_data(geometries, anys = ANYS_DISPONIBLES)
  list(indicadors = indicadors, geometries = geometries)
}
