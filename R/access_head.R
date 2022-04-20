#' Convert YAML to an accessible header
#'
#' Reads an Rmd file, converting the YAML header to a format that is screen
#' reader friendly.
#'
#' @param rmd_path Path to the Rmd that requires accessible header metadata. Rmd
#' must be output type html.
#' @param lan Identify the language of text content. Attempts to find a lang
#' attribute value from the rmd document. Alternatively, use a character string
#' such as "en".
#' @param inplace When set to FALSE (the default) writes to new file. If TRUE,
#' writes in place.
#' @param encoding Defaults to utf-8.
#' @param theme Set to "default", currently the only in-built theme that does
#' not result in accessibility errors.
#' @param highlight Set to "null", currently the only in-built highlight that
#' does not result in accessibility errors.
#'
#' @return Adjust the Rmd YAML provided to `rmd_path`, improving its
#' accessibility for screen readers. Only works with html output.
#'
#' @importFrom stringr str_split str_remove str_squish str_sub
#' @importFrom knitr current_input
#'
#' @examples
#' \dontshow{
#' .old_wd <- setwd(tempdir())
#' }
#' # create a testfile
#' rmd <- tempfile("testing", fileext = ".rmd")
#' # write basic markdown content
#' writeLines('---
#' title: "testfile"
#' author: "Some Author"
#' date: "`r format(Sys.Date(), "%d %b %Y")`"
#' output: html_document
#' ---
#'
#'  ```{r setup, include=FALSE}
#' knitr::opts_chunk$set(echo = TRUE)
#' ```
#'
#' ## R Markdown', con = rmd)
#'
#' # Adjust the document header to improve screen reader accessibility
#' access_head(rmd, lan = "en")
#' \dontshow{
#' setwd(.old_wd)
#' }
#'
#' @export
access_head <- function(rmd_path = NULL,
                        lan = detect_html_lang(lines),
                        inplace = FALSE,
                        encoding = "utf-8",
                        theme = "default",
                        highlight = "null") {
  # check rmd_path
  lines <- handle_rmd_path(rmd_path)
  # check for presence of YAML features
  yaml_bounds <- grep(pattern = "^---$", lines)
  # stop if YAML bounds not standard
  if (length(yaml_bounds) == 0) {
    stop("YAML header not found. Have you previously run 'access_head()'?")
  }
  # produce yaml sequence
  yaml_seq <- yaml_bounds[1]:yaml_bounds[2]
  # extract yaml
  yaml_head <- lines[yaml_seq]
  # extract rmd body
  rmd_body <- lines[(max(yaml_seq) + 1):length(lines)]
  # need to break if func is used recursively
  # find TOC YAML spec & html wrapper markers that 'access_head()' already used
  if (
    # yaml spec
    any(grepl("highlight: null", yaml_head)) &
      any(grepl("theme: default", yaml_head)) &
      # html wrapper spec
      grepl("<html lang", rmd_body[1]) &
      grepl("</html>", rmd_body[length(rmd_body)])
  ) {
    stop("Have you previously run 'access_head()' on this file?")
  }
  # dynamic head logic ------------------------------------------------------
  # Will need to identify YAML elements present and convert to html flexibly
  # remove YAML bounds "---"
  header_txt <- setdiff(yaml_head, "---")
  # check html output is compatible.
  check_compat(header_txt)
  # check config comment ----------------------------------------------------
  # look for `knitr::opts_chunk$set(comment = "")`
  # regex tested: https://regex101.com/r/LHHz88/1
  comm_loc <- grep("opts_chunk\\$set\\(comment ?= ?(\"\"|'')\\)", rmd_body)
  comm_line <- rmd_body[comm_loc]
  # comm_line <- "knitr::opts_chunk$set(comment='')"
  # comm_line <- "# knitr::opts_chunk$set(comment='')"
  # conditions for inserting will be comment line not found or commented out
  # also, if no config chunk set, insert one
  # find the config chunk
  conf_loc <- grep("```\\{r setup", rmd_body)
  if (length(conf_loc) == 0) {
    message("Inserting config chunk.")
    rmd_body <- c(
      "",
      "```{r setup, include=FALSE}",
      "knitr::opts_chunk$set(comment = \"\")",
      "```",
      "",
      rmd_body
    )
  } else if (length(comm_line) == 0) {
    # An acceptable comment line should be inserted into the config chunk
    message("Specifying config comment.")
    # insert the comment spec
    rmd_body <- c(
      rmd_body[1:conf_loc],
      "knitr::opts_chunk$set(comment = \"\")",
      rmd_body[(conf_loc + 1):length(rmd_body)]
    )
  } else if (grepl("^#", comm_line)) {
    # Uncomment the comm_line
    message("Activating comment config.")
    # replace hashed code with unhashed
    rmd_body[comm_loc] <- str_squish(str_remove(comm_line, "^#"))
  }

  # return theme ------------------------------------------------------------
  theme <- find_theme(header_txt)
  # Clean out quotations
  # header_txt <- gsub('"|\'', "", header_txt)
  # find title
  title_content <- str_sub(str_squish(
    str_split(header_txt[grep("title:", header_txt)], ":", n = 2)[[1]][2]
  ), 2, -2)
  # find subtitle
  subtitle <- str_sub(str_squish(
    unlist(str_split(header_txt[grep("subtitle: ", header_txt)], ":", n = 2))[2]
  ), 2, -2)
  # find author
  author <- str_sub(str_squish(
    unlist(str_split(header_txt[grep("author: ", header_txt)], ":", n = 2))[2]
  ), 2, -2)
  # find date
  date <- str_sub(
    str_squish(unlist(str_split(
      header_txt[grep("date: ", header_txt)], ":",
      n = 2
    ))[2]),
    2, -2
  )

  # assemble_header ---------------------------------------------------------

  html_head <- assemble_header(
    title = title_content,
    subtitle = subtitle,
    auth = author,
    doc_date = date,
    enc = encoding
  )

  # toc status --------------------------------------------------------------

  tocify <- FALSE
  tocify <- any(grepl(
    "toc: true|toc: yes|toc_float: true|toc_float: yes",
    header_txt
  ))

  # reassemble the document ------------------------------------------------

  html_out <- insert_yaml(
    toc = tocify,
    header = html_head,
    text = rmd_body,
    lan = lan,
    theme = theme,
    highlight = highlight
  )

  if (inplace == TRUE) {
    # outfile will be the same as infile
    outfile <- rmd_path
  } else {
    # outfile should be placed in accessrmd folder
    # get the file
    rmd_file <- basename(rmd_path)
    # get the directory
    rmd_dir <- str_remove(rmd_path, rmd_file)
    # append accessrmd
    rmd_file <- paste0("accessrmd_", rmd_file)
    # outfile saves to accessrmd dir
    outfile <- paste0(rmd_dir, rmd_file)
  }
  message(paste("Writing file to", outfile))
  return(writeLines(paste(html_out), con = outfile))
}
