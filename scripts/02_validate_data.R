# 02_validate_data.R
# Valida la integritat de les dades processades: existencia de fitxers,
# columnes requerides, rangs de variables, consistencia entre
# geometries i indicadors, i absencia de duplicats greus.
#
# Finalitza amb error (status != 0) si alguna validacio falla, cosa que
# el workflow de GitHub Actions utilitza per aturar-se en cas de dades
# incorrectes.
#
# Us:
#   Rscript scripts/02_validate_data.R

suppressPackageStartupMessages({
  library(sf)
})

source("R/config.R")

errors <- character(0)
warn <- function(msg) errors <<- c(errors, msg)

message("Validant dades processades...")

# 1. Existencia de fitxers -------------------------------------------------
if (!file.exists(PATH_INDICADORS)) warn(paste("No existeix", PATH_INDICADORS))
if (!file.exists(PATH_GEOMETRIES)) warn(paste("No existeix", PATH_GEOMETRIES))

if (length(errors) > 0) {
  message("ERRORS:\n - ", paste(errors, collapse = "\n - "))
  quit(status = 1)
}

indicadors <- readRDS(PATH_INDICADORS)
geometries <- readRDS(PATH_GEOMETRIES)

# 2. Columnes requerides ---------------------------------------------------
columnes_esperades <- c(
  "municipi_id", "municipi", "comarca", "any", "poblacio", "renda_mitjana",
  "taxa_envelliment", "incidencia_sanitaria", "index_vulnerabilitat",
  "accessibilitat_serveis"
)
columnes_absents <- setdiff(columnes_esperades, colnames(indicadors))
if (length(columnes_absents) > 0) {
  warn(paste("Falten columnes a indicadors:", paste(columnes_absents, collapse = ", ")))
}

columnes_geo_esperades <- c("municipi_id", "municipi", "comarca")
columnes_geo_absents <- setdiff(columnes_geo_esperades, colnames(geometries))
if (length(columnes_geo_absents) > 0) {
  warn(paste("Falten columnes a geometries:", paste(columnes_geo_absents, collapse = ", ")))
}

# 3. Rangs de variables ------------------------------------------------------
if ("poblacio" %in% colnames(indicadors) && any(indicadors$poblacio <= 0, na.rm = TRUE)) {
  warn("Hi ha valors de poblacio no positius.")
}
if ("renda_mitjana" %in% colnames(indicadors) &&
      any(indicadors$renda_mitjana < 0, na.rm = TRUE)) {
  warn("Hi ha valors de renda_mitjana negatius.")
}
if ("taxa_envelliment" %in% colnames(indicadors) &&
      any(indicadors$taxa_envelliment < 0 | indicadors$taxa_envelliment > 100, na.rm = TRUE)) {
  warn("Hi ha valors de taxa_envelliment fora de rang [0, 100].")
}
if ("index_vulnerabilitat" %in% colnames(indicadors) &&
      any(indicadors$index_vulnerabilitat < 0 | indicadors$index_vulnerabilitat > 100, na.rm = TRUE)) {
  warn("Hi ha valors de index_vulnerabilitat fora de rang [0, 100].")
}
if ("accessibilitat_serveis" %in% colnames(indicadors) &&
      any(indicadors$accessibilitat_serveis < 0 | indicadors$accessibilitat_serveis > 100, na.rm = TRUE)) {
  warn("Hi ha valors de accessibilitat_serveis fora de rang [0, 100].")
}
if ("any" %in% colnames(indicadors) &&
      !all(indicadors$any %in% ANYS_DISPONIBLES)) {
  warn("Hi ha valors d'any fora dels anys esperats.")
}

# 4. Consistencia entre geometries i indicadors -----------------------------
if ("municipi_id" %in% colnames(indicadors) && "municipi_id" %in% colnames(geometries)) {
  ids_indicadors <- unique(indicadors$municipi_id)
  ids_geometries <- unique(geometries$municipi_id)

  absents_a_geo <- setdiff(ids_indicadors, ids_geometries)
  if (length(absents_a_geo) > 0) {
    warn(paste0(
      length(absents_a_geo),
      " municipi_id presents a indicadors pero absents a geometries."
    ))
  }

  absents_a_indicadors <- setdiff(ids_geometries, ids_indicadors)
  if (length(absents_a_indicadors) > 0) {
    warn(paste0(
      length(absents_a_indicadors),
      " municipi_id presents a geometries pero absents a indicadors."
    ))
  }
}

# 5. Duplicats greus ---------------------------------------------------------
if (all(c("municipi_id", "any") %in% colnames(indicadors))) {
  n_duplicats <- sum(duplicated(indicadors[, c("municipi_id", "any")]))
  if (n_duplicats > 0) {
    warn(paste(n_duplicats, "files duplicades per (municipi_id, any) a indicadors."))
  }
}

if ("municipi_id" %in% colnames(geometries)) {
  n_duplicats_geo <- sum(duplicated(geometries$municipi_id))
  if (n_duplicats_geo > 0) {
    warn(paste(n_duplicats_geo, "municipi_id duplicats a geometries."))
  }
}

# --- Resultat final ----------------------------------------------------------
if (length(errors) > 0) {
  message("Validacio FALLIDA:\n - ", paste(errors, collapse = "\n - "))
  quit(status = 1)
}

message("Validacio superada correctament.")
message(" - ", nrow(indicadors), " files a indicadors")
message(" - ", nrow(geometries), " municipis a geometries")
