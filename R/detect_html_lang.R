#' Searches a file for valid methods of setting HTML lang attribute.
#'
#' Takes the output of 'readLines()' and looks for lang attribute value,
#' stopping if no valid value is found. Typically used on the output of
#' 'handle_rmd_path()'.
#'
#' @param lines The output of 'readLines()' or 'handle_rmd_path()'.
#'
#' @return The lang attribute value if found. Stops if no value found.
#' 
detect_html_lang <- function(lines = NULL){
  # search for HTML lang values
  found_ind <- grep("html lang ?= ?", lines)
  # search for YAML lang separately, ensuring html_doc first
  # below only works if YAML bounds found
  YAML_bounds <- grep("^---$", lines)
  if(all(length(found_ind) == 0, length(YAML_bounds) == 2)){
    # Taking some trouble to safeguard against lang attributes set within
    # the rmarkdown body, like languages for specific body sections
    YAML_ind <- seq.int(YAML_bounds[1], YAML_bounds[2])
    YAML <- lines[YAML_ind]
    found_ind <- grep(" ?lang: ", YAML)
  }
  # stop if not found
  if(length(found_ind) == 0){
    stop("No lang value found.")
  }
  # extract the lang line
  lang_line <- lines[found_ind]
  # split on either = or :, dep on method used
  lang <- unlist(strsplit(lang_line, "=|:"))[2]
  # tidy up string
  lang <- str_remove_all(lang, " |'|\"|>")
  return(lang)

}