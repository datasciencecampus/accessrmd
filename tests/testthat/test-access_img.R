# dependencies ------------------------------------------------------------
plot(pressure)

# tests -------------------------------------------------------------------
test_that("errors as expected", {
  # errors on null alt text
  expect_error(access_img(), "Please include alt text.")
  # expect_error(access_img(alt = ""), "Please include alt text.")
  
})


