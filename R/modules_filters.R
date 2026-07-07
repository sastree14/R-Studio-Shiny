# modules_filters.R
# Modul Shiny del panell de filtres: any, comarca, municipi (dependent
# de comarca) i indicador, amb botons "Actualitzar" i "Reiniciar filtres".
#
# El filtratge principal de l'aplicacio nomes s'actualitza quan l'usuari
# prem "Actualitzar" (o "Reiniciar filtres"), tal com demana
# l'especificacio funcional, per evitar recalculs innecessaris mentre
# es composa la seleccio.

filtersUI <- function(id, choices) {
  ns <- shiny::NS(id)

  shiny::tagList(
    shiny::h4("Filtres", class = "sidebar-title"),
    shiny::selectizeInput(
      ns("any"),
      label = "Any",
      choices = ANYS_DISPONIBLES,
      selected = ANYS_DISPONIBLES,
      multiple = TRUE
    ),
    shiny::selectizeInput(
      ns("comarca"),
      label = "Comarca",
      choices = choices$comarques,
      selected = choices$comarques,
      multiple = TRUE
    ),
    shiny::selectizeInput(
      ns("municipi"),
      label = "Municipi",
      choices = municipis_for_comarques(choices, choices$comarques),
      selected = municipis_for_comarques(choices, choices$comarques),
      multiple = TRUE
    ),
    shiny::selectInput(
      ns("indicador"),
      label = "Indicador",
      choices = INDICADORS_CHOICES,
      selected = INDICADORS_CHOICES[[1]]
    ),
    shiny::div(
      class = "filter-buttons",
      shiny::actionButton(ns("actualitzar"), "Actualitzar", class = "btn-primary btn-block"),
      shiny::actionButton(ns("reiniciar"), "Reiniciar filtres", class = "btn-outline-secondary btn-block")
    ),
    shiny::hr(),
    shiny::p(
      "Els valors mostrats corresponen a dades simulades amb finalitats demostratives.",
      class = "sidebar-note"
    )
  )
}

#' Server del modul de filtres
#'
#' @param id Identificador del modul.
#' @param choices Llista retornada per `prepare_filter_choices()`.
#' @return Llista de reactives: `filtres` (llista amb any/comarca/municipi
#'   aplicats nomes en prémer Actualitzar/Reiniciar) i `indicador`
#'   (reactiu, s'actualitza a l'instant).
filtersServer <- function(id, choices) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::observeEvent(input$comarca, {
      municipis_disponibles <- municipis_for_comarques(choices, input$comarca)
      municipis_seleccionats <- intersect(input$municipi, municipis_disponibles)
      if (length(municipis_seleccionats) == 0) {
        municipis_seleccionats <- municipis_disponibles
      }
      shiny::updateSelectizeInput(
        session, "municipi",
        choices = municipis_disponibles,
        selected = municipis_seleccionats
      )
    }, ignoreNULL = FALSE)

    # Estat dels filtres aplicats: nomes es modifica explicitament en
    # prémer "Actualitzar" o "Reiniciar filtres" (mai llegint els inputs
    # "en calent" en un cicle reactiu posterior), per evitar llegir
    # valors d'input encara no actualitzats pel client.
    filtres_state <- shiny::reactiveVal(list(
      anys = ANYS_DISPONIBLES,
      comarques = choices$comarques,
      municipis = municipis_for_comarques(choices, choices$comarques)
    ))

    shiny::observeEvent(input$actualitzar, {
      filtres_state(list(
        anys = if (length(input$any) == 0) ANYS_DISPONIBLES else as.integer(input$any),
        comarques = input$comarca,
        municipis = input$municipi
      ))
    }, ignoreNULL = FALSE)

    shiny::observeEvent(input$reiniciar, {
      shiny::updateSelectizeInput(session, "any", selected = ANYS_DISPONIBLES)
      shiny::updateSelectizeInput(session, "comarca", selected = choices$comarques)
      shiny::updateSelectizeInput(
        session, "municipi",
        choices = municipis_for_comarques(choices, choices$comarques),
        selected = municipis_for_comarques(choices, choices$comarques)
      )
      shiny::updateSelectInput(session, "indicador", selected = INDICADORS_CHOICES[[1]])

      filtres_state(list(
        anys = ANYS_DISPONIBLES,
        comarques = choices$comarques,
        municipis = municipis_for_comarques(choices, choices$comarques)
      ))
    })

    filtres <- shiny::reactive(filtres_state())

    indicador <- shiny::reactive({
      if (is.null(input$indicador) || input$indicador == "") INDICADORS_CHOICES[[1]] else input$indicador
    })

    list(
      filtres = filtres,
      indicador = indicador
    )
  })
}
