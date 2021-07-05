# dependencies ------------------------------------------------------------
# produce basic plot
plot(pressure)

# tests -------------------------------------------------------------------

test_that("errors as expected", {
  # errors on null alt text
  expect_error(access_img(), "Please include alt text.")
  
})


