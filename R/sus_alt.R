#' Check an image for suspicious alt text.
#'
#' Checks if an image's alt text is equal to alt attribute placeholder values,
#' including: 'nbsp', 'spacer' and src attribute value (filename).
#'
#' @param rmd_path Path to the Rmd that contains image tags to check.
#'
#' @return Line numbers of images that has alt text equal to placeholder values.
#'
#' @importFrom ggplot2 last_plot ggsave
#' @importFrom grDevices png
#' @export
sus_alt <- function(rmd_path = NULL){
  # define placeholder values
  place_val <- c("nbsp", "spacer")
  
  lines <- handle_rmd_path()
  
}