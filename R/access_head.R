#' Convert YAML to an accessible header
#'
#' Reads an Rmd file, converting the YAML header to a format that is screen
#' reader friendly.
#'
#' @param rmd_path Path to the Rmd that requires accessible header metadata. Rmd
#' must be output type html.
#' @param lan Identify the language of text content.
#' @param inplace When set to FALSE (the default) writes to new file
#' (accessrmd_<rmd_path>). If TRUE, writes in place.
#' @param encoding Defaults to utf-8.
#'
#' @return Adjust the Rmd YAML provided to `rmd_path`, improving its
#' accessibility for screen readers. Only works with html output.
#'
#' @importFrom stringr str_split str_remove
#' @importFrom knitr current_input
#'
#' @export
access_head <- function(
  rmd_path = NULL,
  lan = NULL,
  inplace = FALSE,
  encoding = "utf-8") {
  # check rmd_path
  lines <- handle_rmd_path(rmd_path)
  # check for presence of YAML features
  yaml_bounds <- grep(pattern = "^---$", lines)
  # stop if YAML bounds not standard
  if (length(yaml_bounds) == 0) {
    stop("YAML header not found.")
  } else if (length(yaml_bounds) != 2) {
    stop("Non standard YAML found.")
  }
  # produce yaml sequence
  yaml_seq <- yaml_bounds[1]:yaml_bounds[2]
  # extract yaml
  yaml_head <- lines[yaml_seq]
  # extract rmd body
  rmd_body <- lines[(max(yaml_seq) + 1):length(lines)]
  # conditional logic if toc:true, insert code chunk that renders toc
  if(any(grepl("toc: true|toc: yes", yaml_head))){
    rmd_body <-  c("",
          "```{r, echo=FALSE}",
          "library(accessrmd, quietly = TRUE)",
          "render_toc(basename(knitr::current_input()))",
          "```",
          rmd_body)
  }
  # append the body with element tags
  rmd_body <- tags$body(paste(rmd_body, collapse = "\n"))

  # dynamic head logic ------------------------------------------------------
  # Will need to identify YAML elements present and convert to html flexibly
  # remove YAML bounds "---"
  head <- setdiff(yaml_head, "---")
  # check for html output type. Stop if not.
  html_loc <- grepl(pattern = "html_document", head)

  if (any(html_loc)) {
    # html found. subset out the html tag.
    head <- head[!html_loc]
  } else {
    stop("'access_head()' only works with html output.")
  }
  # look for lang in YAML
  lang <- head[grep("^    lang:", head)]
  # above returns length 0 vector if not found
  if (length(lang) != 0) {
    # split on "|' and take the second item
    lan <- unlist(strsplit(lang, '"|\''))[2]
    message(paste("YAML lang found. Setting HTML lang as", lan))
  }

  # stop if no lang value found
  if (is.null(lan) | length(lan) == 0) {
    stop('No value provided to "lan" or lang value found in YAML.')
  }

  # Clean out quotations
  head <- gsub('"|\'', "", head)
  # find title
  title_index <- grep("title:", head)
  title_content <- str_split(head[title_index], pattern = ":")[[1]][2]
  # produce the accessible title
  html_title <- tags$title(title_content)
  # h1 needs to be the same as title
  h1_content <- tags$h1(title_content, id = "title toc-ignore")
  # find indices for additional header titles
  hd_indices <- grep("author:|date:", head)
  # produce the accessible h2 titles styled as h4
  h2s <- sapply(str_split(head[hd_indices], pattern = ":"), "[[", 2)
  # produce the accessible headers
  html_h2s <- sapply(h2s, tags$h2, class = "header_h2s", simplify = FALSE)

  # reassemble the accessible head ------------------------------------------
  html_head <- tags$header(tags$meta(charset = encoding),
                           html_title,
                           h1_content,
                           unname(html_h2s))

  # set the html lang & message
  message(paste("Setting html lan to", lan))
  html_out <- paste("<!DOCTYPE html>",
                    tags$html(html_head, rmd_body, lang = lan),
                    sep = "\n")

  # cleaning of html reserved words -----------------------------------------
  # <> have been replaced with &lt; and &gt; due to HTML reserved words
  # gsub them back
  html_out <- gsub("&lt;", "<", html_out)
  html_out <- gsub("&gt;", ">", html_out)

  if (inplace == TRUE) {
    # outfile will be the same as infile
    outfile <- rmd_path
  } else {
    # outfile should be placed in accessrmd folder
    # get the file
    rmd_file <- basename(rmd_path)
    # get the directory
    rdm_dir <- str_remove(rmd_path, rmd_file)
    # store dir loc
    dir_loc <- paste0(rdm_dir, "accessrmd/")
    # create the accessrmd dir
    dir.create(dir_loc)
    # outfile saves to accessrmd dir
    outfile <- paste0(dir_loc, rmd_file)
  }
  return(writeLines(paste(html_out), con = outfile))
}
