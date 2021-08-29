#' Produce an accessible Rmarkdown file template.
#'
#' Creates an Rmarkdown template with the HTML structure required by screen
#' readers.
#'
#' @param filenm Required - The name of the file.
#' @param title Required - The document title.
#' @param author Required - The document author.
#' @param date Required - The author date.
#' @param lan Required - The HTML language to set as the value for the lang
#' attribute.
#' @param subtitle Optional - The document subtitle
#'
#' @return An Rmarkdown file with an HTML head, populated with metadata
#' specified within the function parameters. 
#'
#' @export
access_rmd <- function(
  filenm = NULL,
  title = NULL,
  author = NULL,
  date = NULL,
  lan = NULL,
  subtitle = NULL){
  
  
}