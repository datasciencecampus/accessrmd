
# deps --------------------------------------------------------------------

lines <- c("<img src='something' alt='nbsp'/>", "![nbsp](something)",
           "Not an img")
# tests -------------------------------------------------------------------

test_that("func finds imgs only", {
  # markdown & HTML imgs only
  expect_equal(length(find_all_imgs(lines)), 2)
})

test_that("func returns correct indices in names of out vec", {
  expect_equal(names(find_all_imgs(lines)), c("1","2"))
})
