# store the current wd in global scope and setwd to tempdir
with(globalenv(), {
  .old_wd <- setwd(tempdir())
})



# dependencies ------------------------------------------------------------

good_img <- tempfile(fileext = ".Rmd")
file.create(good_img)
writeLines("<img src='something' alt='something else'/>", con = good_img)

bad_img <- tempfile(fileext = ".Rmd")
file.create(bad_img)
writeLines("<img src='something' alt='something'/>", con = bad_img)

plac_img <- tempfile(fileext = ".Rmd")
file.create(plac_img)
writeLines("<img src='something' alt='nbsp'/>", con = plac_img)

specdim_imgs <- tempfile(fileext = ".Rmd")
file.create(specdim_imgs)
writeLines(
  "
  <img src='something' alt='acceptable alt text' height='300' width='300'/> 
  <img src='something' alt='spacer' height='300' width='400'/>
  ",
  con = specdim_imgs
)

# tests -------------------------------------------------------------------

test_that("Messages when no suspicious cases are found", {
  expect_message(
    sus_alt(good_img),
    paste0("Checking ", basename(good_img), "...")
  )
  expect_message(
    sus_alt(good_img),
    "No images with placeholder text found."
  )
  expect_message(
    sus_alt(good_img),
    "No images with equal src and alt values found."
  )
})

test_that("Messages when dupe alt is found", {
  expect_message(
    suppressWarnings(sus_alt(bad_img)),
    paste0("Checking ", basename(bad_img), "...")
  )
  expect_message(
    suppressWarnings(sus_alt(bad_img)),
    "No images with placeholder text found."
  )
  expect_warning(sus_alt(bad_img), "alt text should not be equal to src.")
  expect_warning(sus_alt(bad_img), "1")
})

test_that("Messages when placeholder alt is found", {
  expect_message(
    suppressWarnings(sus_alt(plac_img)),
    paste0("Checking ", basename(plac_img), "...")
  )
  expect_message(
    suppressWarnings(sus_alt(plac_img)),
    "No images with equal src and alt values found."
  )
  expect_warning(
    sus_alt(plac_img),
    "alt text should not be equal to 'spacer' or 'nbsp'."
  )
  expect_warning(sus_alt(plac_img), "1")
})

test_that("imgs with square specified dims do not get flagged as suspicious", {
  expect_warning(sus_alt(specdim_imgs), "3")
})

# set the wd to test directory
with(globalenv(), {
  setwd(.old_wd)
})
