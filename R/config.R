# config.R
# Configuracio global de l'aplicacio: constants, rutes i parametres
# compartits per la resta de modols i scripts.

APP_TITLE <- "Indicadors Territorials de Salut i Demografia"
APP_SUBTITLE <- "Aplicació demostrativa en R Shiny per a l'exploració d'indicadors territorials"

# Rutes de dades processades
PATH_INDICADORS <- file.path("data", "processed", "indicadors_territorials.rds")
PATH_GEOMETRIES <- file.path("data", "processed", "geometries_municipals.rds")

# Parametres de generacio de dades sinteticas
N_MUNICIPIS <- 60L
N_COMARQUES <- 8L
ANYS_DISPONIBLES <- 2020:2024
SEED_GENERACIO <- 2024L

# Definicio dels indicadors disponibles a l'aplicacio
# `id` es el nom de columna al dataset, `label` el text catala mostrat,
# `format` indica com formatar el valor (nombre, moneda, percentatge, index)
INDICADORS <- list(
  poblacio = list(
    id = "poblacio",
    label = "Població",
    format = "nombre",
    palette = "Blues"
  ),
  renda_mitjana = list(
    id = "renda_mitjana",
    label = "Renda mitjana",
    format = "moneda",
    palette = "Greens"
  ),
  taxa_envelliment = list(
    id = "taxa_envelliment",
    label = "Taxa d'envelliment",
    format = "percentatge",
    palette = "Oranges"
  ),
  incidencia_sanitaria = list(
    id = "incidencia_sanitaria",
    label = "Incidència sanitària",
    format = "index",
    palette = "Reds"
  ),
  index_vulnerabilitat = list(
    id = "index_vulnerabilitat",
    label = "Índex de vulnerabilitat",
    format = "index",
    palette = "Purples"
  ),
  accessibilitat_serveis = list(
    id = "accessibilitat_serveis",
    label = "Accessibilitat a serveis",
    format = "index",
    palette = "PuBu"
  )
)

INDICADORS_CHOICES <- setNames(
  vapply(INDICADORS, function(x) x$id, character(1)),
  vapply(INDICADORS, function(x) x$label, character(1))
)

# Paleta de colors general de l'aplicacio (estil sobri blanc/gris/blau fosc)
COLOR_PRIMARY <- "#1B2A4A"
COLOR_SECONDARY <- "#4A6FA5"
COLOR_BACKGROUND <- "#F5F6F8"
COLOR_MUTED <- "#8A94A6"
