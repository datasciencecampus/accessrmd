#' Render Table of Contents
#'
#' A simple function to extract headers from an RMarkdown document and build a
#' table of contents. Returns a markdown list with links to the headers using
#' [pandoc header identifiers](http://pandoc.org/MANUAL.html#header-identifiers)
#' .
#' WARNING: This function only works with hash-tag headers.
#'
#' Because this function returns only the markdown list, the header for the
#' Table of Contents itself must be manually included in the text. Use
#' `toc_header_name` to exclude the table of contents header from the TOC, or
#' set to `NULL` for it to be included.
#'
#' @section Usage:
#' Just drop in a chunk where you want the toc to appear (set `echo=FALSE`):
#'
#'     # Table of Contents
#'
#'     ```{r echo=FALSE}
#'     render_toc("/path/to/the/file.Rmd")
#'     ```
#'
#' @param filename Name of RMarkdown document
#' @param toc_header_name The table of contents header name. If specified, any
#'   header with this format will not be included in the TOC. Set to `NULL` to
#'   include the TOC itself in the TOC (but why?).
#' @param base_level Starting level of the lowest header level. Any headers
#'   prior to the first header at the base_level are dropped silently.
#' @param toc_depth Maximum depth for TOC, relative to base_level. Default is
#'   `toc_depth = 3`, which results in a TOC of at most 3 levels.
#'   
#' @importFrom stringr str_trim
#'   
#' @export
render_toc <- function(
                       filename,
                       toc_header_name = "Table of Contents",
                       base_level = NULL,
                       toc_depth = 3) {
  x <- handle_rmd_path(filename)
  x <- paste(x, collapse = "\n")
  x <- paste0("\n", x, "\n")
  for (i in 5:3) {
    regex_code_fence <- paste0("\n[`]{", i, "}.+?[`]{", i, "}\n")
    x <- gsub(regex_code_fence, "", x)
  }
  x <- strsplit(x, "\n")[[1]]
  x <- x[grepl("^#+", x)]
  if (!is.null(toc_header_name)) {
    x <- x[!grepl(paste0("^#+ ", toc_header_name), x)]
  }
  header_lvls <- sapply(gsub("(#+).+", "\\1", x), nchar)
  if (is.null(base_level)) {
    base_level <- min(header_lvls)
  }
  start_at_base_level <- FALSE
  n <- 1
  
  links <- sapply(x, function(h) {
    level <- header_lvls[n] - base_level
    if (level < 0) {
      stop(
        "Cannot have negative header levels. Problematic header \"", h, '" ',
        "was considered level ", level, ". Please adjust `base_level`."
      )
    }
    if (level > toc_depth - 1) {
      return("")
    }
    if (!start_at_base_level && level == 0) start_at_base_level <<- TRUE
    if (!start_at_base_level) {
      return("")
    # }
    # if (grepl("\\{#.+\\}(\\s+)?$", h)) {
    #   # has special header slug - this evals to TRUE if {#someID} but FALSE if
    #   # {.toc-ignore}
    #   header_text <- gsub("#+ (.+)\\s+?\\{.+$", "\\1", h)
    #   header_slug <- gsub(".+\\{\\s?#([-_.a-zA-Z]+).+", "\\1", h)
    } else if(grepl("\\{\\.toc-ignore\\}", h)) {
      return("")
    } else {
      header_text <- gsub("#+\\s+?", "", h)
      # previously stripping toc-ignore, now handled above
      # header_text <- gsub("\\s+?\\{.+\\}\\s*$", "", header_text)
      # above line wasn't working if there was no space before curly braces
      header_text <- str_trim(gsub("\\{.+\\}\\s*$", "", header_text))
      # remove up to first alpha char - this was causing digits to be stripped
      # from start of toc links. eg "1st header" would become "st header".
      # Don't see the immediate benefit so commenting out.
      # header_text <- gsub("^[^[:alpha:]]*\\s*", "", header_text)
      header_slug <- paste(strsplit(header_text, " ")[[1]], collapse = "-")
      header_slug <- tolower(header_slug)
    }
    
    # commented out above in favour of below, tested on
    # https://www.regextester.com/97707
    # header_text <- gsub("\\{([^}]+)\\}", "", h)
    # header_slug <- header_text
    # testing regex on https://regex101.com/r/xBTITG/1 adjustment made
    # below catches brackets with classes or IDs
    # grepl("\\{\\.|#.+\\}(\\s+)?$", h)
    
    n <<- n + 1
    unname(
      paste0(strrep(" ", level * 4),
             "- [", header_text, "](#", header_slug, ")")
      )
  })
  
  links <- links[links != ""]
  knitr::asis_output(paste("<nav id=\"TOC\">",
    paste(links, collapse = "<br>"),
    "</nav>",
    sep = "\n"
  ))
}
