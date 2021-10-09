#' Find alt length limit for specific lang values.
#'
#' Return language specific alt text length limits. Limits are: eng	100,
#' ger	115, kor	90.
#'
#' @param lines Any Rmarkdown or HTML file lines. Typically the output of
#' 'handle_rmd_path()'.
#' @param lan Identify the language of text content. Attempts to find a lang
#' attribute value from the rmd document. Alternatively, use a character string
#' such as "en".
#'
#' @return A line limit for alt text.
#'
find_alt_lim <- function(lines = NULL, lan = detect_html_lang(lines)) {
  lims <- c(100, 115, 90)
  names(lims) <- c("en", "de", "ko")
  # compare against lims
  lim_ind <- grep(lan, names(lims))
  if (length(lim_ind) > 0) {
    return(unname(lims[lim_ind]))
  } else {
    return(NULL)
  }
}
