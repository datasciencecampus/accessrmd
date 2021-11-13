
# deps --------------------------------------------------------------------

cerulean <- c(
  "---",
  'title: "cerulean"',
  'author: "R Leyshon"',
  'date: "08/11/2021"',
  "output:",
  "    html_document:",
  "      theme: cerulean",
  "---"
)

flatly <- c(
  "---",
  'title: "flatly"',
  'author: "R Leyshon"',
  'date: "08/11/2021"',
  "output:",
  "    html_document:",
  "      theme: flatly",
  "---"
)

none <- c(
  "---",
  'title: "null"',
  'author: "R Leyshon"',
  'date: "08/11/2021"',
  "output:",
  "    html_document:",
  "      highlight: breezedark",
  "---"
)



# tests -------------------------------------------------------------------
test_that("Func returns found themes", {
  expect_identical(find_theme(cerulean), "cerulean")
  expect_identical(find_theme(flatly), "flatly")
})

test_that(
  "Func returns 'null' if no theme set",
  expect_identical(find_theme(none), "default")
)
