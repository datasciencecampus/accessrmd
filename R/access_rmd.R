#' Produce an accessible Rmarkdown file template.
#'
#' Creates an Rmarkdown template with the HTML structure required by screen
#' readers.
#'
#' @param filenm Required - The name of the file.
#' @param title Required - The document title.
#' @param lan Required - The HTML language to set as the value for the lang
#' attribute.
#' @param author Required - The document author. Defaults to the effective user
#' identified by `Sys.info()`.
#' @param date Required - The author date. Defaults to today's date.
#' @param subtitle Optional - The document subtitle.
#' @param toc Optional, defaults to FALSE. Should a table of contents be
#' included.
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
  lan = NULL,
  author = Sys.info()[8],
  date = format(Sys.Date(), "%d %b %Y"),
  subtitle = NULL,
  toc = FALSE,
  encoding = "utf-8",
  force = FALSE
  ){
  # Stop if lan  = NULL
  if(is.null(lan)){
    stop("No value provided to 'lan'.")
  }
  # stop if title is NULL
  if(is.null(title)){
    stop("No title is provided.")
  }
  # remove any spaces from filenm
  filenm <- str_remove_all(filenm, " ")
  # feat: logic to add ".Rmd" if forgotten
  if(!grepl(".Rmd$", filenm, ignore.case = TRUE)){
    filenm <- paste0(filenm, ".Rmd")
  }
  # force parameter that warns if file found
  if(all(file.exists(filenm) & force)){
    warning("'force' is TRUE. Overwriting filenm.")
  } else if(all(file.exists(filenm) & !force)){
    stop("filenm found on disk. 'force' is FALSE.")
  }
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
  # Insert render_toc if toc is TRUE
  # conditional logic if toc is TRUE, insert code chunk that renders toc
  if(toc){
    message("Embedding render_toc code chunk")
    text <-  c("",
                   "```{r, echo=FALSE}",
                   "library(accessrmd, quietly = TRUE)",
                   "render_toc(basename(knitr::current_input()))",
                   "```",
                   text)
  }
  # wrap text in body tags
  body <- tags$body(paste(text, collapse = "\n"))
  # set the html lang & message
  message(paste("Setting html lan to", lan))
  html_out <- tags$html(head, body, lang = lan)
  # cleaning of html reserved words -----------------------------------------
  # <> have been replaced with &lt; and &gt; due to HTML reserved words
  # gsub them back
  html_out <- gsub("&lt;", "<", html_out)
  html_out <- gsub("&gt;", ">", html_out)
  # write to file
  file.create(filenm)
  writeLines(paste(html_out), con = filenm)
}