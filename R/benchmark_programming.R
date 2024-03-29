#' @title Programming benchmarks
#' @description A collection of matrix programming benchmark functions
#' \itemize{
#' \item 3,500,000 Fibonacci numbers calculation (vector calc).
#' \item Creation of a 3500x3500 Hilbert matrix (matrix calc).
#' \item Grand common divisors of 1,000,000 pairs (recursion).
#' \item Creation of a 1600x1600 Toeplitz matrix (loops).
#' \item Escoufier's method on a 60x60 matrix (mixed).
#' }
#' These benchmarks have been developed by many authors.
#' See http://r.research.att.com/benchmarks/R-benchmark-25.R
#' for a complete history. The function \code{benchmark_prog()} runs the five \code{bm} functions.
#' @inheritParams benchmark_std
#' @importFrom stats runif
#' @export
bm_prog_fib = function(runs = 3, verbose = TRUE) {
  a = 0; b = 0; phi = 1.6180339887498949 #nolint
  timings = data.frame(user = numeric(runs), system = 0, elapsed = 0,
                       test = "fib", test_group = "prog", stringsAsFactors = FALSE)
  for (i in 1:runs) {
    a = floor(runif(3500000) * 1000)
    invisible(gc())
    start = proc.time()
    b = (phi^a - (-phi) ^ (-a)) / sqrt(5)
    stop = proc.time()
    timings[i, 1:3] = (stop - start)[1:3]
  }
  if (verbose)
    message(c("\t3,500,000 Fibonacci numbers calculation (vector calc)", timings_mean(timings)))
  timings
}

#' @rdname bm_prog_fib
#' @export
bm_prog_hilbert = function(runs = 3, verbose = TRUE) {
  a = 3500; b = 0 #nolint
  timings = data.frame(user = numeric(runs), system = 0, elapsed = 0,
                       test = "hilbert", test_group = "prog", stringsAsFactors = FALSE)
  for (i in 1:runs) {
    invisible(gc())
    start = proc.time()
    b = rep(1:a, a); dim(b) = c(a, a) #nolint
    b = 1 / (t(b) + 0:(a - 1))
    stop = proc.time()
    timings[i, 1:3] = (stop - start)[1:3]
  }
  if (verbose)
    message(c("\tCreation of a 3,500 x 3,500 Hilbert matrix (matrix calc)", timings_mean(timings)))
  timings
}

#' @rdname bm_prog_fib
#' @export
bm_prog_gcd = function(runs = 3, verbose = TRUE) {
  ans = 0
  timings = data.frame(user = numeric(runs), system = 0, elapsed = 0,
                       test = "gcd", test_group = "prog", stringsAsFactors = FALSE)
  gcd2 = function(x, y) {
    if (sum(y > 1.0E-4) == 0) {
      x
    } else {
      y[y == 0] = x[y == 0]
      Recall(y, x %% y)
    }
  }
  for (i in 1:runs) {
    a = ceiling(runif(1000000) * 1000)
    b = ceiling(runif(1000000) * 1000)
    invisible(gc())
    start = proc.time()
    ans = gcd2(a, b)# gcd2 is a recursive function
    stop = proc.time()
    timings[i, 1:3] = (stop - start)[1:3]
  }
  if (verbose)
    message(c("\tGrand common divisors of 1,000,000 pairs (recursion)", timings_mean(timings)))
  timings
}

#' @rdname bm_prog_fib
#' @export
bm_prog_toeplitz = function(runs = 3, verbose = TRUE) {
  timings = data.frame(user = numeric(runs), system = 0, elapsed = 0,
                       test = "toeplitz", test_group = "prog",
                       stringsAsFactors = FALSE)
  N = 3000 #nolint
  ans = rep(0, N * N)
  dim(ans) = c(N, N)
  for (i in 1:runs) {
    invisible(gc())
    start = proc.time()
    for (j in 1:N) {
      for (k in 1:N) {
        ans[k, j] = abs(j - k) + 1
      }
    }
    stop = proc.time()
    timings[i, 1:3] = (stop - start)[1:3]
  }
  if (verbose)
    message(c("\tCreation of a 3,000 x 3,000 Toeplitz matrix (loops)", timings_mean(timings)))
  timings
}


#' @importFrom stats cor
#' @rdname bm_prog_fib
#' @export
bm_prog_escoufier = function(runs = 3, verbose = TRUE) {
  timings = data.frame(user = numeric(runs), system = 0, elapsed = 0,
                       test = "escoufier", test_group = "prog",
                       stringsAsFactors = FALSE)
  p = 0; vt = 0; vr = 0; vrt = 0; rvt = 0; RV = 0; j = 0; k = 0; #nolint
  x2 = 0; R = 0; r_xx = 0; r_yy = 0; r_xy = 0; r_yx = 0; r_vmax = 0    #nolint
  # Calculate the trace of a matrix (sum of its diagonal elements)
  tr = function(y) {
    sum(c(y)[1 + 0:(min(dim(y)) - 1) * (dim(y)[1] + 1)], na.rm = FALSE)
  }
  for (i in 1:runs) {
    x = abs(Rnorm(60 * 60))
    dim(x) = c(60, 60)
    invisible(gc())
    start = proc.time()
    # Calculation of Escoufier's equivalent vectors
    p = ncol(x)
    vt = 1:p                                  # Variables to test
    vr = NULL                                 # Result: ordered variables
    rv_cor = 1:p                                  # Result: correlations #nolint
    vrt = NULL
    # loop on the variable number
    for (j in 1:p) {
      r_vmax = 0
      # loop on the variables
      for (k in 1:(p - j + 1)) {
        x2 = cbind(x, x[, vr], x[, vt[k]])
        R = cor(x2)                           # Correlations table #nolint
        r_yy = R[1:p, 1:p]
        r_xx = R[(p + 1):(p + j), (p + 1):(p + j)]
        r_xy = R[(p + 1):(p + j), 1:p]
        r_yx = t(r_xy)
        rvt = tr(r_yx %*% r_xy) / sqrt(tr(r_yy %*% r_yy) * tr(r_xx %*% r_xx)) # rv_cor calculation
        if (rvt > r_vmax) {
          r_vmax = rvt                         # test of rv_cor
          vrt = vt[k]                         # temporary held variable
        }
      }
      vr[j] = vrt                             # Result: variable
      rv_cor[j] = r_vmax                           # Result: correlation
      vt = vt[vt != vr[j]]                      # reidentify variables to test
    }
    stop = proc.time()

    timings[i, 1:3] = (stop - start)[1:3]
  }
  if (verbose)
    message(c("\tEscoufier's method on a 60 x 60 matrix (mixed)", timings_mean(timings)))
  timings
}
