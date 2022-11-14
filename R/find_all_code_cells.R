#' Find any markdown or HTML syntax tags within read lines.
#'
#' Check any lines for images or links and return the line numbers and values.
#'
#' @param html_file Read lines, default is NULL & typically used with output of
#' handle_rmd_path.
#'
#' @return A named vector containing the code cells present in the lines read from the HTML.
#'
find_all_code_cells <- function(lines) {
  # Obtain the lines from the HTML file
  
  code_ind <- grep(pattern = 'href="#cb[0-9]*-[0-9]*" aria-hidden="true" tabindex="-1"', lines)
  
  code_only <- lines[code_ind]
  
  return(code_only)
  
}
