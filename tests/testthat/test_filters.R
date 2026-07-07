test_that("apply_filters sense arguments retorna totes les dades", {
  dd <- test_demo_data()
  filtrat <- apply_filters(dd$indicadors)
  expect_equal(nrow(filtrat), nrow(dd$indicadors))
})

test_that("apply_filters filtra correctament per any", {
  dd <- test_demo_data()
  any_sel <- min(dd$indicadors$any)
  filtrat <- apply_filters(dd$indicadors, anys = any_sel)

  expect_true(all(filtrat$any == any_sel))
  expect_true(nrow(filtrat) > 0)
})

test_that("apply_filters filtra correctament per comarca", {
  dd <- test_demo_data()
  comarca_sel <- dd$indicadors$comarca[1]
  filtrat <- apply_filters(dd$indicadors, comarques = comarca_sel)

  expect_true(all(filtrat$comarca == comarca_sel))
  expect_true(nrow(filtrat) > 0)
})

test_that("apply_filters filtra correctament per municipi", {
  dd <- test_demo_data()
  municipi_sel <- dd$indicadors$municipi[1]
  filtrat <- apply_filters(dd$indicadors, municipis = municipi_sel)

  expect_true(all(filtrat$municipi == municipi_sel))
  expect_true(nrow(filtrat) > 0)
})

test_that("apply_filters amb combinacio de filtres retorna un subconjunt valid", {
  dd <- test_demo_data()
  any_sel <- max(dd$indicadors$any)
  comarca_sel <- dd$indicadors$comarca[1]

  filtrat <- apply_filters(dd$indicadors, anys = any_sel, comarques = comarca_sel)

  expect_true(all(filtrat$any == any_sel))
  expect_true(all(filtrat$comarca == comarca_sel))
})

test_that("apply_filters retorna un tibble", {
  dd <- test_demo_data()
  filtrat <- apply_filters(dd$indicadors, anys = min(dd$indicadors$any))
  expect_s3_class(filtrat, "tbl_df")
})
