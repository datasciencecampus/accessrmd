#' Check an image for suspicious alt text.
#'
#' Checks if an image's alt text is equal to alt attribute placeholder values,
#' including: 'nbsp', 'spacer' and src attribute value (filename).
#'
#' @param rmd_path Path to the Rmd that contains image tags to check.
#'
#' @return Line numbers of images that has alt text equal to placeholder values.
#'
#' @importFrom stringr str_split
#' @importFrom rlist list.apply
#' @export
sus_alt <- function(rmd_path = NULL){
  # define placeholder values
  place_val <- c("nbsp", "spacer")
  # read lines form rmd_path if valid
  lines <- handle_rmd_path(rmd_path)
# only want img tags but preserve indexing --------------------------------
  # set the names of the lines vector as a count
  names(lines) <- seq_along(lines)
  # regex matches img tags & ![]() markdown syntax
  # tested on https://regex101.com/r/CU4g3f/1
  img_ind <- grep(pattern = "(<img.* *>|\\!\\[.* *]\\(.* *\\))", lines)
  img_only <- lines[img_ind]
  # need to obtain values of src and alt attributes
  # this can be img tag or markdown syntax
  # tested on https://regex101.com/r/2wKGsF/1
  img_split <- str_split(img_only, pattern = "\"|'|!\\[|]\\(|\\)")
  
  names(img_split) <- names(img_only)
# check for placeholder values --------------------------------------------
  plac_list <- list.apply(img_split, .fun = function(x) any(place_val %in% x))
  # filter for placeholder values only
  plac_ind <- as.numeric(names(plac_list[plac_list == TRUE]))
  # store the lines where placeholders were used
  plac_found <- lines[plac_ind]
# check for any images where src == alt -----------------------------------
  # remove any "" false positives from the split lines
  cond <- list.apply(img_split, function(x) x == "")
stop('here')
  list(unlist(foo)[unlist(list.apply(foo, function(x) x != "a"))])
  
  # after some unsuccessful regex testing due to flexibility in valid HTML
  # I've taken the approach to warn where any element resulting from the
  # str_split above is potentially src == alt. This could fall down if
  # another valid attribute value is equivalent to any other, such as
  # height and width being the same value.
  dupe_list <- list.apply(img_split, .fun = function(x) any(duplicated(x)))
  # filter for true cases only
  dupe_ind <- as.numeric(names(dupe_list[dupe_list == TRUE]))
  # store the lines with duplicated attribute values
  dupe_found <- lines[dupe_ind]

  
  

  
  
  

}


