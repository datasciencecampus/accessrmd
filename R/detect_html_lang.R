#' Searches a file for valid methods of setting HTML lang attribute.
#'
#' Takes the output of 'readLines()' and looks for lang attribute value,
#' stopping if no valid value is found. Typically used on the output of
#' 'handle_rmd_path()'.
#'
#' @param lines The output of 'readLines()' or 'handle_rmd_path()'.
#' @param lang_tags A vector of valid lang subtag values, taken from
#' https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry.
#' Used to confirm whether the lang value is valid.
#'
#' @return The lang attribute value if found. Stops if no value found.
#'
detect_html_lang <- function(lines = NULL, lang_tags = langs) {
  # searching ---------------------------------------------------------------
  # search for HTML lang values
  found_ind <- grep("html lang ?= ?", lines)
  # search for YAML lang separately, ensuring html_doc first
  # below only works if YAML bounds found
  YAML_bounds <- grep("^---$", lines)
  if (all(length(found_ind) == 0, length(YAML_bounds) == 2)) {
    # Taking some trouble to safeguard against lang attributes set within
    # the rmarkdown body, like languages for specific body sections
    YAML_ind <- seq.int(YAML_bounds[1], YAML_bounds[2])
    YAML <- lines[YAML_ind]
    found_ind <- grep(" ?lang: ", YAML)
  }
  # stop if not found
  if (length(found_ind) == 0) {
    stop("No lang value found.")
  }
  # extract the lang line
  lang_line <- lines[found_ind]

  # cleaning ----------------------------------------------------------------

  # split on either = or :, dep on method used
  lang <- unlist(strsplit(lang_line, "=|:"))[2]
  # If lang contains prefix, take only prefix
  lang <- unlist(strsplit(lang, "-"))[1]
  # tidy up string
  lang <- str_remove_all(lang, " |'|\"|>")
  # compare against subtag registry, avoiding partial matches
  match <- grep(paste0("^", lang, "$"), lang_tags)

  # is valid? ---------------------------------------------------------------

  # error if no match found
  if (length(match) == 0) {
    stop("lang value is invalid. Please specify a valid lang value.")
  }
  return(lang)
}
