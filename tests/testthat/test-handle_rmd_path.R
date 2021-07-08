test_that("Func fails as expected", {
  expect_error(handle_rmd_path(), "rmd_path is NULL.")
  
  expect_error(handle_rmd_path("something.doc"),
               "Ensure that an Rmd file is passed to rmd_path.")
  
  expect_error(handle_rmd_path("something.Rmd"), "rmd file not found.")
})


