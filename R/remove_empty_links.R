#' Removes the empty links attached to each code cell in the HTML output.
#'
#' Reads an Rmd file, searching for the following structure in the HTML:
#' 
#' <a href="#some_pattern" aria-hidden="true" tabindex="-1"></a>
#' 
#' and tweak it to remove the href = "#some_pattern" component. 
#'
#' @param html_file Path to the Rmd that requires links to be checked. Rmd must
#' be output type html.
#'
#' @return Lines of any urls that respond with an error.
#'
#' @importFrom stringr str_extract
#' 
#' @export


remove_empty_links <- function(html_file) {
  message(paste("Fixing", basename(html_file)))
  lines <- readLines(html_file)
  # Find the code cells only 
  code_cells <- find_all_code_cells(lines = lines) # Write this function
  # Remove the empty links
  cleaned_code_cells <- gsub('href="#cb[0-9]*-[0-9]*" aria-hidden="true" tabindex="-1"', 
                             'aria-hidden="true" tabindex="-1"',
                             code_cells)
  
  # Compute number of empty links remaining
  errors <- sum(grepl(pattern = 'href="#cb[0-9]*-[0-9]*" aria-hidden="true" tabindex="-1"', 
                      cleaned_code_cells))
  
  # Output messages
  if (errors == 0) {
    message("There are no empty links remaining.")
  }
  else {
    warning("There are still some empty links, diagnose in the HTML and add this to the issues page at https://github.com/datasciencecampus/accessrmd")
  }
}
