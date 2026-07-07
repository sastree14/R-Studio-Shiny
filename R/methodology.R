# methodology.R
# Contingut estatic de la pestanya "Metodologia": explica l'objectiu de
# l'app, l'origen de les dades, les variables, les limitacions i
# l'estructura del codi. Tot el text es en catala.

#' Construeix el contingut de la pestanya de metodologia
#'
#' @return Element HTML (tagList) amb el contingut de la pestanya.
methodology_ui <- function() {
  shiny::div(
    class = "methodology-panel",

    shiny::h3("Metodologia"),
    shiny::p(
      shiny::strong("Els valors mostrats corresponen a dades simulades amb finalitats demostratives."),
      " Aquesta aplicacio no representa dades oficials ni reals de cap territori, comarca o municipi."
    ),

    shiny::h4("Objectiu de l'aplicacio"),
    shiny::p(
      "Aquesta aplicacio te com a objectiu demostrar el desenvolupament d'un dashboard ",
      "professional en R Shiny per a l'exploracio d'indicadors territorials de salut i ",
      "demografia, integrant mapes interactius, grafics, taules i descarrega de dades ",
      "sobre una estructura de codi modular i mantenible."
    ),

    shiny::h4("Origen de les dades"),
    shiny::p(
      "Les dades es generen de manera sintetica i reproduible mitjancant l'script ",
      shiny::code("scripts/01_generate_demo_data.R"), ". Es simulen ", N_MUNICIPIS,
      " municipis fictícis agrupats en ", N_COMARQUES, " comarques fictícies, amb registres ",
      "anuals pels anys ", min(ANYS_DISPONIBLES), "-", max(ANYS_DISPONIBLES), "."
    ),
    shiny::p(
      "Les geometries territorials son una quadricula ('fishnet') simulada sobre una ",
      "zona geografica inspirada en Catalunya, agrupada en comarques mitjancant un ",
      "clustering espacial. No corresponen a limits administratius reals."
    ),

    shiny::h4("Variables disponibles"),
    shiny::tags$ul(
      shiny::tags$li(shiny::strong("Població:"), " nombre d'habitants estimat del municipi."),
      shiny::tags$li(shiny::strong("Renda mitjana:"), " renda familiar mitjana anual, en euros."),
      shiny::tags$li(shiny::strong("Taxa d'envelliment:"), " percentatge de poblacio de 65 anys o mes."),
      shiny::tags$li(shiny::strong("Incidència sanitària:"), " index sintetic de carrega assistencial per cada 10.000 habitants."),
      shiny::tags$li(shiny::strong("Índex de vulnerabilitat:"), " index compost (0-100) que combina renda i accessibilitat."),
      shiny::tags$li(shiny::strong("Accessibilitat a serveis:"), " index (0-100) d'accés a serveis basics (sanitat, educacio, transport).")
    ),

    shiny::h4("Relacions estadistiques simulades"),
    shiny::tags$ul(
      shiny::tags$li("Una renda mitjana i una accessibilitat mes baixes s'associen a un index de vulnerabilitat mes alt."),
      shiny::tags$li("Una taxa d'envelliment i una vulnerabilitat mes altes s'associen a una incidencia sanitaria mes alta."),
      shiny::tags$li("Cada municipi manté una tendencia temporal coherent al llarg dels anys, amb petites variacions aleatories.")
    ),

    shiny::h4("Limitacions"),
    shiny::tags$ul(
      shiny::tags$li("Les dades son totalment sintetiques i no s'han d'utilitzar per a cap analisi real."),
      shiny::tags$li("Els noms de municipis i comarques son fictícis."),
      shiny::tags$li("Les geometries son una simplificacio en quadricula, no limits administratius reals."),
      shiny::tags$li("Els indexs compostos (vulnerabilitat, incidencia) es calculen amb formules simplificades amb finalitats il·lustratives.")
    ),

    shiny::h4("Estructura del codi"),
    shiny::p("El projecte segueix una estructura modular per facilitar-ne el manteniment:"),
    shiny::tags$ul(
      shiny::tags$li(shiny::code("app.R"), ": punt d'entrada de l'aplicacio."),
      shiny::tags$li(shiny::code("R/"), ": funcions auxiliars i modols Shiny (dades, filtres, KPIs, mapa, grafics, taula, descarrega)."),
      shiny::tags$li(shiny::code("data/"), ": dades crues i processades."),
      shiny::tags$li(shiny::code("scripts/"), ": scripts reproduibles de generacio, validacio i smoke test."),
      shiny::tags$li(shiny::code("tests/"), ": tests automatics amb testthat."),
      shiny::tags$li(shiny::code("www/"), ": recursos estatics (CSS)."),
      shiny::tags$li(shiny::code(".github/workflows/"), ": workflow de validacio continua.")
    )
  )
}
