#' Assemble HTML header output from text provided.
#'
#' Returns header structure for use with 'access_head()' and 'access_rmd()'.
#'
#' @param title Text string to use as document title and h1 heading.
#' @param subtitle Text string to use as subtitle heading.
#' @param auth Text string or inline code to include as author heading.
#' @param doc_date Text string or inline code to include as date heading.
#' @param enc Text string to use as document encoding.
#'
#' @return An assembled html output page containing the required toc code.
#'
assemble_header <- function(title, subtitle, auth, doc_date, enc) {

  # produce the accessible title
  html_title <- tags$title(title)
  # h1 needs to be the same as title
  h1_content <- tags$h1(title, class = "title toc-ignore")
  if (length(subtitle) == 0) {
    h2_auth <- tags$h2(auth, class = "author toc-ignore")
    h2_date <- tags$h2(doc_date, class = "date toc-ignore")
    metas <- list(h2_auth, h2_date)
  } else {
    h2_sub <- tags$h2(subtitle, class = "subtitle toc-ignore")
    h3_auth <- tags$h3(auth, class = "author toc-ignore")
    h3_date <- tags$h3(doc_date, class = "date toc-ignore")
    metas <- list(h2_sub, h3_auth, h3_date)
  }

  # assemble header ---------------------------------------------------------
  html_head <- tags$header(
    tags$meta(charset = enc),
    html_title,
    h1_content,
    metas
  )
  return(html_head)
}
