#' Get ggplot from parameter_groups
#'
#' @description
#' \code{ggplot_parameter_groups} returns ggplot from \code{\link{parameter_groups}}
#' 
#' @param out_parameter_groups outputs from \code{\link{parameter_groups}} function
#' 
#' @details See \code{\link{get_ggplot}}
#' 
#' @return See \code{\link{get_ggplot}}
#' 
#' @seealso 
#' \itemize{
#' \item \code{\link{get_ggplot}}, 
#' \item \code{\link{parameter_groups}}
#' }
#' 
ggplot_parameter_groups = function(out_parameter_groups){

  pca = out_parameter_groups$obj.pca
  
  clust = out_parameter_groups$clust
  data = clust$data
  nb.k = clust$nb.k
  res.hc = clust$hc
  km.res = clust$km
  
  
  out = list(
    "pca" = list(
      "composante_variance" = fviz_eig(pca),
      "ind" = fviz_pca_ind(pca),
      "var" = fviz_pca_var(pca)
    ),
    "clust" = list(
      "nb_k" = fviz_nbclust(data, kmeans, method = "silhouette"),
      #"dendrogramm" = fviz_dend(res.hc, cex = 0.5, k = nb.k, type = "triangle"),
      "pca" = fviz_cluster(km.res, data, frame.type = "norm")
    )
  )
  
  return(out)
}
