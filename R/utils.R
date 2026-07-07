# utils.R
# Funcions auxiliars d'us general: formatacio de numeros, generacio de
# paletes de color i petites utilitats compartides per la resta de l'app.

#' Formata un valor numeric segons el tipus d'indicador
#'
#' @param value Valor numeric a formatar.
#' @param format Tipus de format: "nombre", "moneda", "percentatge", "index".
#' @return Text formatat en catala.
format_indicador <- function(value, format = c("nombre", "moneda", "percentatge", "index")) {
  format <- match.arg(format)

  if (is.na(value)) {
    return("--")
  }

  switch(format,
    nombre = scales::label_number(big.mark = ".", decimal.mark = ",", accuracy = 1)(value),
    moneda = paste0(scales::label_number(big.mark = ".", decimal.mark = ",", accuracy = 1)(value), " EUR"),
    percentatge = scales::label_percent(accuracy = 0.1, decimal.mark = ",")(value / 100),
    index = scales::label_number(big.mark = ".", decimal.mark = ",", accuracy = 0.1)(value)
  )
}

#' Retorna la definicio (label, format, palette) d'un indicador a partir del seu id
#'
#' @param indicador_id Identificador de l'indicador (nom de columna).
#' @return Llista amb la definicio de l'indicador.
get_indicador_def <- function(indicador_id) {
  match <- Filter(function(x) x$id == indicador_id, INDICADORS)
  if (length(match) == 0) {
    stop("Indicador desconegut: ", indicador_id)
  }
  match[[1]]
}

#' Genera una paleta de colors continua per a un indicador donat
#'
#' @param indicador_id Identificador de l'indicador.
#' @param values Vector numeric de valors sobre els quals mapejar la paleta.
#' @return Funcio de paleta de colors (colorNumeric de leaflet).
palette_for_indicador <- function(indicador_id, values) {
  def <- get_indicador_def(indicador_id)
  leaflet::colorNumeric(
    palette = def$palette,
    domain = values,
    na.color = "#D9D9D9"
  )
}

#' Capitalitza la primera lletra d'un text
#'
#' @param text Vector de text.
#' @return Vector de text amb la primera lletra en majuscula.
str_capitalize <- function(text) {
  paste0(toupper(substring(text, 1, 1)), substring(text, 2))
}

#' Construeix un nom de fitxer amb la data actual
#'
#' @param prefix Prefix del nom de fitxer.
#' @param ext Extensio del fitxer (sense punt).
#' @return Text amb el nom de fitxer.
build_filename_with_date <- function(prefix, ext = "csv") {
  sprintf("%s_%s.%s", prefix, format(Sys.Date(), "%Y%m%d"), ext)
}
