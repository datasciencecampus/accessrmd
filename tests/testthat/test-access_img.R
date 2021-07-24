# store the current wd in global scope and setwd to tempdir
with(globalenv(), {
  .old_wd <- setwd(tempdir())
})

# tests -------------------------------------------------------------------
test_that("null img error", {
  expect_error(access_img(alt = "good alt"), "No img found.")
})

# produce plot
ggplot(mpg, aes(displ, hwy)) +
  geom_point()

test_that("alt text messages", {
  # errors on null alt text
  expect_error(access_img(), "Please include alt text.")
  # errors if alt text set to empty string
  expect_warning(
    access_img(alt = ""),
    "Empty alt text should be used for decorative images only."
  )
})

test_that("success for inline code", {
  # wrapped in img tag
  expect_match(as.character(access_img(alt = "testing img tag")), "^<img src=")
  # alt is equivalent to user defined alt text
  expect_match(
    as.character(access_img(alt = "testing alt text")),
    'alt="testing alt text"'
  )
})

# create a png to test
png(filename = "test.png")

test_that("success for disk images", {
  # wrapped in img tag
  expect_match(as.character(
    access_img(img = "test.png", alt = "testing img tag")
  ), "^<img src=")
  # alt is equivalent to user defined alt text
  expect_match(as.character(
    access_img(img = "test.png", alt = "testing alt text")
  ), 'alt="testing alt text"')
})

# set the wd to test directory
with(globalenv(), {
  setwd(.old_wd)
})
