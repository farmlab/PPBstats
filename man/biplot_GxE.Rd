% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/biplot_GxE.R
\name{biplot_GxE}
\alias{biplot_GxE}
\title{Compute ecovalence and format PCA results}
\usage{
biplot_GxE(out_check_model_GxE)
}
\arguments{
\item{out_check_model_GxE}{Output from \code{\link{check_model}} with \code{\link{GxE}}}
}
\value{
The function returns a list with:
\itemize{
\item info : a list with variable and gxe_analysis
\item data_ecovalence : the ecovalence matrix
\item pca : the pca object
}
}
\description{
\code{biplot_GxE} computes ecovalence and format PCA results from \code{\link{check_model}} with \code{\link{GxE}}
}
\details{
The ecovalence is the interaction matrix squared.
}
\author{
Pierre Riviere
}
\seealso{
\itemize{
\item \code{\link{check_model}},
\item \code{\link{check_model_GxE}},
\item \code{\link{get_ggplot}},
\item \code{\link{ggplot_biplot_GxE}}
}
}

