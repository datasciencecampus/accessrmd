#' Reads an HTML file, searching for the following structure in the HTML:
#' 
#' <a href="#some_pattern" aria-hidden="true" tabindex="-1"></a>
#' 
#' and tweak it to remove the href = "#some_pattern" component. 
#' 
#' These must be removed as they are causing code cells to be skipped by screen readers
#' and are one of the biggest Web Content Accessibility Guideline Errors picked up on
#' during the audit. 
#' 
#' The file is written out to a new HTML, with the prefix "accessible" 
#'
#' @param html_file Path to the Rmd that requires links to be checked. Rmd must
#' be output type html.
#' 
#' @return A message displaying whether there are any empty links remaining or not and
#' a further message detailing the creation of the new accessible html, displaying its
#' absolute file path.
#'
#' @importFrom stringr str_remove
#' 
#' @export A new HTML file with the prefix 'accessible_'


remove_empty_links <- function(html_file) {
  
  # Initial message
  message(paste("Fixing", basename(html_file)))
  lines <- readLines(html_file)
  
  # Remove the empty links
  cleaned_lines <- gsub('href="#cb[0-9]*-[0-9]*" aria-hidden="true" tabindex="-1"', 
                             'aria-hidden="true" tabindex="-1"',
                             lines)
  
  # Compute number of empty links remaining
  errors <- sum(grepl(pattern = 'href="#cb[0-9]*-[0-9]*" aria-hidden="true" tabindex="-1"', 
                      cleaned_lines))
  
  # Output messages
  if (errors == 0) {
    message("There are no empty links remaining.")
  }
  else {
    warning("There are still some empty links, diagnose in the HTML and add this to the issues page at https://github.com/datasciencecampus/accessrmd")
  }
  
  # Reassemble the document
  
  html_name <- basename(html_file)
  # get the directory
  html_dir <- str_remove(html_file, html_name)
  # append accessible_
  outfile <- paste0(html_dir, "accessible_", html_name)

  message(paste("Writing file to", outfile))
  return(writeLines(paste(cleaned_lines), con = outfile))

}


