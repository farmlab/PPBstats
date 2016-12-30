% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/mean.comparisons.R
\name{mean_comparisons}
\alias{mean_comparisons}
\title{Get mean comparisons for a given parameter two by two or to a given threshold based on MCMC outputs}
\usage{
mean_comparisons(out_check_model, parameter, alpha = 0.05, type = 1,
  threshold = 1, p.adj = "soft.bonf", get.at.least.X.groups = 2,
  precision = 5e-04)
}
\arguments{
\item{parameter}{The parameter on which the mean comparison is done}

\item{alpha}{The level of type one error. 0.05 (5\%) by default}

\item{type}{The type of comparisons. 1 for comparison two by two. 2 for comparison to a specific threshold.}

\item{threshold}{For type = 2. The threshold to which a parameter is different}

\item{p.adj}{For type = 1. NULL for no adjustement of the type one error. "soft.bonf" for a soft bonferonni correction to take into account multiple comparisons (alpha / nb of parameters).}

\item{get.at.least.X.groups}{For type = 1. If there are only one group with alpha, the minimum number of groups wanted with a higher type one error (i.e. lower confidence). If NULL, nothing is done.}

\item{precision}{For type = 1. The precision of the alpha with the correspondong groups from get.at.least.X.groups. The smaller the better, but the smaller the more time consuming due to computing matters}

\item{MCMC}{MCMC outputs from \code{analysis.outputs}.}
}
\value{
The function returns a data frame with the following columns: parameter, median, groups, number of groups, type one error and correction used
}
\description{
\code{get.mean.comparisons} performs mean comparisons two by two or to a given threshold based on MCMC outputs
}
\details{
The comparisons is based on the probability of having a common distribution for each pair of parameters.
When there is only one group with the value of alpha, the function (via \code{get.at.least.X.groups argument}) returns at least X groups with a new value of alpha.
More details in the vignette (type vignette ("PPBstats")).
}
\author{
Pierre Riviere
}
\seealso{
\code{\link{analyse.outputs}}, \code{\link{comp.parameters}}, \code{\link{get.significant.groups}}, \code{\link{get.at.least.X.groups}}, \code{\link{get.ggplot}}
}
