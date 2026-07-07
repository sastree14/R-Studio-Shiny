# 00_install_packages.R
# Instal·la (si cal) tots els paquets necessaris per executar l'aplicacio,
# els scripts i els tests. Pensat com a alternativa rapida a renv::restore()
# quan encara no s'ha inicialitzat renv al projecte.
#
# Us:
#   Rscript scripts/00_install_packages.R

required_packages <- c(
  "shiny", "bslib", "dplyr", "tidyr", "readr", "purrr", "stringr",
  "lubridate", "ggplot2", "plotly", "leaflet", "sf", "reactable",
  "scales", "htmltools", "shinyWidgets", "testthat", "renv"
)

installed <- rownames(installed.packages())
missing_packages <- setdiff(required_packages, installed)

if (length(missing_packages) > 0) {
  message("Instal·lant paquets: ", paste(missing_packages, collapse = ", "))
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
} else {
  message("Tots els paquets necessaris ja estan instal·lats.")
}
