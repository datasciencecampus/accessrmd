#' Check rmd path & file type.
#'
#' Checks rmd_path exists and that the file suffix is correct.
#'
#' @param rmd_path Path to the Rmd to check.
#' 
#' @return Error if file does not exist or is not an rmd file.
#' 
handle_rmd_path <- function(rmd_path = NULL){
  if(is.null(rmd_path)){
    stop("rmd_path not found.")
    
  } else if(!grepl(pattern = ".rmd$", x = rmd_path, ignore.case = TRUE)){
    stop("Ensure that an Rmd file is passed to rmd_path.")
  } else(
    return(rmd_path)
  )
}