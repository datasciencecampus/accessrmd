#' Insert the required code for the specified toc type.
#'
#' Inserts YAML header for floating toc if toc is TRUE.
#'
#' @param toc TOC status, FALSE (the default) or TRUE.
#' @param header Metadata items wrapped with 'tags$header()'.
#' @param text Raw text required for Rmarkdown body.
#' @param lan lang attribute value.
#'
#' @return An assembled html output page containing the required toc code.
#'
insert_toc <- function(toc,
                       header,
                       text,
                       lan) {
  # if toc is float, embed toc YAML
  if (toc) {
    message("Using toc_float YAML")
    yaml <- c(
      "---",
      "output:",
      "    html_document:",
      "      toc: true",
      "      toc_float: true",
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
