# tests -------------------------------------------------------------------
test_that("errors as expected", {
  # errors on null image
  expect_error(access_img(alt = "good alt"), "No img found.")
  # errors on null alt text
  expect_error(access_img(ggplot(mpg, aes(displ, hwy)) + geom_point()),
               "Please include alt text.")
  # errors if alt text set to empty string
  expect_error(access_img(ggplot(mpg, aes(displ, hwy,)) + geom_point(),
                          alt = ""), "Please include alt text.")
  
})

test_that("success produces the required structure", {
  # wrapped in img tag
  expect_match(as.character(access_img(img = ggplot(mpg, aes(displ, hwy,))
                                       + geom_point(), alt = "some alt text")),
               "^<img src=")
  # alt is equivalent to user defined alt text
  expect_match(as.character(access_img(img = ggplot(mpg, aes(displ, hwy,))
                                       + geom_point(), alt = "some alt text")),
               'alt="some alt text"')

})
