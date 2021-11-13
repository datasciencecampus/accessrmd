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
#' @param wid Width of the image in pixels.
#' @param ht Height of the image in pixels.
#' @param css_class Specify a css class selector for the image.
#' @param css_id Specify a css ID selector for the image.
#' @param dpi Resolution. Please see `?ggplot2::ggsave()` for details.
#'
#' @return Inline HTML with the necessary structure for screen reader
#' accessibility.
#'
#' @importFrom ggplot2 last_plot ggsave
#' @importFrom grDevices png
#'
#' @examples
#' \dontshow{
#' .old_wd <- setwd(tempdir())
#' }
#' # create a ggplot2 chart
#' ggplot(pressure, aes(temperature, pressure)) +
#'   geom_point()
#'
#' # Use 'access_img()' to render the chart with alt text
#' access_img(alt = "Vapor Pressure of Mercury as a Function of Temperature")
#'
#' # Create a png.
#' file.create(tempfile("some_img", fileext = ".png"))
#'
#' # Read it from disk and include alt text
#' access_img("some_img.png", alt = "Some meaningful alt text")
#' \dontshow{
#' setwd(.old_wd)
#' }
#'
#' @export
access_img <- function(img = last_plot(), alt = NULL, wid = NULL,
                       ht = NULL, dpi = 300, css_class = NULL, css_id = NULL) {
  if (is.null(img)) {
    stop("No img found.")
  } else if (is.null(alt)) {
    stop("Please include alt text.")
  } else if (alt == "") {
    warning("Empty alt text should be used for decorative images only.")
  }

  tryCatch(
    {
      # if the file already exists on disk, do not create tempfile
      file.exists(img)
      # if img is on disk, return NA
      message("img derived from disk.")
      return(tags$img(
        src = img, alt = alt, width = wid, height = ht,
        class = css_class, id = css_id
      ))
    },
    error = function(cond) {
      message("img derived from inline R code.")
      # create tempfile
      tmp <- tempfile(fileext = ".png")
      # save the img to tempfile
      ggsave(filename = tmp, plot = img, device = png(), dpi = dpi)
      return(tags$img(
        src = tmp, alt = alt, width = wid, height = ht,
        class = css_class, id = css_id
      ))
    }
  )
}
