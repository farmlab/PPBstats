% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/mean_comparisons.R
\name{mean_comparisons}
\alias{mean_comparisons}
\title{Get mean comparisons}
\usage{
mean_comparisons(out_check_model, parameter, alpha = 0.05, type = 1,
  get.at.least.X.groups = 2, precision = 5e-04, threshold = 1,
  p.adj = "soft.bonf")
}
\arguments{
\item{out_check_model}{outputs from \code{\link{check_model}} or \code{\link{predict_the_past_model_2}}}

\item{parameter}{parameter on which the mean comparison is done. Used only for \code{\link{check_model}} from \code{\link{model_1}} and \code{\link{model_2}}.
The possible values are:
\itemize{
 \item for \code{\link{check_model}} from \code{\link{model_1}} : "mu", "beta"
 \item for \code{\link{check_model}} from \code{\link{model_2}} : 'alpha", "beta", "theta"
}}

\item{alpha}{level of type one error. 0.05 (5\%) by default}

\item{type}{type of comparisons. 1 for comparison two by two. 2 for comparison to a specific threshold.
Only for \code{\link{check_model}} from \code{\link{model_1}}, from \code{\link{model_2}} and from \code{\link{predict_the_past_model_2}}}

\item{get.at.least.X.groups}{For type = 1. If there are only one group with alpha, the minimum number of groups wanted with a higher type one error (i.e. lower confidence). If NULL, nothing is done.}

\item{precision}{For type = 1. The precision of the alpha with the correspondong groups from get.at.least.X.groups. The smaller the better, but the smaller the more time consuming due to computing matters}

\item{threshold}{For type = 2. The threshold to which a parameter is different}

\item{p.adj}{For all excpet type = 2. NULL for no adjustement of the type one error.
For \code{check_model} of model_1, model_2 and predict_the_past_model_2, p.adj can be NULL or "soft.bonf".
For \code{check_model} of GxE, p.adj can be NULL, "holm", "hochberg", "bonferroni", "BH", "BY" or "fdr". see p.adjust() p-adj = "none" is t-student.}
}
\value{
\itemize{
 \item From \code{\link{check_model}} from \code{\link{GxE}}, list of four elements :
  \itemize{
   \item info : a list with variable and gxe_analysis
   \item data_ggplot_LSDbarplot_germplasm
   \item data_ggplot_LSDbarplot_location
   \item data_ggplot_LSDbarplot_year
  }

 \item From \code{\link{check_model}} from \code{\link{model_1}}, list of three elements :
  \itemize{
   \item data_mean_comparisons a list with as many elements as environment.
   Each element of the list is composed of two elements:
   \itemize{
    \item mean.comparisons: a dataframe with the following columns : parameter, median, groups, number of groups, alpha (type one error), alpha.correction (correction used), entry, environment, location and year.
    \item Mpvalue : a square matrix with pvalue computed for each pair of parameter.
   }

   \item data_env_with_no_controls a list with as many elements as environment.
   In each list it is mean.comparisons : a dataframe with the following columns : parameter, median, groups, number of groups, alpha (type one error), alpha.correction (correction used), entry, environment, location and year.

   \item data_env_whose_param_did_not_converge  a list with as many elements as environment.
    In each list it is mean.comparisons : a dataframe with the following columns : entry, germplasm, environment, block, X, Y, ID, median, parameter.
  }

 \item From \code{\link{check_model}} from \code{\link{model_2}} : A list of two elements:
   \itemize{
    \item mean.comparisons: a dataframe with the following columns : parameter, median, groups, number of groups, alpha (type one error), alpha.correction (correction used), entry, environment, location and year.
    \item Mpvalue : a square matrix with pvalue computed for each pair of parameter.
   }

 \item From \code{\link{predict_the_past_model_2}} a list of one element : data_mean_comparisons, composed of a list of one element for the given environment choose, being a list of two elements:
   \itemize{
    \item mean.comparisons: a dataframe with the following columns : parameter, median, groups, number of groups, alpha (type one error), alpha.correction (correction used), entry, environment, location and year.
    \item Mpvalue : a square matrix with pvalue computed for each pair of parameter.
   }
}
}
\description{
\code{mean_comparisons} performs mean comparisons from object coming from \code{\link{check_model}} or \code{\link{predict_the_past_model_2}}
}
\details{
parameter is set to "mu" by default for \code{\link{check_model}} from \code{\link{predict_the_past_model_2}}

p.adj = "soft.bonf" for a soft bonferonni correction to take into account multiple comparisons (alpha / nb of parameters)..
It is the default for \code{\link{check_model}} from \code{\link{model_1}}, from \code{\link{model_2}} and from \code{\link{predict_the_past_model_2}}

The comparisons is based on the probability of having a common distribution for each pair of parameter.

When there is only one group with the value of alpha, the function (via \code{get.at.least.X.groups argument}) returns at least X groups with a new value of alpha.
}
\author{
Pierre Riviere
}
\seealso{
\itemize{
 \item \code{\link{check_model}},
 \item \code{\link{check_model_GxE}},
 \item \code{\link{check_model_model_1}},
 \item \code{\link{check_model_model_2}},
 \code{\link{predict_the_past_model_2}},
 \code{\link{get_ggplot}}
}
}

