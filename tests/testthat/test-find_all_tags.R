
# deps --------------------------------------------------------------------

lines <- c(
  "<img src='something' alt='nbsp'/>", "![nbsp](something)",
  "Not an img", "[Here's a link](some_link.com)",
  "<a href=\"https://some_link.com\">Here's another link</a>"
)
# tests -------------------------------------------------------------------

test_that("func finds imgs only", {
  # markdown & HTML imgs only
  expect_equal(length(find_all_tags(lines, tag = "img")), 2)
})
test_that("func finds links only", {
  expect_equal(length(find_all_tags(lines, tag = "link")), 2)
})

test_that("func returns correct indices in names of out vec", {
  expect_equal(names(find_all_tags(lines, tag = "img")), c("1", "2"))
  expect_equal(names(find_all_tags(lines, tag = "link")), c("4", "5"))
})
