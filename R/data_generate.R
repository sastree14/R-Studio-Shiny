# data_generate.R
# Generacio de dades sintetiques: geometries territorials fictícies (sf)
# i indicadors territorials tabulars, amb coherencia estadistica i
# correlacions raonables entre variables. Cridat des de
# scripts/01_generate_demo_data.R.

#' Genera els noms fictícis de comarques i municipis
#'
#' @param n_municipis Nombre de municipis a generar.
#' @return Vector de caracters amb noms de municipi unics.
generate_municipi_names <- function(n_municipis = N_MUNICIPIS) {
  prefixos <- c(
    "Vila", "Puig", "Riu", "Camp", "Torre", "Mont", "Font", "Roca",
    "Prat", "Serra", "Vall", "Pla", "Coma", "Bosc", "Sot", "Molí"
  )
  sufixos <- c(
    "blava", "serrat", "fred", "major", "nou", "clar", "verd", "alt",
    "baix", "llarg", "dolç", "sec", "gran", "petit", "florit", "vell"
  )

  combinacions <- expand.grid(prefix = prefixos, suffix = sufixos, stringsAsFactors = FALSE)
  noms <- paste0(combinacions$prefix, combinacions$suffix)
  noms <- unique(noms)

  if (length(noms) < n_municipis) {
    stop("No hi ha prou combinacions de noms per generar ", n_municipis, " municipis.")
  }

  sample(noms, size = n_municipis, replace = FALSE)
}

#' Genera noms fictícis de comarques
#'
#' @param n_comarques Nombre de comarques a generar.
#' @return Vector de caracters amb noms de comarca.
generate_comarca_names <- function(n_comarques = N_COMARQUES) {
  noms <- c(
    "Vallnera", "Serralada Blava", "Plana del Ter", "Costa del Migdia",
    "Comarca de l'Alba", "Terraprima", "Vall Serena", "Altiplà Nord",
    "Ribera Clara", "Marges del Sud", "Comarca del Freser", "Plana Alta"
  )
  noms[seq_len(n_comarques)]
}

#' Genera les geometries territorials fictícies (sf) i l'assignacio a comarques
#'
#' Crea una quadricula territorial ("fishnet") sobre una bounding box
#' inspirada en Catalunya i agrupa les cel·les en comarques mitjancant
#' un clustering espacial (kmeans sobre els centroides), de manera que
#' cada comarca resulti geograficament compacta.
#'
#' @param n_municipis Nombre de municipis (cel·les) a generar.
#' @param n_comarques Nombre de comarques (grups) a generar.
#' @param seed Llavor per a la reproduibilitat.
#' @return Objecte sf amb columnes municipi_id, municipi, comarca, geometry.
generate_geometries <- function(n_municipis = N_MUNICIPIS,
                                 n_comarques = N_COMARQUES,
                                 seed = SEED_GENERACIO) {
  set.seed(seed)

  # Bounding box aproximat inspirat en Catalunya (WGS84), nomes amb
  # finalitats il·lustratives.
  bbox_sfc <- sf::st_as_sfc(
    sf::st_bbox(c(xmin = 0.2, ymin = 40.6, xmax = 3.3, ymax = 42.8), crs = sf::st_crs(4326))
  )

  ncol_grid <- ceiling(sqrt(n_municipis * 1.4))
  nrow_grid <- ceiling(n_municipis / ncol_grid)

  grid <- sf::st_make_grid(bbox_sfc, n = c(ncol_grid, nrow_grid), what = "polygons")
  grid <- grid[seq_len(n_municipis)]

  centroides <- sf::st_coordinates(sf::st_centroid(grid))

  clustering <- stats::kmeans(centroides, centers = n_comarques, nstart = 10)

  noms_municipi <- generate_municipi_names(n_municipis)
  noms_comarca <- generate_comarca_names(n_comarques)

  municipis_sf <- sf::st_sf(
    municipi_id = sprintf("M%03d", seq_len(n_municipis)),
    municipi = str_capitalize(noms_municipi),
    comarca = noms_comarca[clustering$cluster],
    geometry = grid,
    crs = sf::st_crs(4326)
  )

  municipis_sf
}

