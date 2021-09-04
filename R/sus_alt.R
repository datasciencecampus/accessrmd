#' Check an R markdown document for suspicious alt text.
#'
#' Checks if an R markdown contains images alt text is equal to alt attribute
#' placeholder values, including: 'nbsp', 'spacer' and src attribute value
#' (filename).
#'
#' @param rmd_path Path to the Rmd that contains image tags to check.
#' 
#' @param lan Identify the language of text content. Attempts to find a lang
#' attribute value from the rmd document. Alternatively, use a character string
#' such as "en".
#'
#' @return Line numbers of images that has alt text equal to placeholder values.
#'
#' @importFrom stringr str_split str_extract str_remove_all str_squish
#' @importFrom rlist list.apply
#' @export
sus_alt <- function(rmd_path = NULL, lan = detect_html_lang(lines)) {
  message(paste0("Checking ", basename(rmd_path), "..."))
  # read lines from rmd_path if valid
  lines <- handle_rmd_path(rmd_path)
  # define placeholder values
  place_val <- c("nbsp", "spacer")
  # return image lines only
  images <- find_all_imgs(lines)
# get alt & src -----------------------------------------------------------
  
  # this can be img tag or markdown syntax
  alts <- str_extract(
    string = images,
    # regex tested https://regex101.com/r/FAEyCa/2
    "alt *= *\\\\??\"(.*?)\"|alt *= *\\\\??'(.*?)'|!\\[(.*?)\\]"
  )
  srcs <- str_extract(
    string = images,
    # regex tested https://regex101.com/r/Ox2SqC/1
    "src *= *\\\\??\"(.*?)\"|src *= *\\\\??'(.*?)'|\\]\\((.*?)\\)"
  )
  
  # clean up srcs and alts
  srcs <- str_squish(str_remove_all(srcs, "src| *=|\\]\\(|\\)|'|\""))
  alts <- str_squish(str_remove_all(alts, "alt| *=|!\\[|\\]|\"|'"))
  # NA values for cases like <img src='no_alt_included'>
  # convert to "" for consistent handling
  alts[is.na(alts)] <- ""
  
  # lang specific alt length limits -----------------------------------------
  lim <- find_alt_lim(lines)
  
  # if(!is.null(lim)){
  # 
  #   
  # }

  # check for placeholder values --------------------------------------------
  plac_ind <- as.numeric(names(
    images[grepl(paste(place_val, collapse = "|"), alts) | alts == ""]
    ))
  # store the lines where placeholders were used
  plac_found <- lines[plac_ind]
  # messages for placeholder text
  if (length(plac_found) == 0) {
    message("No images with placeholder text found.")
  } else {
    warning(paste(
      length(plac_found),
      "image(s) with placeholder text found.\n Check lines:\n",
      paste(plac_ind, collapse = ", "),
      "\nalt text should not be empty or equal to 'spacer' or 'nbsp'.\n"
    ))
  }
  # check for any images where src == alt -----------------------------------
  
  dupe_ind <- as.numeric(names(images[srcs == alts]))
  # store the lines with duplicated attribute values
  dupe_found <- lines[dupe_ind]
  # update with original indices
  names(dupe_found) <- dupe_ind
  # messages for dupe text
  if (length(dupe_found) == 0) {
    message("No images with equal src and alt values found.")
  } else {
    warning(paste(
      length(dupe_found),
      "image(s) with equal src & img found.\n Check lines:\n",
      paste(names(dupe_found), collapse = ", "),
      "\nalt text should not be equal to src."
    ))
  }
}
