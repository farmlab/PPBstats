#' Get ggplot from mean_comparisons_GxE
#'
#' @description
#' \code{ggplot_mean_comparisons_GxE} returns ggplot from \code{\link{mean_comparisons_GxE}}
#' 
#' @param out_mean_comparisons_GxE outputs from \code{\link{mean_comparisons_GxE}}
#' 
#' @details See \code{\link{get_ggplot}}
#' 
#' @return See \code{\link{get_ggplot}}
#' 
#' @seealso 
#' \itemize{
#' \item \code{\link{get_ggplot}}, 
#' \item \code{\link{mean_comparisons_GxE}}
#' }
#'
ggplot_mean_comparisons_GxE = function(
  mean_comparisons_GxE,
  ggplot.type = "barplot",
  nb_parameters_per_plot = 10
  ){
  
  # 1. Error message ----------
  if( !is.element(ggplot.type, c("barplot")) ) { stop("ggplot.type must be barplot with output from GxE.") }
  
  variable = mean_comparisons_GxE$info$variable
  
  data_ggplot_LSDbarplot_germplasm = mean_comparisons_GxE$data_ggplot_LSDbarplot_germplasm
  data_ggplot_LSDbarplot_location = mean_comparisons_GxE$data_ggplot_LSDbarplot_location
  data_ggplot_LSDbarplot_year = mean_comparisons_GxE$data_ggplot_LSDbarplot_year
  
  # 2. Functions used in the function ----------
  
  ggplot_LSDbarplot = function(d_LSD, fac, variable, nb_parameters_per_plot){
  
    d_LSD = arrange(d_LSD, means) 
    d_LSD$max = max(d_LSD$means, na.rm = TRUE)
    d_LSD$split = add_split_col(d_LSD, nb_parameters_per_plot)
    d_LSD_split = plyr:::splitter_d(d_LSD, .(split))  
    
    out = lapply(d_LSD_split, function(dx){
      p = ggplot(d_LSD, aes(x = reorder(parameter, means), y = means)) + geom_bar(stat = "identity")
      p = p + geom_text(aes(x = reorder(parameter, means), y = means/2, label = groups), angle = 90, color = "white")
      p = p + ggtitle(paste(fac, "\n alpha = ", d_LSD[1, "alpha"], "; alpha correction :", d_LSD[1, "alpha.correction"]))
      p = p + xlab("") + theme(axis.text.x = element_text(angle = 90)) + coord_cartesian(ylim = c(0, d_LSD[1,"max"])) + ylab(variable)
      return(p)
    })
    
    return(out)
  }
  
  # 3. Germplasm ----------
  if( !is.null(data_ggplot_LSDbarplot_germplasm) ){ 
    ggplot_LSDbarplot_germplasm = ggplot_LSDbarplot(data_ggplot_LSDbarplot_germplasm, "germplasm", variable, nb_parameters_per_plot) 
  } else {
    ggplot_LSDbarplot_germplasm = NULL
    }
  
  # 4. Location ----------
  if( !is.null(data_ggplot_LSDbarplot_location) ){ 
    ggplot_LSDbarplot_location = ggplot_LSDbarplot(data_ggplot_LSDbarplot_location, "location", variable, nb_parameters_per_plot) 
  } else {
    ggplot_LSDbarplot_location = NULL
  }
  
  # 5. Year ----------
  if( !is.null(data_ggplot_LSDbarplot_year) ){ 
    ggplot_LSDbarplot_year = ggplot_LSDbarplot(data_ggplot_LSDbarplot_year, "year", variable, nb_parameters_per_plot) 
  } else {
    ggplot_LSDbarplot_year = NULL
  }
  
  # 6. return results ----------
  out = list(
    "germplasm" = ggplot_LSDbarplot_germplasm, 
    "location" = ggplot_LSDbarplot_location, 
    "year" = ggplot_LSDbarplot_year
    )
  
  return(out)
}