#' Genera el dataset tabular d'indicadors territorials per a tots els anys
#'
#' Cada municipi te un conjunt de factors latents (mida poblacional base,
#' renda base, envelliment base, accessibilitat base) que es mantenen
#' consistents en el temps i que determinen, amb soroll aleatori i una
#' lleugera tendencia temporal, els valors anuals de cada indicador.
#' La vulnerabilitat es construeix a partir de la renda i l'accessibilitat
#' (relacio negativa) i la incidencia sanitaria a partir de l'envelliment
#' i la vulnerabilitat (relacio positiva), tal com s'espera d'un indicador
#' d'aquest tipus.
#'
#' @param municipis_sf Objecte sf generat per `generate_geometries()`.
#' @param anys Vector d'anys a generar.
#' @param seed Llavor per a la reproduibilitat.
#' @return Tibble amb els indicadors territorials per municipi i any.
generate_indicadors_data <- function(municipis_sf,
                                      anys = ANYS_DISPONIBLES,
                                      seed = SEED_GENERACIO) {
  set.seed(seed + 1L)

  n <- nrow(municipis_sf)
  municipi_ids <- municipis_sf$municipi_id

  base_size <- exp(stats::rnorm(n, mean = log(8000), sd = 1.1))
  base_renda <- stats::runif(n, 18000, 45000)
  base_envelliment <- stats::runif(n, 10, 35)
  base_accessibilitat <- stats::runif(n, 0, 100)

  base_vulnerabilitat <- pmin(100, pmax(0,
    100 - scales::rescale(base_renda, to = c(0, 60)) -
      scales::rescale(base_accessibilitat, to = c(0, 30)) +
      stats::rnorm(n, 0, 8)
  ))

  base_incidencia <- pmin(500, pmax(50,
    50 + scales::rescale(base_envelliment, to = c(0, 250)) +
      scales::rescale(base_vulnerabilitat, to = c(0, 150)) +
      stats::rnorm(n, 0, 30)
  ))

  any_base <- min(anys)

  registres <- purrr::map_dfr(anys, function(any_actual) {
    t <- any_actual - any_base
    tibble::tibble(
      municipi_id = municipi_ids,
      any = any_actual,
      poblacio = round(base_size * (1 + 0.01 * t) * exp(stats::rnorm(n, 0, 0.02))),
      renda_mitjana = round(base_renda * (1 + 0.015 * t) + stats::rnorm(n, 0, 400)),
      taxa_envelliment = round(pmin(35, pmax(10, base_envelliment + 0.3 * t + stats::rnorm(n, 0, 1))), 1),
      incidencia_sanitaria = round(pmin(500, pmax(50, base_incidencia + stats::rnorm(n, 0, 15)))),
      index_vulnerabilitat = round(pmin(100, pmax(0, base_vulnerabilitat + stats::rnorm(n, 0, 3))), 1),
      accessibilitat_serveis = round(pmin(100, pmax(0, base_accessibilitat + 0.2 * t + stats::rnorm(n, 0, 3))), 1)
    )
  })

  taula_municipis <- sf::st_drop_geometry(municipis_sf)[, c("municipi_id", "municipi", "comarca")]

  registres <- dplyr::left_join(registres, taula_municipis, by = "municipi_id")
  registres <- registres[, c(
    "municipi_id", "municipi", "comarca", "any", "poblacio", "renda_mitjana",
    "taxa_envelliment", "incidencia_sanitaria", "index_vulnerabilitat",
    "accessibilitat_serveis"
  )]

  tibble::as_tibble(registres)
}

#' Genera el conjunt complet de dades demo (geometries + indicadors)
#'
#' @return Llista amb dos elements: `indicadors` (tibble) i `geometries` (sf).
generate_demo_data <- function() {
  geometries <- generate_geometries()
  indicadors <- generate_indicadors_data(geometries)

  list(
    indicadors = indicadors,
    geometries = geometries
  )
}
