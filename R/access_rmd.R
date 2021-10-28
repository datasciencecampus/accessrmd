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
#' included. Valid entries are FALSE, TRUE or "float".
#' @param encoding Defaults to "utf-8".
#' @param force Defaults to FALSE. If TRUE, overwrites a pre-existing file with
#' the same filenm with warning.
#'
#' @return An Rmarkdown file with an HTML head, populated with metadata
#' specified within the function parameters.
#'
#' @importFrom stringr str_remove_all
#'
#' @export
access_rmd <- function(
                       filenm = NULL,
                       title = NULL,
                       subtitle = NULL,
                       lan = NULL,
                       author = Sys.info()[8],
                       date = format(Sys.Date(), "%d %b %Y"),
                       toc = FALSE,
                       encoding = "utf-8",
                       force = FALSE) {

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
  text <- "
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
  
## Adapted R Markdown

This R Markdown templated has been adapted using the 'accessrmd' package. This
template has a different head and HTML structure to the standard R markdown
template. This is to improve the accessibility of the knitted HTML documents for
screen readers.

For more help in using R Markdown see <http://rmarkdown.rstudio.com>.

Clicking the **Knit** button will generate a document including typed content
and the output of any R code chunks. For example:
    
```{r cars}
summary(cars)
```

## Plots
  
```{r pressure, echo=FALSE}
plot(pressure)
```

In the above chunk, `echo = FALSE` was used to hide the R code that produced the
plot from the knitted HTML document."
  # end of template ---------------------------------------------------------

  # Assemble output
  html_out <- insert_toc(toc = toc, header = header, text = text, lan = lan)

  # write to file
  file.create(filenm)
  return(writeLines(paste(html_out), con = filenm))
}
