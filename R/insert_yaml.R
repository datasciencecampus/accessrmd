#' Insert the required code for the specified toc type.
#'
#' Inserts YAML header for floating toc if toc is TRUE.
#'
#' @param toc TOC status, FALSE (the default) or TRUE.
#' @param header Metadata items wrapped with 'tags$header()'.
#' @param text Raw text required for Rmarkdown body.
#' @param lan lang attribute value.
#' @param theme Text styling to apply. Current valid value is "default" only.
#' All other themes present accessibility errors on testing.
#' @param highlight Currently only "null" is a valid, due to accessibility
#' errors found in all built-in highlight options.
#'
#' @return An assembled html output page containing the required toc code.
#'
insert_yaml <- function(toc,
                        header,
                        text,
                        lan,
                        theme = "default",
                        highlight = "null") {
  # if theme is cerulean or simplex, break with error message
  if (theme != "default") {
    warning(paste("The", theme, "theme has known accessibility errors and is
    not supported by this function."))
    # apply default theme instead
    theme <- "default"
  }
  # if toc is float, embed toc YAML
  if (toc) {
    message("Using toc_float YAML")
    yaml <- c(
      "---",
      "output:",
      "    html_document:",
      "      toc: true",
      "      toc_float: true",
      paste("      highlight:", highlight),
      paste("      theme:", theme),
      "---"
    )
  } else {
    # If no toc, just apply the styling values
    yaml <- c(
      "---",
      "output:",
      "    html_document:",
      paste("      highlight:", highlight),
      paste("      theme:", theme),
      "---"
    )
  }

  # wrap text in body tags
  body <- tags$body(paste(text, collapse = "\n"))
  # set the html lang & message
  message(paste("Setting html lan to", lan))
  # Combine webpage
  html_out <- paste(
    if ("yaml" %in% ls()) {
      paste(yaml, collapse = "\n")
    },
    paste0("<html lang=\"", lan, "\">"),
    paste(header),
    paste(body),
    "</html>",
    sep = "\n"
  )
  # cleaning of html reserved words -----------------------------------------
  # <> have been replaced with &lt; and &gt; due to HTML reserved words
  # gsub them back
  html_out <- gsub("&lt;", "<", html_out)
  html_out <- gsub("&gt;", ">", html_out)

  return(html_out)
}
