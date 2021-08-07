#' Find Rmd files within a provided file structure.
#'
#' Recursively searches file structure for Rmarkdown files. Returns the found
#' Rmd relative paths.
#'
#' @param search_dir The directory to search. Defaults to ".".
#'
#' @param recurse Defaults to TRUE. Should child directories be searched or
#' not.
#'
#' @param to_txt Defaults to FALSE. If TRUE, writes found rmd paths in a txt to
#' the `search_dir`.
#'
#' @return Relative paths to all found Rmd files.
#'
#' @importFrom stringr str_split str_extract str_remove_all
#' @importFrom rlist list.apply
#' @export
retrieve_rmds <- function(search_dir = ".", recurse = TRUE, to_txt = FALSE) {
  # find rmd files
  found_rmds <- list.files(
    path = search_dir, pattern = "\\.Rmd$", ignore.case = TRUE,
    full.names = TRUE, all.files = TRUE, include.dirs = TRUE,
    recursive = recurse
  )
  # if to_txt is TRUE, output vector to txt file
  if (to_txt == TRUE) {
    # store file name
    txt_loc <- paste0(search_dir, "rmd_paths.txt")
    write(found_rmds, file = txt_loc)
    # message on action
    message(paste("Relative paths written to", txt_loc))
  }
  return(found_rmds)
}
