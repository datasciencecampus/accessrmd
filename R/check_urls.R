#' Check an Rmarkdown for broken links.
#'
#' Check links within an Rmarkdown document for any urls that responds with an
#' error.
#'
#' @param rmd_path
#'
#' @return Lines of any urls that respond with an error. 
#'
#' @importFrom stringr str_split str_extract str_remove_all
#' @importFrom rlist list.apply
#' @export
rmd_path <- "tests/testfiles/test_links.Rmd"
check_urls <- function(rmd_path){
  lines <- handle_rmd_path(rmd_path = rmd_path)
  # find the links only
  links <- find_all_tags(lines = lines, tag = "link")
}