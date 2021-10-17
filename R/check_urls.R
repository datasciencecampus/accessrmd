#' Check an Rmarkdown for broken links.
#'
#' Check links within an Rmarkdown document for any urls that responds with an
#' error.
#'
#' @param rmd_path Path to the Rmd that requires links to be checked. Rmd must
#' be output type html.
#'
#' @return Lines of any urls that respond with an error.
#'
#' @importFrom stringr str_extract
#' @importFrom RCurl url.exists
#'
#' @export
rmd_path <- "tests/testfiles/test_links.Rmd"
check_urls <- function(rmd_path) {
  message(paste("Checking", basename(rmd_path)))
  lines <- handle_rmd_path(rmd_path = rmd_path)
  # find the links only
  link_tags <- find_all_tags(lines = lines, tag = "link")
  # cleanse the link text
  # regex tested https://regex101.com/r/3JGxIG/1
  link_url <- str_extract(link_tags, "(?<=\\]).* *\\)|(?<=href\\=).* *(\"|')")

  # tidy up links -----------------------------------------------------------
  link_url <- str_remove_all(link_url, "\\(|\\)|\"|'|\\\\")
  names(link_url) <- names(link_tags)

  # check links -------------------------------------------------------------
  responses <- RCurl::url.exists(link_url)
  errors <- link_url[!responses]

  # output messages ---------------------------------------------------------
  if (length(errors) == 0) {
    message("No links returned an error.")
  } else {
    warning(
      "Check lines for broken links:\n",
      paste(names(errors), collapse = "\n")
    )
  }
}
