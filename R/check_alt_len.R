#' Check Rmd files for alt length.
#' 
#' Check any Rmd images for language specific alt text length limits. Limits used
#' are: eng	100, ger	115, kor	90.
#' 
#' @param rmd_path Path to the Rmd that requires accessible header metadata. Rmd
#' must be output type html.
#' @param lan Identify the language of text content.
#' 
#' @return Adjust the Rmd YAML provided to `rmd_path`, improving its
#' accessibility for screen readers. Only works with html output.
#' 
#' @importFrom stringr str_split str_remove
#' 
#' @export