
# test fail ---------------------------------------------------------------
test_that("Func fails as expected", {
  expect_error(handle_rmd_path(), "rmd_path is NULL.")

  expect_error(
    handle_rmd_path("something.doc"),
    "Ensure that an Rmd file is passed to rmd_path."
  )

  expect_error(handle_rmd_path("something.Rmd"), "rmd file not found.")
})

# create an rmd to test ---------------------------------------------------
# store the current wd in global scope and setwd to tempdir
with(globalenv(), {
  .old_wd <- setwd(tempdir())
})
# create filename
tmp <- tempfile(fileext = ".Rmd")
# create file
file.create(tmp, showWarnings = FALSE)
writeLines("placeholder text", con = tmp)

# test success ------------------------------------------------------------
test_that("Expected output on success", {
  expect_equal(handle_rmd_path(tmp), "placeholder text")
})


# set the wd to test directory
with(globalenv(), {
  setwd(.old_wd)
})
