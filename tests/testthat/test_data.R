test_that("les dades demo es generen amb les columnes esperades", {
  dd <- test_demo_data()

  columnes_esperades <- c(
    "municipi_id", "municipi", "comarca", "any", "poblacio", "renda_mitjana",
    "taxa_envelliment", "incidencia_sanitaria", "index_vulnerabilitat",
    "accessibilitat_serveis"
  )

  expect_true(all(columnes_esperades %in% colnames(dd$indicadors)))
  expect_true(all(c("municipi_id", "municipi", "comarca") %in% colnames(dd$geometries)))
})

test_that("no hi ha poblacio negativa ni nul·la", {
  dd <- test_demo_data()
  expect_true(all(dd$indicadors$poblacio > 0))
})

test_that("els anys generats son els esperats", {
  dd <- test_demo_data()
  expect_setequal(unique(dd$indicadors$any), ANYS_DISPONIBLES)
})

test_that("els indicadors estan en rangs raonables", {
  dd <- test_demo_data()

  expect_true(all(dd$indicadors$renda_mitjana > 0))
  expect_true(all(dd$indicadors$taxa_envelliment >= 0 & dd$indicadors$taxa_envelliment <= 100))
  expect_true(all(dd$indicadors$index_vulnerabilitat >= 0 & dd$indicadors$index_vulnerabilitat <= 100))
  expect_true(all(dd$indicadors$accessibilitat_serveis >= 0 & dd$indicadors$accessibilitat_serveis <= 100))
  expect_true(all(dd$indicadors$incidencia_sanitaria >= 0))
})

test_that("municipi_id coincideix entre indicadors i geometries", {
  dd <- test_demo_data()
  expect_setequal(unique(dd$indicadors$municipi_id), unique(dd$geometries$municipi_id))
})

test_that("no hi ha files duplicades per municipi_id i any", {
  dd <- test_demo_data()
  duplicats <- duplicated(dd$indicadors[, c("municipi_id", "any")])
  expect_false(any(duplicats))
})
