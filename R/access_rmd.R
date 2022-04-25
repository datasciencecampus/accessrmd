#' Produce an accessible Rmarkdown file template.
#'
#' Creates an Rmarkdown template with the HTML structure required by screen
#' readers.
#'
#' @param filenm Required - The name of the file.
#' @param title Required - The document title.
#' @param subtitle Optional - The document subtitle.
#' @param lan Required - The HTML language to set as the value for the lang
#' attribute.
#' @param author Required - The document author. Defaults to the effective user
#' identified by `Sys.info()`.
#' @param date Required - The author date. Defaults to today's date.
#' @param toc Optional, defaults to FALSE. Should a table of contents be
#' included. Valid entries are FALSE (the default) or TRUE.
#' @param encoding Defaults to "utf-8".
#' @param force Defaults to FALSE. If TRUE, overwrites a pre-existing file with
#' the same filenm with warning.
#' @param theme Set to "default", currently the only in-built theme that does
#' not result in accessibility errors.
#' @param highlight Set to "null", currently the only in-built highlight that
#' does not result in accessibility errors.
#'
#' @return An Rmarkdown file with an HTML head, populated with metadata
#' specified within the function parameters.
#'
#' @importFrom stringr str_remove_all
#'
#' @examples
#' \dontshow{
#' .old_wd <- setwd(tempdir())
#' }
#' # create an accessible rmarkdown document from scratch
#' access_rmd(
#'   "some_filenm",
#'   title = "Title Goes Here", lan = "en", author = "Author here"
#' )
#' \dontshow{
#' setwd(.old_wd)
#' }
#'
#' @export
access_rmd <- function(filenm = NULL,
                       title = NULL,
                       subtitle = NULL,
                       lan = NULL,
                       author = Sys.info()[8],
                       date = format(Sys.Date(), "%d %b %Y"),
                       toc = FALSE,
                       encoding = "utf-8",
                       force = FALSE,
                       theme = "default",
                       highlight = "null") {

  # Stop if lan  = NULL
  if (is.null(lan)) {
    stop("No value provided to 'lan'.")
  }
  # stop if title is NULL
  if (is.null(title)) {
    stop("No title is provided.")
  }
  # remove any spaces from filenm
  filenm <- str_remove_all(filenm, " ")
  # feat: logic to add ".Rmd" if forgotten
  if (!grepl(".Rmd$", filenm, ignore.case = TRUE)) {
    filenm <- paste0(filenm, ".Rmd")
  }
  # force parameter that warns if file found
  if (all(file.exists(filenm) & force)) {
    warning("'force' is TRUE. Overwriting filenm.")
  } else if (all(file.exists(filenm) & !force)) {
    stop("filenm found on disk. 'force' is FALSE.")
  }

  # assemble_header ---------------------------------------------------------
  header <- assemble_header(
    title = title,
    subtitle = subtitle,
    auth = author,
    doc_date = date,
    enc = encoding
  )

  # template ----------------------------------------------------------------
  text <- '
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
knitr::opts_chunk$set(comment = "")
```

## Adapted R Markdown

This R Markdown template has been adapted using the \'accessrmd\' package. This
template has a different header and HTML structure to the standard R markdown
template. This is to improve the accessibility of the knitted HTML documents for
screen readers.

For more help in using R Markdown see the
[RStudio RMarkdown documentation](http://rmarkdown.rstudio.com).

Clicking the **Knit** button will generate a document including typed content
and the output of any R code chunks. For example:

```{r cars}
summary(cars)
```

## Plots

```{r pressure, echo=FALSE, message=FALSE}
plt <- ggplot2::ggplot(
  pressure,
  ggplot2::aes(temperature, pressure)
  ) +
  ggplot2::geom_point()

accessrmd::access_img(
  plt,
  alt = "Vapor Pressure of Mercury as a Function of Temperature",
  ht = 400
  )
```

In the above chunk, `echo=FALSE` was used to hide the R code that produced the
plot from the knitted HTML document. `message=FALSE` was also used to stop
  messages being knitted to the HTML output.'

  # end of template ---------------------------------------------------------

  # Assemble output
  html_out <- insert_yaml(
    toc = toc, header = header, text = text, lan = lan,
    theme = theme, highlight = highlight
  )

  # write to file
  message(paste("Writing file to", filenm))
  file.create(filenm)
  return(writeLines(paste(html_out), con = filenm))
}
