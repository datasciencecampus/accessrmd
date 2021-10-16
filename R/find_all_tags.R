#' Find any markdown or HTML syntax tags within read lines.
#'
#' Check any lines for images or links and return the line numbers and values.
#'
#' @param lines Read lines, default is NULL & typically used with output of
#' handle_rmd_path.
#' 
#' @param tag The type of tag to be searched. Valid values are "img" or "link".
#'
#' @return A named vector with line numbers of any found images and their
#' values.
#' 
find_all_tags <- function(lines = NULL, tag = c("img", "link")) {
  # only want img tags but preserve indexing --------------------------------
  # set the names of the lines vector as a count
  names(lines) <- seq_along(lines)

  # regex matches img tags & ![]() markdown syntax
  # tested on https://regex101.com/r/CU4g3f/1
  tag_ind <- grep(pattern = if(tag == "img"){
    "(<img.* *>|\\!\\[.* *]\\(.* *\\))"
    }, lines)
  
  tag_only <- lines[tag_ind]
  return(tag_only)
}
