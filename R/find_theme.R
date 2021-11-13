#' Searches YAML head for YAML theme parameters, returning the theme if found.
#'
#' Use on YAML head text only. 'check_compat()' should be used prior to the use
#' of 'find_theme()'. Looks for YAML theme parameter value. Returns the theme
#' if found or 'default' if no theme specified.
#'
#' @param yaml A YAML header text string.
#'
#' @return The theme value as a character string.
#'
find_theme <- function(yaml = NULL) {
  # searching ---------------------------------------------------------------
  found_ind <- grep(" ?theme: ", yaml)
  # extract the lang line
  theme_line <- yaml[found_ind]

  # cleaning ----------------------------------------------------------------
  # split on :
  theme <- unlist(strsplit(theme_line, ":"))[2]
  # tidy up string
  theme <- str_remove_all(theme, " |'|\"|>")

  # null theme? -------------------------------------------------------------
  # if no theme found, set theme as YAML syntax 'null'
  if (length(theme) == 0) {
    message("No theme found. Specifying theme: default")
    theme <- "default"
  }
  return(theme)
}
