# kpis.R
# Calcul dels KPIs principals mostrats al dashboard a partir del dataset
# ja filtrat.

#' Calcula els KPIs principals per a un conjunt de dades filtrat
#'
#' @param dades_filtrades Tibble d'indicadors ja filtrat (any/comarca/municipi).
#' @return Llista amb els KPIs numerics principals.
calculate_kpis <- function(dades_filtrades) {
  if (nrow(dades_filtrades) == 0) {
    return(list(
      n_municipis = 0L,
      poblacio_total = NA_real_,
      renda_mitjana_ponderada = NA_real_,
      taxa_envelliment_mitjana = NA_real_,
      incidencia_sanitaria_mitjana = NA_real_,
      index_vulnerabilitat_mitja = NA_real_
    ))
  }

  poblacio_total <- sum(dades_filtrades$poblacio, na.rm = TRUE)

  renda_mitjana_ponderada <- if (poblacio_total > 0) {
    stats::weighted.mean(dades_filtrades$renda_mitjana, w = dades_filtrades$poblacio, na.rm = TRUE)
  } else {
    mean(dades_filtrades$renda_mitjana, na.rm = TRUE)
  }

  list(
    n_municipis = length(unique(dades_filtrades$municipi_id)),
    poblacio_total = poblacio_total,
    renda_mitjana_ponderada = renda_mitjana_ponderada,
    taxa_envelliment_mitjana = mean(dades_filtrades$taxa_envelliment, na.rm = TRUE),
    incidencia_sanitaria_mitjana = mean(dades_filtrades$incidencia_sanitaria, na.rm = TRUE),
    index_vulnerabilitat_mitja = mean(dades_filtrades$index_vulnerabilitat, na.rm = TRUE)
  )
}
