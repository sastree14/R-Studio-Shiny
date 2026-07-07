# tests/testthat.R
# Executor dels tests testthat del projecte. Cal executar-lo des de
# l'arrel del repositori (fa servir rutes relatives com "R/...").
#
# Us:
#   Rscript tests/testthat.R

library(testthat)

test_results <- test_dir("tests/testthat", reporter = "summary")
