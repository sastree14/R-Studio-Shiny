# app.R
# Punt d'entrada de l'aplicacio "Indicadors Territorials de Salut i
# Demografia". Carrega les dependencies, les dades (una unica vegada) i
# defineix la UI i el server combinant els modols de R/.
#
# Execucio local:
#   shiny::runApp(".", host = "127.0.0.1", port = 3838)
# o obrint aquest fitxer a RStudio i prement "Run App".

library(shiny)
library(bslib)
library(dplyr)
library(tidyr)
library(readr)
library(purrr)
library(stringr)
library(lubridate)
library(ggplot2)
library(plotly)
library(leaflet)
library(sf)
library(reactable)
library(scales)
library(htmltools)
library(shinyWidgets)

# --- Codi font de l'aplicacio -----------------------------------------
source("R/config.R")
source("R/utils.R")
source("R/data_generate.R")
source("R/data_load.R")
source("R/data_prepare.R")
source("R/filters.R")
source("R/kpis.R")
source("R/maps.R")
source("R/plots.R")
source("R/tables.R")
source("R/modules_filters.R")
source("R/modules_kpis.R")
source("R/modules_map.R")
source("R/modules_plots.R")
source("R/modules_table.R")
source("R/modules_download.R")
source("R/methodology.R")

# --- Carrega de dades (una unica vegada a l'inici) ---------------------
if (!file.exists(PATH_INDICADORS) || !file.exists(PATH_GEOMETRIES)) {
  stop(
    "No s'han trobat les dades processades. Executa primer:\n",
    "  Rscript scripts/01_generate_demo_data.R"
  )
}

app_data <- load_app_data()
indicadors_data <- app_data$indicadors
geometries_data <- app_data$geometries
filter_choices <- prepare_filter_choices(indicadors_data)

# --- Tema visual (sobri, blanc/gris/blau fosc) --------------------------
# S'evita bslib::font_google() deliberadament perque requereix connexio
# a internet en temps de compilacio del tema (pot fallar en entorns
# sense xarxa); s'usa en el seu lloc una pila de fonts de sistema.
app_theme <- bslib::bs_theme(
  version = 5,
  bg = "#FFFFFF",
  fg = "#1B2A4A",
  primary = COLOR_PRIMARY,
  secondary = COLOR_SECONDARY,
  base_font = bslib::font_collection(
    "-apple-system", "Segoe UI", "Roboto", "Helvetica Neue", "Arial", "sans-serif"
  ),
  heading_font = bslib::font_collection(
    "-apple-system", "Segoe UI", "Roboto", "Helvetica Neue", "Arial", "sans-serif"
  )
)

# --- UI ------------------------------------------------------------------
ui <- bslib::page_navbar(
  title = APP_TITLE,
  theme = app_theme,
  fillable = FALSE,
  header = shiny::tags$head(
    shiny::tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  sidebar = bslib::sidebar(
    width = 300,
    filtersUI("filtres", filter_choices)
  ),
  bslib::nav_panel(
    title = "Dashboard",
    shiny::div(
      class = "app-subtitle",
      APP_SUBTITLE
    ),
    kpisUI("kpis"),
    shiny::div(
      class = "download-row",
      downloadUI("download")
    ),
    bslib::navset_card_tab(
      bslib::nav_panel("Mapa territorial", mapUI("mapa")),
      bslib::nav_panel("Gràfics", plotsUI("grafics")),
      bslib::nav_panel("Taula d'indicadors", tableUI("taula"))
    )
  ),
  bslib::nav_panel(
    title = "Metodologia",
    methodology_ui()
  ),
  bslib::nav_spacer(),
  bslib::nav_item(shiny::tags$span("Dades simulades", class = "navbar-note"))
)

# --- Server ----------------------------------------------------------------
server <- function(input, output, session) {
  filtres_mod <- filtersServer("filtres", filter_choices)

  dades_filtrades <- shiny::reactive({
    f <- filtres_mod$filtres()
    apply_filters(
      indicadors_data,
      anys = f$anys,
      comarques = f$comarques,
      municipis = f$municipis
    )
  })

  dades_tendencia <- shiny::reactive({
    f <- filtres_mod$filtres()
    apply_filters(
      indicadors_data,
      anys = NULL,
      comarques = f$comarques,
      municipis = f$municipis
    )
  })

  kpisServer("kpis", dades_filtrades)
  mapServer("mapa", dades_filtrades, geometries_data, filtres_mod$indicador)
  plotsServer("grafics", dades_filtrades, dades_tendencia, filtres_mod$indicador)
  tableServer("taula", dades_filtrades, filtres_mod$indicador)
  downloadServer("download", dades_filtrades)
}

shiny::shinyApp(ui = ui, server = server)
