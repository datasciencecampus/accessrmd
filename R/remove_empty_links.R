#' Reads an HTML file, searching for the following structure in the HTML:
#' 
#' <a href="#some_pattern" aria-hidden="true" tabindex="-1"></a>
#' 
#' and tweak it to remove the href = "#some_pattern" component. 
#' 
#' The file is written out to a new HTML, with the prefix "accessible" 
#' 
#' Since windows recognises the \ character as an escape one, the inclusion of windows = TRUE allows
#' the user to specify if this is the case and as such the slashes will be replaced with double slashes
#'(\\) to circumvent this problem. 
#'
#' @param html_file Path to the Rmd that requires links to be checked. Rmd must
#' be output type html.
#' 
#' @windows A boolean that denotes whether to correct the windows backslash character in filepaths
#' 
#' @return A message displaying whether there are any empty links remaining or not.
#'
#' @importFrom stringr str_remove
#' 
#' @export A new HTML file with the prefix 'accessible_'


remove_empty_links <- function(html_file, windows = TRUE) {
  message(paste("Fixing", basename(html_file)))
  lines <- readLines(html_file)
  # Find the code cells only 
  # code_cells <- find_all_code_cells(lines = lines) # Write this function
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
  
  # outfile should be placed in accessrmd folder
  # Replace single slashes with double slashes to solve a windows issue
  if (windows == TRUE){
    html_path <- gsub("\\", "\\\\", html_file, fixed = TRUE)
  }
  else {
    html_path <- html_file
  }
  
  html_name <- basename(html_path)
  # get the directory
  html_dir <- str_remove(html_path, html_name)
  # append accessrmd
  outfile <- paste0(html_dir, "accessible_", html_name)

  message(paste("Writing file to", outfile))
  return(writeLines(paste(cleaned_lines), con = outfile))

}


