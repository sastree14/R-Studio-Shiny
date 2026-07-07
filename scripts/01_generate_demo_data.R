# 01_generate_demo_data.R
# Genera les dades demo reproduibles de l'aplicacio: el dataset tabular
# d'indicadors territorials i les geometries sf associades, i les
# desa a data/processed/.
#
# Us:
#   Rscript scripts/01_generate_demo_data.R

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

message("Generant dades demo (llavor = ", SEED_GENERACIO, ")...")

demo_data <- generate_demo_data()

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)

saveRDS(demo_data$indicadors, PATH_INDICADORS)
saveRDS(demo_data$geometries, PATH_GEOMETRIES)

message("Fet.")
message(" - ", PATH_INDICADORS, " (", nrow(demo_data$indicadors), " files)")
message(" - ", PATH_GEOMETRIES, " (", nrow(demo_data$geometries), " municipis)")
