#' Return a HTML heading tag of the required level.
#'
#' Returns a HTML heading tag of any of the available levels (h1, h2, h3 and so
#' on). The class selectors applied will always include "toc-ignore", but an
#' additional selector may be included within the class parameter. If an object
#' of length zero is passed to the txt parameter, NULL is returned.
#'
#' @param txt The text to be used as the heading text.
#' @param lvl A number to be used for the heading level. 1 == tags$h1() and so
#' on.
#' @param class A character string to use as the first class attribute. Do not
#' include "toc-ignore", this will be added.
#'
#' @return null if txt is length 0 or required heading level with class attr
#'
return_heading <- function(txt, lvl, class) {
  if (length(txt) == 0) {
    return(NULL)
  } else {
    h_lvl <- paste0("h", lvl)
    heading <- tags[[h_lvl]](txt, class = paste(class, "toc-ignore"))
  }
}
