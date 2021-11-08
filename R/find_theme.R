#' Searches a file for YAML theme parameters, returning the theme if found.
#'
#' Takes the output of 'readLines()' and looks for YAML theme parameter value.
#' Typically used on the output of handle_rmd_path()'. 
#'
#' @param lines The output of 'readLines()' or 'handle_rmd_path()'.
#'
#' @return The theme value as a character string.
#'
find_theme <- function(lines = NULL) {
  # searching ---------------------------------------------------------------
  # search for YAML theme, ensuring html_doc first
  # below only works if YAML bounds found
  YAML_bounds <- grep("^---$", lines)
  if (length(YAML_bounds) == 2) {
    # Taking some trouble to safeguard against theme attributes set within
    # the rmarkdown body
    YAML_ind <- seq.int(YAML_bounds[1], YAML_bounds[2])
    YAML <- lines[YAML_ind]
    found_ind <- grep(" ?theme: ", YAML)
  }

  # extract the lang line
  theme_line <- lines[found_ind]
  
  # cleaning ----------------------------------------------------------------
  
  # split on :
  theme <- unlist(strsplit(theme_line, ":"))[2]
  # tidy up string
  theme <- str_remove_all(theme, " |'|\"|>")
  
  # is valid? ---------------------------------------------------------------
  
  # if no theme found, set theme as YAML syntax 'null'
  if (length(theme) == 0) {
    message("No theme found. Specifying theme: null")
    theme <- "null"
  }
  return(theme)
}
