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
#' @param inplace When set to FALSE (the default) writes to new file
#' (accessrmd_<rmd_path>). If TRUE, writes in place.
#' @param encoding Defaults to utf-8.
#'
#' @return Adjust the Rmd YAML provided to `rmd_path`, improving its
#' accessibility for screen readers. Only works with html output.
#'
#' @importFrom stringr str_split str_remove str_squish
#' @importFrom knitr current_input
#'
#' @export
access_head <- function(
                        rmd_path = NULL,
                        lan = detect_html_lang(lines),
                        inplace = FALSE,
                        encoding = "utf-8") {
  # check rmd_path
  lines <- handle_rmd_path(rmd_path)
  # check for presence of YAML features
  yaml_bounds <- grep(pattern = "^---$", lines)
  # stop if YAML bounds not standard
  if (length(yaml_bounds) == 0) {
    stop("YAML header not found.")
  }
  # produce yaml sequence
  yaml_seq <- yaml_bounds[1]:yaml_bounds[2]
  # extract yaml
  yaml_head <- lines[yaml_seq]
  # extract rmd body
  rmd_body <- lines[(max(yaml_seq) + 1):length(lines)]
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

  # Clean out quotations
  head <- gsub('"|\'', "", head)
  # find title
  title_content <- str_squish(
    str_split(head[grep("title:", head)], pattern = ":")[[1]][2]
    )
  # find subtitle
  subtitle <- str_squish(
    unlist(str_split(head[grep("subtitle: ", head)], ":"))[2]
    )
  # find author
  author <- str_squish(
    unlist(str_split(head[grep("author: ", head)], ":"))[2]
    )
  # find date
  date <- str_squish(unlist(str_split(head[grep("date: ", head)], ":"))[2])
# assemble_header ---------------------------------------------------------
  
  html_head <- assemble_header(title = title_content,
                               subtitle = subtitle,
                               auth = author,
                               doc_date = date,
                               enc = encoding)

# toc status --------------------------------------------------------------
  
  tocify <- FALSE
  tocify <- any(grepl("toc: true|toc: yes", head))
  if(tocify){
    float <- any(grepl("toc_float: true|toc_float: yes", head))
  }
  if("float" %in% ls()){
    if(float){
      tocify <- "float"
    }
  }
  # reassemble the accessible head ------------------------------------------
  
  html_out <- insert_toc(toc = tocify,
                         header = html_head,
                         text = rmd_body,
                         lan = lan)
  
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
