# tests -------------------------------------------------------------------
test_that("null img error", {
  expect_error(access_img(alt = "good alt"), "No img found.")
  
})

# produce plot
ggplot(mpg, aes(displ, hwy)) + geom_point()

test_that("alt text errors", {
  # errors on null alt text
  expect_error(access_img(), "Please include alt text.")
  # errors if alt text set to empty string
  expect_error(access_img(alt = ""), "Please include alt text.")
  
})

test_that("success produces the required structure", {
  # wrapped in img tag
  expect_match(as.character(access_img(alt = "testing img tag")), "^<img src=")
  # alt is equivalent to user defined alt text
  expect_match(as.character(access_img(alt = "testing alt text")),
               'alt="testing alt text"')

})