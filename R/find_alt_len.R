#' Find alt length limits for specific lang values.
#'
#' Return language specific alt text length limits. Limits are: eng	100,
#' ger	115, kor	90.
#'
#' @param rmd_path Path to the Rmd that requires accessible header metadata. Rmd
#' must be output type html.
#' @param lan Identify the language of text content. Attempts to find a lang
#' attribute value from the rmd document. Alternatively, use a character string
#' such as "en".
#'
#' @return A line limit for alt text.
#'
find_alt_len <- function(rmd_path = NULL, lan = detect_html_lang(lines)) {
  lims <- c(100, 115, 90)
  names(lims) <- c("en", "de", "ko")
  lines <- handle_rmd_path(rmd_path)
  # compare against lims
  lim_ind <- grep(lan, names(lims))
  if(length(lim_ind) > 0){
    return(unname(lims[lim_ind]))
  } else
    return(NULL)
  
}
