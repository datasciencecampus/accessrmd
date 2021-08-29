#' Produce an accessible Rmarkdown file template.
#'
#' Creates an Rmarkdown template with the HTML structure required by screen
#' readers.
#'
#' @param filenm Required - The name of the file.
#' @param title Required - The document title.
#' @param author Required - The document author. Defaults to the effective user
#' identified by `Sys.info()`.
#' @param date Required - The author date. Defaults to today's date.
#' @param lan Required - The HTML language to set as the value for the lang
#' attribute.
#' @param subtitle Optional - The document subtitle
#' @param toc Optional, defaults to FALSE. Should a table of contents be
#' included.
#' @param encoding Defaults to "utf-8".
#'
#' @return An Rmarkdown file with an HTML head, populated with metadata
#' specified within the function parameters. 
#'
#' @export
access_rmd <- function(
  filenm = NULL,
  title = NULL,
  author = Sys.info()[8],
  date = format(Sys.Date(), "%d %b %Y"),
  lan = NULL,
  subtitle = NULL,
  toc = FALSE,
  encoding = "utf-8"
  ){
  # obtain any metadata needed for h2 headers
  h2s <- c(author, date, subtitle)
  # produce the accessible headers
  html_h2s <- sapply(h2s, tags$h2, class = "header_h2s", simplify = FALSE)
  # assemble head
  head <- tags$header(
    tags$meta(charset = encoding),
    tags$title(title),
    # h1 needs to be the same as title
    tags$h1(title, id = "title toc-ignore"),
    unname(html_h2s)
  )

# template ----------------------------------------------------------------
  text <- "
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
  
## Adapted R Markdown

This R Markdown templated has been adapted using the 'accessrmd' package. This
template has a different head and HTMl structure to the standard R markdown
template. This is to improve the accessibility of the knitted HTML documents for
screen readers.

For more help in using R Markdown see <http://rmarkdown.rstudio.com>.

Clicking the **Knit** button will generate a document including typed contentand
the output of any R code chunks. For example:
    
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

  # wrap text in body tags
  body <- tags$body(text)
  # set the html lang & message
  message(paste("Setting html lan to", lan))
  html_out <- tags$html(head, body, lang = lan)
  # write to file
  file.create(filenm)
  writeLines(paste(html_out), con = filenm)
}