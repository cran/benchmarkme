% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/benchmark_std.R
\name{benchmark_std}
\alias{benchmark_std}
\title{Run standard benchmarks}
\usage{
benchmark_std(runs = 3, verbose = TRUE)
}
\arguments{
\item{runs}{Number of times to run the test. Default 3.}

\item{verbose}{Default TRUE.}
}
\description{
This function runs a set of standard benchmarks, which should be suitable for most
machines. It runs a collection of matrix benchmark functions
\itemize{
\item \code{benchmark_prog}
\item \code{benchmark_matrix_cal}
\item \code{benchmark_matrix_fun}
}
To view the list of benchmarks, see \code{get_available_benchmarks}.
}
\examples{
## Benchmark your system
\dontrun{
res = benchmark_std(3)

## Plot results
plot(res)
}
}
