#' Find any markdown or HTML syntax images within read lines.
#' 
#' Check any lines for images and return the line numbers and values.
#' 
#' @param lines Read lines, default is NULL & typically used with output of
#' handle_rmd_path.
#' 
#' @return A named vector with line numbers of any found images and their
#' values.
find_all_imgs <- function(lines = NULL){
  # only want img tags but preserve indexing --------------------------------
  # set the names of the lines vector as a count
  names(lines) <- seq_along(lines)
  # regex matches img tags & ![]() markdown syntax
  # tested on https://regex101.com/r/CU4g3f/1
  img_ind <- grep(pattern = "(<img.* *>|\\!\\[.* *]\\(.* *\\))", lines)
  img_only <- lines[img_ind]

  return(img_only)
  
}
