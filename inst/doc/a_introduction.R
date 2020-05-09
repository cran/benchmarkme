## ---- eval=FALSE--------------------------------------------------------------
#  install.packages("benchmarkme")

## ----eval=FALSE---------------------------------------------------------------
#  library("benchmarkme")
#  ## Increase runs if you have a higher spec machine
#  res = benchmark_std(runs = 3)

## ---- eval=FALSE--------------------------------------------------------------
#  ## You can control exactly what is uploaded. See details below.
#  upload_results(res)

## ----eval=FALSE---------------------------------------------------------------
#  plot(res)

## ----eval=FALSE---------------------------------------------------------------
#  res_io = benchmark_io(runs = 3)
#  upload_results(res_io)
#  plot(res_io)

## ----eval=FALSE---------------------------------------------------------------
#  tempdir()

## ----eval=FALSE---------------------------------------------------------------
#  Sys.getenv("TMPDIR")

## ----eval=FALSE---------------------------------------------------------------
#  res_io = benchmark_io(tmpdir = "some_other_directory")

## ----eval=FALSE---------------------------------------------------------------
#  res_io = benchmark_std(runs = 3, cores = 4)

## -----------------------------------------------------------------------------
data(past_results, package = "benchmarkmeData")

## -----------------------------------------------------------------------------
data(past_results_v2, package = "benchmarkmeData")

## ----eval=FALSE---------------------------------------------------------------
#  upload_results(res, args = list(sys_info = FALSE))

