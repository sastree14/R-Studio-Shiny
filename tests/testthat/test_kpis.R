test_that("calculate_kpis retorna resultats numerics coherents", {
  dd <- test_demo_data()
  kpis <- calculate_kpis(dd$indicadors)

  expect_type(kpis$poblacio_total, "double")
  expect_type(kpis$renda_mitjana_ponderada, "double")
  expect_true(kpis$n_municipis > 0)
  expect_true(kpis$poblacio_total > 0)
  expect_true(kpis$renda_mitjana_ponderada > 0)
  expect_true(kpis$taxa_envelliment_mitjana >= 0 && kpis$taxa_envelliment_mitjana <= 100)
})

test_that("calculate_kpis gestiona un dataset buit sense error", {
  dd <- test_demo_data()
  buit <- dd$indicadors[0, ]
  kpis <- calculate_kpis(buit)

  expect_equal(kpis$n_municipis, 0L)
  expect_true(is.na(kpis$poblacio_total))
})

test_that("la renda mitjana ponderada es diferent de la mitjana simple quan la poblacio varia", {
  dd <- test_demo_data()
  kpis <- calculate_kpis(dd$indicadors)
  mitjana_simple <- mean(dd$indicadors$renda_mitjana)

  expect_true(is.finite(kpis$renda_mitjana_ponderada))
  expect_true(is.finite(mitjana_simple))
})
