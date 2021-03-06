#' Provides experimental design for several situations
#'
#' @description
#' \code{design_experiment} provides experimental design for several situations
#' 
#' @param expe.type The type of experiment to settle "satellite-farm", "regional-farm", "row-column", "fully-repicated", "IBD". See details for more information.
#' 
#' @param location Name of the location.
#' 
#' @param year Year of the experiment.
#' 
#' @param germplasm Vector with the names of the germplasm.
#' 
#' @param controls Vector with names of controls.
#' 
#' @param nb.controls.per.block Number of controls per blocks.
#' 
#' @param nb.blocks Number of blocks.
#' 
#' @param nb.cols Number of columns in the design. The number of rows is computed automaticaly.
#' 
#' @param return.format "standard" or "shinemas". See details for more information.
#'
#' @return 
#' The function returns a list with
#' \itemize{
#'  \item data.frame : A data frame according to return.format
#'  \item design : An image of the experimental design
#'  }
#' 
#' @details 
#' 
#' regarding return.format :
#' \itemize{
#' \item  "standard" return a data frame with the following columns : "location", "year", "germplasm", "block", "X" and "Y".
#' \item "shinemas" for SHiNeMaS reproduction template file. It returns a data frame with the following columns :"project", "sown_year", "harvested_year", "id_seed_lot_sown", "intra_selection_name", "etiquette", "split", "quantity_sown", "quantity_harvested", "block", "X" and "Y".
#' }
#' 
#' Note that an efficient R package to design experiment is DiGGer, see \url{http://www.austatgen.org/software/} for mor details. Unfortunately, the lience of the package did not allow us to fork the code. 
#' 
#' In this function, the code is based on the following algorithms:
#' \itemize{
#'  \item "satellite-farm"
#'  \enumerate{
#'	 \item randomize the germplasm
#'   \item get the data frame with one block, two columns and one control in each column
#'	 \item randomize the columns
#'  }
#'  \item "regional-farm"
#'  \enumerate{
#'	 \item randomize the germplasm
#'   \item get the data frame with blocks, columns and controls in each block
#'   \item arrange at least one control per row
#'   \item for each row, put control in different column
#'   \item randomize rows and columns
#'   \item check that controls do not touch each other
#'   \item check number of controls in col and row and send a warning message if control are missing in rows or columns
#'  }
#'  \item "row-column"
#'  Note that expe.type = "row-column" is particular case of expe.type = "regional-farm" where the number of controls must be at least the number of columns or rows.
#'  \enumerate{
#'	 \item randomize the germplasm
#'   \item get the data frame with blocks, columns and controls in each block
#'   \item arrange at least one control per row
#'   \item for each row, put control in different column
#'   \item randomize rows and columns
#'   \item check that controls do not touch each other
#'   \item check number of controls in col and row and send a stop message if control are missing in rows or columns
#'  }
#'  \item "fully-repicated"
#'  \enumerate{
#'	 \item randomize the germplasm
#'   \item get the data frame with blocks, columns and germplasm in each block
#'   \item arrange randomization so that no germplasm can be in the same column between blocks
#'  }
#'  \item "IBD"
#' the randomization is based on the ibd function in the ibd package. See \code{?ibd} for more information
#' }
#' 
#' @author Pierre Riviere
#' 
design_experiment = function(
  expe.type,
  location = "location",
  year = "2016",
  germplasm,
  controls,
  nb.controls.per.block,
  nb.blocks,
  nb.cols,
  return.format = "standard"
)
  {
    # 1. Error message ----------  
    if(!is.element(expe.type, c("satellite-farm", "regional-farm", "row-column", "fully-replicated", "IBD"))) { stop("expe.type must be either \"satellite-farm\", \"regional-farm\", \"row-column\", \"fully-replicated\" or \"IBD\".") }
    if(!is.element(return.format, c("standard", "shinemas"))) { stop("format.data must be either \"standard\" or \"shinemas\".") }

    nb.germplasm = length(germplasm)

    # 2. Functions used in the code ----------  
    
    get_data.frame = function(location, year, nb.germplasm, nb.blocks, nb.controls.per.block, nb.cols, expe.type) {
      germplasm = paste("entry-", c(1:nb.germplasm), sep = "")
      germplasm = sample(germplasm, length(germplasm), replace = FALSE)
      
      vec_XXX = c(1:nb.germplasm)
      
      if( expe.type == "row-column" | expe.type == "satellite-farm" | expe.type == "regional-farm" ) {
        test = ceiling(nb.germplasm / nb.blocks) * nb.blocks
        if( test > nb.germplasm ) { germplasm = c(germplasm, paste(rep("XXX", times = (test - nb.germplasm)), vec_XXX[1:(test - nb.germplasm)] , sep = "-") ); vec_XXX = vec_XXX[-c(1:(test - nb.germplasm))] }
        l = split(germplasm, (1:nb.blocks))
      }
      
      if( expe.type == "fully-replicated" ) {
        l = rep(list(germplasm), nb.blocks)
      }
        
      
      if( expe.type == "row-column" | expe.type == "satellite-farm") {
        l = lapply(l, function(x){c(x, rep("control-1", times = nb.controls.per.block))})  
      }
      
      if( expe.type == "regional-farm" ) {
        l = lapply(l, function(x){c(x, paste("control", c(1:nb.controls.per.block), sep ="-"))})
      }
      
      L = rep(LETTERS, times = 30)
      vec_X = c(LETTERS, paste(L, rep(c(1:(length(L)/26)), each = 26), sep = ""))
      
      vec_Y = c(1:(nb.germplasm*2)) # to be ok, it is always less than nb.germplasm*2
      d = data.frame()
      for(i in 1:length(l)){
        germplasm = l[[i]]
        nb.rows = ceiling(length(germplasm) / nb.cols)
        X = rep(vec_X[1:nb.cols], each = nb.rows)
        Y = rep(vec_Y[c(1:nb.rows)], times = nb.cols); vec_Y = vec_Y[-c(1:nb.rows)]
        if( length(X) > length(germplasm) ) { germplasm = c(germplasm, paste(rep("XXX", times = (length(X) - length(germplasm))), vec_XXX[1:(length(X) - length(germplasm))] , sep = "-") ) }
        block = rep(i, length(X))
        d = rbind.data.frame(d, cbind.data.frame(germplasm, block, X, Y))
      }
      d$location = as.factor(location)
      d$year = as.factor(year)
      d$germplasm = as.factor(d$germplasm)
      d$block = as.factor(d$block)
      d$X = as.factor(d$X)
      d$Y = as.factor(d$Y)
      d = d[,c("location", "year", "germplasm", "block", "X", "Y")]
      return(d)
    }
    
    place_controls = function(d, expe.type){
      dok = data.frame()
      vec_block = levels(d$block)
      for(b in vec_block){
        dtmp = droplevels(filter(d, block == b))
        c = grep("control", dtmp$germplasm)
        e = c(1:length(dtmp$germplasm))[-c]
        ent = c(as.character(dtmp$germplasm[c]), as.character(dtmp$germplasm[e]))

        # Put at least one control per row
        arrange.m = function(m){
          if( nrow(m) > 1 ){
            mtmp = m
            mtmp[2,] = m[nrow(m),]
            mtmp[nrow(m),] = m[2,]
            m = mtmp # be sur to have controls in opposite rows
          }
          return(m)
        }
        
        if( nlevels(dtmp$X) <= nlevels(dtmp$Y)){
          m = matrix(ent, ncol = nlevels(dtmp$X), nrow = nlevels(dtmp$Y)) 
          m = arrange.m(m)
          rownames(m) = levels(dtmp$Y)
          colnames(m) = levels(dtmp$X)
        } else { 
          m = matrix(ent, ncol = nlevels(dtmp$Y), nrow = nlevels(dtmp$X)) 
          m = arrange.m(m)
          rownames(m) = levels(dtmp$X)
          colnames(m) = levels(dtmp$Y)
          }
        
        # For each row, put control in different column
        possible_col = rep(1:ncol(m), nrow(m))

        for(i in 1:nrow(m)){
          r = m[i,]
          c = grep("control", r)
          
          if(length(c)==0){ e = c(1:length(r)) } else { e = c(1:length(r))[-c] }
          if(length(c)>1){ e = c(e, c[2:length(c)]); c = c[1]}
          
          if(length(c)==0){
            col_with_c = NULL
            col_with_e = c(1:ncol(m))
          } else {
            col_with_c = possible_col[i]
            col_with_e = c(1:ncol(m))
            col_with_e = col_with_e[-which(col_with_e==col_with_c)]
          }
          
          if(!is.null(col_with_c)){ m[i,col_with_c] = r[c]}
          m[i,col_with_e] = sample(r[e])
        }
        
        if( nlevels(dtmp$X) <= nlevels(dtmp$Y)){ m = m } else { m = t(m) }
        
        # Sample columns and rows
        sample_col_row = function(m, expe.type){
          # Sample the columns
          m2 = m[,sample(c(1:ncol(m)))]
          if(is.vector(m2)){ m2 = matrix(m2, nrow = nrow(m))}
          colnames(m2) = sort(colnames(m))
          rownames(m2) = rownames(m)
          m = m2

          # Sample the rows
          if( expe.type != "satellite-farm" ){
            m2 = m[sample(c(1:nrow(m))),]
            if(is.vector(m2)){ m2 = matrix(m2, nrow = nrow(m))}
            colnames(m2) = sort(colnames(m))
            rownames(m2) = rownames(m)
            m = m2
          }
          
          return(m)
        }
        m = sample_col_row(m, expe.type)

        # Check controls do not touch each other
        check_controls = function(m){
          test = c()
          for(i in 1:(nrow(m)-1)){
            for(j in 1:ncol(m)){
              if(m[i,j] == m[i+1,j]){ test = c(test, TRUE) } else { test = c(test, FALSE) }
            }
          }
          for(j in 1:(ncol(m)-1)){
            for(i in 1:nrow(m)){
              if(m[i,j] == m[i,j+1]){ test = c(test, TRUE) } else { test = c(test, FALSE) }
            }
          }
          go = length(which(test))>0
          return(go)
        }
        
        if( expe.type != "satellite-farm" ){
          i = 1
          while(check_controls(m)& i < 1000){ m = sample_col_row(m, expe.type); i = i +1 }
        }
        
        # Check number of controls in col and row
        fun_test = function(x){
          a = grep("control", x)
          if(length(a)==0){t=0}else{t=1}
          return(t)
        }
        
        if( expe.type == "regional-farm" | expe.type == "row-column" ){
          test_col = which(apply(m, 2, fun_test) == 0)
          test_row = which(apply(m, 1, fun_test) == 0)
          mess_col = paste("Controls are missing in columns ", paste(test_col, collapse = ","), ". You can rise nb.controls.per.block.", sep = "")
          mess_row = paste("Controls are missing in rows ", paste(test_row, collapse = ","), ". You can rise nb.controls.per.block.", sep = "")
        }
          
          
        if( expe.type == "regional-farm" ){
          test_col = which(apply(m, 2, fun_test) == 0)
          test_row = which(apply(m, 1, fun_test) == 0)
          if( length(test_col) > 0 ){ warning(mess_col) }
          if( length(test_row) > 0 ){ warning(mess_row) }
        }
          
        if( expe.type == "row-column" ){
          test_col = which(apply(m, 2, fun_test) == 0)
          test_row = which(apply(m, 1, fun_test) == 0)
          if( length(test_col) > 0 ){ stop(mess_col) }
          if( length(test_row) > 0 ){ stop(mess_row) }
        }

        dtmp = data.frame(germplasm = as.vector(m), block = b, X = rep(colnames(m), each = nrow(m)), Y = rep(rownames(m), times = ncol(m)))
        
        dok = rbind.data.frame(dok, dtmp)
      }
      
      dok$germplasm = as.factor(dok$germplasm)
      dok$block = as.factor(dok$block)
      dok$X = as.factor(dok$X)
      dok$Y = as.factor(dok$Y)
      dok$location = as.factor(d$location)
      dok$year = as.factor(d$year)
      dok = dok[,c("location", "year", "germplasm", "block", "X", "Y")]
      return(dok)
    }
    
    
    rename_d = function(d, germplasm, controls){
      XXX = paste("XXX", c(1:length(germplasm)), sep = "-")
      names(XXX) = XXX
      names(germplasm) = paste("entry", c(1:length(germplasm)), sep = "-")
      if( !is.null(controls)){names(controls) = paste("control", c(1:length(controls)), sep = "-")}
      ec = c(germplasm, XXX, controls)
      d$statut = d$germplasm
      d$germplasm = as.factor(ec[as.character(d$germplasm)])
      return(d)
    }
    
    get_ggplot_plan = function(d){
      color_till = rep("white", length(d$statut))
      color_till[grep("control", d$statut)] = "black"
      
      color_text = color_till
      b = which(color_till == "black")
      w = which(color_till == "white")
      color_text[w] = "black"
      color_text[b] = "white"
      
      a = tapply(as.numeric(d$X), d$block, min) - 0.5
      d$xmin = a[d$block]
      a = tapply(as.numeric(d$X), d$block, max) + 0.5
      d$xmax = a[d$block]
      a = tapply(as.numeric(d$Y), d$block, min) - 0.45
      d$ymin = a[d$block]
      a = tapply(as.numeric(d$Y), d$block, max) + 0.45
      d$ymax = a[d$block]
      
      p = ggplot(data = d, aes(x = X, y = Y, label = germplasm))
      p = p + geom_tile(color = "black", fill = color_till) + geom_text(color = color_text) + theme(legend.position="none") + theme_bw()
      p = p + geom_rect(aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, color = block), fill = NA, size = 1)
      p = p + ggtitle(paste(d[1,"location"], d[1,"year"], sep = ":")) + theme(plot.title = element_text(hjust = 0.5))
      return(p)
    }
    
    format_data = function(d, return.format){
      if( return.format == "standard" ) { 
        d = dplyr::select(d,-statut)
      }
      
      if( return.format == "shinemas" ) { 
        d = data.frame(
          project = "",
          sown_year = d$year,
          harvested_year = "",
          id_seed_lot_sown = paste(d$germplasm, d$location, d$year, sep = "_"),
          intra_selection_name = "",
          etiquette = "",
          split = "",
          quantity_sown = "",
          quantity_harvested = "",
          block = d$block,
          X	= d$X,
          Y = d$Y
        )
      }
      return(d)
    }
    
    # 3. Compute for different expe.type ----------
    
    OUT = NULL
    
    # 3.1. expe.type == "satellite-farm" ----------
    if( expe.type == "satellite-farm" ) {
      if(nb.germplasm > 10){ message("With expe.type == \"satellite-farm\", it is recommanded to have less than 10 germplasm. With more than 10 germplasm, go for expe.type == \"regional-farm\".") }
      if(length(controls) > 1){ stop("With expe.type == \"satellite-farm\", there can be only one control.") }
      if(nb.controls.per.block != 2){stop("nb.controls.per.block = 2 with expe.type == \"satellite-farm\".")}
      if(nb.blocks != 1){stop("nb.blocks = 1 with expe.type == \"satellite-farm\".")}
      if(nb.cols > 2){stop("nb.cols = 1 or 2 with expe.type == \"satellite-farm\".")}
      
      d = get_data.frame(location, year, nb.germplasm, nb.blocks, nb.controls.per.block, nb.cols, expe.type)
      d = place_controls(d, expe.type)
      d = rename_d(d, germplasm, controls)
      p = get_ggplot_plan(d)
      d = format_data(d, return.format)
      
      out = list("data.frame" = d, "design" = p)
      out = list("satellite-farms" = out); OUT = c(OUT, out)
    }
    
    
    # 3.2. expe.type == "regional-farm" ----------
    if( expe.type == "regional-farm" ) {
      if( nb.controls.per.block < 2) { stop("nb.controls.per.block must be more than 1 with expe.type == \"regional-farm\".") }
      if( length(controls) != nb.controls.per.block ){ stop("nb.controls.per.block must be equal to the length of controls with expe.type == \"regional-farm\".") }
      
      d = get_data.frame(location, year, nb.germplasm, nb.blocks, nb.controls.per.block, nb.cols, expe.type)
      d = place_controls(d, expe.type)
      d = rename_d(d, germplasm, controls)
      p = get_ggplot_plan(d)
      d = format_data(d, return.format)
      
      out = list("data.frame" = d, "design" = p)
      out = list("regional-farms" = out); OUT = c(OUT, out)
    }
    
    
    # 3.3. expe.type == "row-column" ----------
    if( expe.type == "row-column" ) {
      if( length(controls) != 1 ){ stop("nb.controls.per.block must be equal to 1 with expe.type == \"row-column\".") }
      
      d = get_data.frame(location, year, nb.germplasm, nb.blocks, nb.controls.per.block, nb.cols, expe.type)
      d = place_controls(d, expe.type)
      d = rename_d(d, germplasm, controls)
      p = get_ggplot_plan(d)
      d = format_data(d, return.format)
      
      out = list("data.frame" = d, "design" = p)
      out = list("row-column" = out); OUT = c(OUT, out)
    }
    
    
    # 3.4. expe.type == "fully-replicated" ----------
    if( expe.type == "fully-replicated" ) {
      nb.controls.per.block = NULL # not use
      d = get_data.frame(location, year, nb.germplasm, nb.blocks, nb.controls.per.block, nb.cols, expe.type)
      
      # arrange randomisation
      vec_block = sort(unique(d$block))

      for(b in 2:length(vec_block)){
        
        d1 = droplevels(filter(d, block %in% vec_block[1:(b-1)]))
        germplasm_tmp = unique(as.character(d1$germplasm))
        
        d2 = droplevels(filter(d, block == vec_block[b]))
        
        E = NULL
        for(i in 1:nrow(d2)){
          e = d2[i, "germplasm"]
          x = d2[i, "X"]
          y = d2[i, "Y"]
          test = is.element(e, filter(d1, X == x)$germplasm); ii = 0
          while(test & ii < 100 ){ e = sample(germplasm_tmp, 1) ; test = is.element(e, filter(d1, X == x)$germplasm); ii = ii + 1 }
          germplasm_tmp = germplasm_tmp[-which(germplasm_tmp == e)]
          E = c(E, e)
        }
        d[which(d$block == vec_block[b]), "germplasm"] = E
      }
      
      d = rename_d(d, germplasm, controls = NULL)
      p = get_ggplot_plan(d)
      d = format_data(d, return.format)
      
      out = list("data.frame" = d, "design" = p)
      out = list("fully-replicated" = out); OUT = c(OUT, out)
    }
    
    
    # 3.5. expe.type == "IBD" ----------
    if( expe.type == "IBD" ) {
      d = ibd(v = nb.germplasm, b = nb.blocks, k = nb.cols)$design
      if( is.null(nrow(d)) ){ stop("Design not found") }
      
      d = data.frame(
        germplasm = paste("entry", as.vector(d), sep = "-"),
        block = rep(c(1:nrow(d)), times = ncol(d)),
        X = rep(LETTERS[1:ncol(d)], each = nrow(d)),
        Y = rep(c(1:nrow(d)), times = ncol(d))
      )
      d$germplasm = as.factor(d$germplasm)
      d$block = as.factor(d$block)
      d$X = as.factor(d$X)
      d$Y = as.factor(d$Y)
      d$location = location
      d$year = year
      
      d = rename_d(d, germplasm, controls = NULL)
      p = get_ggplot_plan(d)
      d = format_data(d, return.format)
      
      out = list("data.frame" = d, "design" = p)
      out = list("IBD" = out); OUT = c(OUT, out)
    }
     
    return(OUT)
    }
