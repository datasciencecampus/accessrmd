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
#'
#' @examples
#' \dontshow{
#' .old_wd <- setwd(tempdir())
#' }
#' # Create a test directory
#' dir.create("parent")
#' dir.create("parent/child")
#'
#' # Create some rmds to find
#' # An empty vector to collect file names
#' nm_vec <- character()
#' # create numbered file names
#' for (num in 1:6) {
#'   nm <- paste0(num, "-test.Rmd")
#'   nm_vec <- append(nm_vec, nm)
#' }
#' # Create some files in parent & child directories
#' file.create(paste0("parent/", nm_vec[1:3]))
#' file.create(paste0("parent/child/", nm_vec[4:6]))
#'
#' # Return all Rmd files
#' retrieve_rmds("parent")
#'
#' # tidy up environment
#' unlink(c("parent", "child"), recursive = TRUE)
#' \dontshow{
#' setwd(.old_wd)
#' }
#'
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
