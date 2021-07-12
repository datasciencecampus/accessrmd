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
#' 
#' @return Adjust the Rmd YAML provided to `rmd_path`, improving its
#' accessibility for screen readers. Only works with html output.
#' 
#' @importFrom stringr str_split str_remove
#' 
#' @export
access_head <- function(rmd_path = NULL, lan = NULL, inplace = FALSE){
  # check rmd_path
  lines <- handle_rmd_path(rmd_path)
  # check for presence of YAML features
  yaml_bounds <- grep(pattern = "^---$", lines)
  # stop if YAML bounds not standard
  if(length(yaml_bounds) == 0){
    stop("YAML header not found.")
  } else if(length(yaml_bounds) != 2){
    stop("Non standard YAML found.")
  } else if(is.null(lan) | length(lan) == 0){
    stop("lan requires a value.")
  }
  # produce yaml sequence
  yaml_seq <- yaml_bounds[1]:yaml_bounds[2]
  # extract yaml
  yaml_head <- lines[yaml_seq]
  # extract rmd body
  rmd_body <- lines[(max(yaml_seq) + 1):length(lines)]
  # append the body with element tags
  rmd_body <- tags$body(paste(rmd_body, collapse = "\n"))

# dynamic head logic ------------------------------------------------------
  # Will need to identify YAML elements present and convert to html flexibly
  # remove YAML bounds "---"
  head <- setdiff(yaml_head, "---")
  # check for html output type. Stop if not.
  html_loc <- grepl(pattern = "^output: html_document$", head)

  if(any(html_loc)){
    # html found. subset out the html tag.
    head <- head[!html_loc]
  } else{
    stop("access_head() only works with html output.")
  }
  # Clean out the escape chars
  # remove all besides the alphabets, numbers, : and /
  # finding a simple implementation to remove single escapes is elusive
  head <- gsub("[^A-Za-z0-9:/]", "", head)
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
  html_head <- tags$header(html_title, h1_content, unname(html_h2s))
  
  # set the html lang
  html_out <- tags$html(html_head, rmd_body, lang = lan)

# cleaning of html reserved words -----------------------------------------
  # <> have been replaced with &lt; and &gt; due to HTML reserved words
  # gsub them back
  html_out <- gsub("&lt;", "<", html_out)
  html_out <- gsub("&gt;", ">", html_out)
  
  if(inplace == TRUE){
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
