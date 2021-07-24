#' Check rmd path & file type.
#'
#' Checks rmd_path exists and that the file suffix is correct.
#'
#' @param rmd_path Path to the Rmd to check.
#'
#' @return Reads rmd lines on success. Error if file does not exist or is not an
#' rmd file.
#'
handle_rmd_path <- function(rmd_path = NULL) {
  # stop if null
  if (is.null(rmd_path)) {
    stop("rmd_path is NULL.")
    # stop if not a *.rmd
  } else if (!grepl(pattern = ".rmd$", x = rmd_path, ignore.case = TRUE)) {
    stop("Ensure that an Rmd file is passed to rmd_path.")
  } else if (!file.exists(rmd_path)) {
    # stop if file doesn't exist
    stop("rmd file not found.")
  } else {
    (
      # read in the file lines, warn to FALSE if no EOF / empty line on end
      return(readLines(rmd_path, warn = FALSE))
    )
  }
}
