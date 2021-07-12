#' Produce an accessible image or chart.
#'
#' Reads in an image and produces the HTML structure expected by web
#' accessibility checkers such as WAVE. Also works as a wrapper around
#' ggplot2 charts.
#'
#' @param img The image to include as accessible HTML. Defaults to
#' 'ggplot2::last_plot()'. Can be replaced with an image written to disc.
#' @param alt A character string describing the image for screen reader
#' accessibility.
#' @param wid Width of the image in pixels. Defaults to 500.
#' @param ht Height of the image in pixels. Defaults to 500.
#' @param dpi Resolution. Please see `?ggplot2::ggsave()` for details.
#' 
#' @return Inline HTML with the necessary structure for screen reader
#' accessibility.
#' 
#' @importFrom ggplot2 last_plot ggsave
#' @importFrom grDevices png
#' @export
access_img <- function(img = last_plot(), alt = NULL, wid = 500,
                       ht = 500, dpi = 300){
  
  if(is.null(img)){
    stop("No img found.")
  } else if(is.null(alt)){
    stop("Please include alt text.")
  } else if(alt == ""){
    warning("Empty alt text should be used for decorative images only.")
  }
  
  tryCatch({
    # if the file already exists on disk, do not create tempfile
    file.exists(img)
    # if img is on disk, return NA
    message("img derived from disk.")
    return(tags$img(src = img, alt = alt, width = wid, height = ht))
    
  },
  error = function(cond){
    message("img derived from inline R code.")
    # create tempfile
    tmp <- tempfile(fileext = ".png")
    # save the img to tempfile
    ggsave(filename = tmp, plot = img, device = png(), dpi = dpi)
    return(tags$img(src = tmp, alt = alt, width = wid, height = ht))
    
  })

}
