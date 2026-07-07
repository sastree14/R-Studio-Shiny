# Indicadors Territorials de Salut i Demografia

Aplicació demostrativa en **R Shiny** per a l'exploració d'indicadors territorials de salut i demografia, construïda com a exemple de portfolio professional: estructura modular, dades sintètiques reproduïbles, mapa interactiu (`leaflet` + `sf`), gràfics (`plotly`), taula interactiva (`reactable`), tests automàtics i un workflow de validació en GitHub Actions.

> ⚠️ **Totes les dades són simulades amb finalitats demostratives.** No representen cap territori, comarca o municipi real.

## Descripció

L'aplicació permet explorar, filtrar i comparar indicadors territorials (població, renda, envelliment, incidència sanitària, vulnerabilitat i accessibilitat a serveis) sobre un conjunt de municipis i comarques fictícies, mitjançant:

- un panell de filtres (any, comarca, municipi, indicador),
- KPIs agregats en temps real,
- un mapa territorial interactiu,
- quatre gràfics interactius,
- una taula d'indicadors filtrable i ordenable,
- descàrrega de les dades filtrades en CSV.

### Captura de l'aplicació

*(Placeholder: afegeix aquí una captura de pantalla, per exemple `www/screenshot.png`, un cop hagis executat l'app en local.)*

```
[ Captura de pantalla del dashboard ]
```

## Funcionalitats

- **Filtres**: any (multi-selecció), comarca (multi-selecció), municipi (dependent de la comarca seleccionada), indicador, botons "Actualitzar" i "Reiniciar filtres".
- **KPIs**: municipis seleccionats, població total, renda mitjana ponderada, taxa d'envelliment mitjana, incidència sanitària mitjana, índex de vulnerabilitat mitjà.
- **Mapa interactiu**: polígons territorials (quadrícula sf simulada) acolorits segons l'indicador seleccionat, amb tooltip i llegenda.
- **Gràfics interactius**: evolució temporal, rànquing de municipis, comparació per comarca, distribució de l'indicador.
- **Taula interactiva**: cercable, ordenable i paginada, amb la columna de l'indicador seleccionat ressaltada.
- **Descàrrega**: exportació CSV de les dades filtrades, amb la data al nom del fitxer.
- **Metodologia**: pestanya dedicada que explica l'origen de les dades, les variables i les limitacions.
- **Tests i validacions automàtiques** amb `testthat` i scripts dedicats.
- **Workflow manual de GitHub Actions** que valida instal·lació, dades, tests i arrencada de l'app.

## Stack tecnològic

| Àrea | Paquets |
|---|---|
| Framework web | `shiny`, `bslib`, `shinyWidgets` |
| Manipulació de dades | `dplyr`, `tidyr`, `readr`, `purrr`, `stringr`, `lubridate` |
| Visualització | `ggplot2`, `plotly`, `scales`, `htmltools` |
| Geoespacial | `leaflet`, `sf` |
| Taules | `reactable` |
| Tests | `testthat` |
| Gestió de dependències | `renv` |

## Estructura del repositori

```
R-Studio-Shiny/
├── app.R                       # Punt d'entrada de l'aplicació
├── README.md
├── renv.lock                   # Dependències bloquejades (renv)
├── .gitignore
├── .Rprofile
│
├── R/
│   ├── config.R                 # Constants i configuració global
│   ├── data_load.R              # Càrrega de dades processades
│   ├── data_generate.R          # Generació de dades sintètiques
│   ├── data_prepare.R           # Preparació de choices i joins
│   ├── filters.R                # Aplicació de filtres
│   ├── kpis.R                   # Càlcul de KPIs
│   ├── maps.R                   # Construcció del mapa leaflet
│   ├── plots.R                  # Gràfics plotly
│   ├── tables.R                 # Taula reactable
│   ├── utils.R                  # Formatació i utilitats
│   ├── methodology.R            # Contingut de la pestanya de metodologia
│   ├── modules_filters.R        # Mòdul Shiny: filtres
│   ├── modules_kpis.R           # Mòdul Shiny: KPIs
│   ├── modules_map.R            # Mòdul Shiny: mapa
│   ├── modules_plots.R          # Mòdul Shiny: gràfics
│   ├── modules_table.R          # Mòdul Shiny: taula
│   └── modules_download.R       # Mòdul Shiny: descàrrega
│
├── data/
│   ├── raw/                     # (buit; reservat per a dades crues futures)
│   └── processed/                # indicadors_territorials.rds, geometries_municipals.rds
│
├── scripts/
│   ├── 00_install_packages.R    # Instal·lació de paquets (alternativa a renv)
│   ├── 01_generate_demo_data.R  # Generació reproduïble de dades demo
│   ├── 02_validate_data.R       # Validació d'integritat de les dades
│   └── 03_smoke_test_app.R      # Comprovació que la app es construeix sense errors
│
├── tests/
│   └── testthat/
│       ├── helper-setup.R
│       ├── test_data.R
│       ├── test_kpis.R
│       └── test_filters.R
│
├── www/
│   ├── custom.css
│   └── logo_placeholder.txt
│
└── .github/
    └── workflows/
        └── shiny-check.yml      # Workflow manual de validació (GitHub Actions)
```

## Instal·lació local

### Requisits previs

- [R](https://cran.r-project.org/) ≥ 4.2
- [RStudio](https://posit.co/download/rstudio-desktop/) (recomanat, opcional)
- Git

### 1. Clonar el repositori

```bash
git clone https://github.com/sastree14/R-Studio-Shiny.git
cd R-Studio-Shiny
```

### 2. Restaurar dependències amb renv

```bash
Rscript -e "renv::restore()"
```

Si el projecte encara no té `renv` inicialitzat a la teva màquina, pots fer-ho tu mateix:

```r
renv::init()
renv::snapshot()
```

Alternativament, pots instal·lar els paquets directament sense `renv`:

```bash
Rscript scripts/00_install_packages.R
```

> **Nota sobre `renv.lock`:** el fitxer inclòs al repositori és una línia base amb els paquets directes i versions de referència, creada sense un entorn R disponible per executar `renv::snapshot()`. Es recomana regenerar-lo a la teva màquina un cop restaurat l'entorn:
>
> ```r
> renv::init()
> renv::snapshot()
> ```

### 3. Generar les dades demo

```bash
Rscript scripts/01_generate_demo_data.R
```

Això crea (de manera reproduïble, amb llavor fixa) els fitxers:

- `data/processed/indicadors_territorials.rds`
- `data/processed/geometries_municipals.rds`

### 4. (Opcional) Validar les dades i executar els tests

```bash
Rscript scripts/02_validate_data.R
Rscript tests/testthat.R
```

## Execució local

### Des de la terminal

```bash
Rscript -e "shiny::runApp('.', host = '127.0.0.1', port = 3838)"
```

Un cop arrencada, Shiny obrirà (o t'indicarà) un servidor local a:

```
http://127.0.0.1:3838
```

### Des de RStudio

1. Obre la carpeta del projecte a RStudio (`File > Open Project` o simplement obre `app.R`).
2. Assegura't d'haver restaurat les dependències (`renv::restore()`) i generat les dades (pas 3 anterior).
3. Obre `app.R`.
4. Prem el botó **"Run App"** a la part superior de l'editor.
5. RStudio obrirà una finestra (o el navegador) amb l'aplicació servida en `localhost`.

## Ús de l'aplicació

1. Selecciona els filtres desitjats al panell lateral (any, comarca, municipi, indicador).
2. Prem **"Actualitzar"** perquè el dashboard (KPIs, mapa, gràfics, taula) reflecteixi la selecció.
3. Prem **"Reiniciar filtres"** per tornar a l'estat inicial.
4. Explora el mapa, els gràfics i la taula des de les pestanyes internes del dashboard.
5. Utilitza el botó **"Descarregar dades"** per exportar en CSV les dades actualment filtrades.
6. Consulta la pestanya **"Metodologia"** per entendre l'origen i les limitacions de les dades.

## Workflow manual de GitHub Actions

El repositori inclou un workflow a [`.github/workflows/shiny-check.yml`](.github/workflows/shiny-check.yml) que **valida** el projecte de forma automatitzada. Es pot llançar:

- manualment, des de la pestanya **Actions → Shiny check → Run workflow** al repositori de GitHub;
- automàticament, en cada `push` o `pull request` cap a `main`.

El workflow:

1. Fa checkout del repositori.
2. Configura R.
3. Instal·la les dependències de sistema necessàries per a `sf` a Ubuntu.
4. Restaura els paquets amb `renv::restore()` (o `scripts/00_install_packages.R` si no hi ha `renv.lock`).
5. Genera les dades demo (`scripts/01_generate_demo_data.R`).
6. Valida les dades (`scripts/02_validate_data.R`).
7. Executa els tests amb `testthat`.
8. Executa el smoke test (`scripts/03_smoke_test_app.R`), que comprova que `app.R` carrega i que la UI/server es construeixen sense errors.
9. Opcionalment, arrenca la app durant unes desenes de segons dins del runner (amb `timeout`) només per confirmar que no crasha en iniciar-se.

**Important:** GitHub Actions s'executa en un runner remot i **no pot obrir cap navegador ni exposar-te un `localhost` visible des del teu ordinador**. El workflow serveix exclusivament per validar que el projecte instal·la dependències i arrenca correctament; per interactuar amb l'aplicació cal executar-la en local seguint les instruccions anteriors.

## Roadmap

- [ ] Afegir geometries territorials més realistes (p. ex. a partir de límits administratius oberts).
- [ ] Afegir un mode de comparació entre dos anys (mapa de diferències).
- [ ] Persistir un historial de descàrregues o exportar informes en PDF.
- [ ] Afegir autenticació bàsica per a un entorn multiusuari.
- [ ] Desplegament automàtic (p. ex. Shiny Server, Posit Connect o shinyapps.io) des del workflow.
- [ ] Ampliar la cobertura de tests (mòduls Shiny amb `shinytest2`).

## Bones pràctiques incloses

- Codi modularitzat (`R/` amb funcions pures + mòduls Shiny UI/server separats).
- Càrrega de dades una única vegada a l'inici de l'app (no dins de reactives).
- Filtratge principal controlat explícitament pel botó "Actualitzar".
- Dades sintètiques generades amb llavor fixa (reproduïbilitat).
- Gestió de dependències amb `renv`.
- Tests automàtics amb `testthat`.
- Scripts de validació de dades independents de l'aplicació.
- Smoke test que evita bloquejar processos no interactius (sense `runApp()` bloquejant).
- Workflow de CI (GitHub Actions) documentat i comentat.
- Estil visual consistent centralitzat a `www/custom.css`.

## Nota sobre les dades

Totes les dades d'aquest repositori (indicadors i geometries) són **sintètiques i generades algorísmicament** amb `scripts/01_generate_demo_data.R`. No s'ha utilitzat cap font de dades oficial ni real. Consulta la pestanya **"Metodologia"** dins de l'aplicació per a més detalls.

## Contacte / Autor

**Arnau Sastre**
Data & AI / Statistics / Decision Systems
