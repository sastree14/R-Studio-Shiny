# 03_smoke_test_app.R
# Smoke test de l'aplicacio: comprova que app.R existeix, que els
# paquets principals carreguen, que les dades existeixen (generant-les
# si cal), que totes les funcions de R/ es poden sourcejar sense error
# i que la app es pot construir (objecte shiny.appobj) sense errors.
#
# Deliberadament NO s'executa `shiny::runApp()` de manera bloquejant:
# fer-ho dins d'un script no interactiu deixaria el proces penjat
# indefinidament. En comptes d'aixo, es construeix l'objecte
# shiny::shinyApp() (ui + server) i es verifica que es correcte, cosa
# que ja detecta la gran majoria d'errors de construccio de la UI o
# d'inicialitzacio del server.
#
# Us:
#   Rscript scripts/03_smoke_test_app.R

errors <- character(0)
warn <- function(msg) errors <<- c(errors, msg)

message("=== Smoke test de l'aplicacio ===")

# 1. app.R existeix ----------------------------------------------------------
if (!file.exists("app.R")) {
  message("ERROR: no existeix app.R al directori arrel.")
  quit(status = 1)
}
message("[OK] app.R existeix.")

# 2. Paquets principals carreguen --------------------------------------------
paquets_principals <- c(
  "shiny", "bslib", "dplyr", "leaflet", "sf", "plotly", "reactable", "scales"
)
for (pkg in paquets_principals) {
  ok <- requireNamespace(pkg, quietly = TRUE)
  if (!ok) warn(paste("El paquet", pkg, "no esta instal·lat."))
}
if (length(errors) > 0) {
  message("ERRORS:\n - ", paste(errors, collapse = "\n - "))
  quit(status = 1)
}
message("[OK] Paquets principals disponibles.")

# 3. Dades existents (es generen si cal) --------------------------------------
source("R/config.R")

if (!file.exists(PATH_INDICADORS) || !file.exists(PATH_GEOMETRIES)) {
  message("Dades no trobades, generant-les amb 01_generate_demo_data.R...")
  source("scripts/01_generate_demo_data.R")
}

if (!file.exists(PATH_INDICADORS) || !file.exists(PATH_GEOMETRIES)) {
  message("ERROR: les dades no s'han pogut generar.")
  quit(status = 1)
}
message("[OK] Dades processades disponibles.")

# 4. Les funcions de R/ es poden sourcejar sense error ------------------------
fitxers_r <- list.files("R", pattern = "\\.R$", full.names = TRUE)
sourcing_ok <- TRUE
for (f in fitxers_r) {
  resultat <- tryCatch({
    source(f, local = new.env())
    TRUE
  }, error = function(e) {
    warn(paste0("Error sourcejant ", f, ": ", conditionMessage(e)))
    FALSE
  })
  sourcing_ok <- sourcing_ok && resultat
}
if (!sourcing_ok) {
  message("ERRORS:\n - ", paste(errors, collapse = "\n - "))
  quit(status = 1)
}
message("[OK] Tots els fitxers de R/ es sourcejen sense errors.")

# 5. La app es pot construir sense errors -------------------------------------
# Sourcejem app.R dins d'un entorn dedicat. `source()` no fa autoprint per
# defecte (echo = FALSE), de manera que l'objecte shiny::shinyApp() que
# retorna la darrera linia d'app.R NO s'arriba a imprimir ni, per tant,
# a executar amb runApp(). Aixo permet validar tota la construccio de la
# UI i del server sense arrencar un servidor Shiny real.
app_env <- new.env()
construccio_ok <- tryCatch({
  sys.source("app.R", envir = app_env)
  TRUE
}, error = function(e) {
  warn(paste("Error construint l'app:", conditionMessage(e)))
  FALSE
})

if (!construccio_ok) {
  message("ERRORS:\n - ", paste(errors, collapse = "\n - "))
  quit(status = 1)
}

if (!exists("ui", envir = app_env) || !exists("server", envir = app_env)) {
  message("ERROR: app.R no ha definit els objectes 'ui' i 'server' esperats.")
  quit(status = 1)
}

if (!is.function(app_env$server)) {
  message("ERROR: 'server' definit a app.R no es una funcio.")
  quit(status = 1)
}

message("[OK] La app es construeix correctament (UI i server definits).")
message("=== Smoke test superat correctament ===")
