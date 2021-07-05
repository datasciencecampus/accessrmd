#' access_img
#'
#' @param img The image to include as accessible HTML. Defaults to
#' 'ggplot2::last_plot()'. Can be replaced with an image written to disc.
#' @param alt A character string describing the image for screen reader
#' accessibility.
#' @param wid Width of the image in pixels. Defaults to 500.
#' @param ht Height of the image in pixels. Defaults to 500.
#' @param dpi Resolution. Please see `?ggplot2::ggsave()` for details.
#' @return Inline HTML with the necessary structure for screen reader
#' accessibility.
#' 
#' @importFrom ggplot2 last_plot ggsave
#' @import utils digest

access_img <- function(img = last_plot(), alt = NULL, wid = 500,
                       ht = 500, dpi = 300){
  if(is.null(alt) | length(alt) == 0){
    stop("Please include alt text.")
  } else if(is.null(img)){
    stop("No img found.")
  }
  # create tempfile
  tmp <- tempfile(fileext = ".png")
  # save the img to tempfile
  ggsave(filename = tmp, plot = img, device = png(), dpi = dpi)
  # construct the html tag
  return(tags$img(src = tmp, alt = alt, width = wid, height = ht))
  

}
