#' Check an image for suspicious alt text.
#'
#' Checks if an image's alt text is equal to alt attribute placeholder values,
#' including: 'nbsp', 'spacer' and src attribute value (filename).
#'
#' @param rmd_path Path to the Rmd that contains image tags to check.
#'
#' @return Line numbers of images that has alt text equal to placeholder values.
#'
#' @importFrom stringr str_split str_extract str_remove_all
#' @importFrom rlist list.apply
#' @export
sus_alt <- function(rmd_path = NULL){
  message(paste0("Checking ", basename(rmd_path), "..."))
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
  # note: going for base strsplit as stringr::str_split produces "" padding
  # that becomeas a problem when finding duplicates later
  img_split <- strsplit(img_only, "\"|'|!\\[|]\\(|\\)")
  # update indices
  names(img_split) <- names(img_only)
# check for placeholder values --------------------------------------------
  plac_list <- list.apply(img_split, .fun = function(x) any(place_val %in% x))
  # filter for placeholder values only
  plac_ind <- as.numeric(names(plac_list[plac_list == TRUE]))
  # store the lines where placeholders were used
  plac_found <- lines[plac_ind]
  # messages for placeholder text
  if(length(plac_found) == 0){
    message("No images with placeholder text found.")
  } else{
    warning(paste(length(plac_found),
                  "image(s) with placeholder text found.\n Check lines:\n",
                  paste(names(plac_found), collapse = ", "),
                  "\nalt text should not be equal to 'spacer' or 'nbsp'."
                  ))

    }
  # check for any images where src == alt -----------------------------------
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
  # at this point, the only false positive cases are like:
  # <img src = "something" alt = "something else" height = "400" width = "400"/>
  # now need to remove these cases as not a problem
  spec_dims <- dupe_found[grep(dupe_found, pattern = "height|width")]
  # check if any spec_dims images have differing src & alt values
  # regex texted https://regex101.com/r/UiKqmA/1
  # extract only src and alt attribute values only
  # flexible to use of " and '
  srcs <- str_extract(
    string = spec_dims,
    "src *= *\\\\??\"(.*?)\"|src *= *\\\\??'(.*?)'"
    )
  
  alts <- str_extract(
    string = spec_dims,
    "alt *= *\\\\??\"(.*?)\"|alt *= *\\\\??'(.*?)'"
  )
  # clean up srcs and alts
  srcs <- str_remove_all(srcs, "src| *")
  alts <- str_remove_all(alts, "alt| *")
  # compare the src with alt attributes and find the things to be ignored
  # these should be where src and alt are not matches
  prob_ind <- names(spec_dims[srcs != alts])
  # remove any problem indices from the found duplicates
  dupe_found <- dupe_found[setdiff(names(dupe_found), prob_ind)]
  # messages for dupe text
  if(length(dupe_found) == 0){
    message("No images with equal src and alt values found.")
  } else{
    warning(paste(length(dupe_found),
                  "image(s) with equal src & img found.\n Check lines:\n",
                  paste(names(dupe_found), collapse = ", "),
                  "\nalt text should not be equal to src."
    ))
    
  }

}


