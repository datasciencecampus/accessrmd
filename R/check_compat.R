#' Checks if the html doctype is compatible.
#'
#' Checks to ensure file is not a special flavour of html output, including
#' xaringan, ioslides, flexdashboard or slidy. Output is an error if
#' html doc is a special case.
#'
#' @param yaml_txt Output of 'readLines()' separated from body text.
#'
#' @return Error condition if non-standard html found.
#'
#' @importFrom stringr str_split
#'
check_compat <- function(yaml_txt) {
  specials <- c(
    "xaringan::moon_reader:", "ioslides_presentation",
    "flexdashboard::flex_dashboard:", "slidy_presentation"
  )
  # Checking for flavoured html outputs first and warning on sig. accessibility
  # errors at time of writing.
  # extract pretty names for error messaging
  names(specials) <- lapply(
    str_split(string = specials, pattern = "_|::"), "[[", 1
  )
  # check all special cases and output error if found
  for (outputs in specials) {
    x <- grepl(pattern = outputs, yaml_txt)
    if (any(x)) {
      return(stop(paste(
        names(specials[grepl(outputs, specials)]),
        "output is not compatible."
      )))
    }
  }
  # check for html output type. Stop if not.
  html_loc <- grep(pattern = "html_document", yaml_txt)
  if (!any(html_loc)) {
    return(stop("'access_head()' only works with html output."))
  } else {
    return(NULL)
  }
}
