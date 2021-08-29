# store the current wd in global scope and setwd to tempdir
with(globalenv(), {
  .old_wd <- setwd(tempdir())
})
# tests -------------------------------------------------------------------

test_that("Func behaves as expected on minimal parameters", {
  expect_message(access_rmd("minimal", title = "minimal test", lan = "en"),
                 "Setting html lan to en")
})

# test output
lines <- readLines("minimal")
test_that("Output has been written as expected", {
  expect_equal(grep("    <meta charset=\"utf-8\"/>", lines), 3)
  expect_equal(grep("    <title>minimal test</title>", lines), 4)
  expect_equal(grep("    <h1 id=\"title toc-ignore\">minimal test</h1>" ,
                    lines), 5)
  expect_equal(grep("    <h2 class=\"header_h2s\">richardleyshon</h2>", lines),
               6)
  expect_equal(grep("    <h2 class=\"header_h2s\">29 Aug 2021</h2>", lines), 7)
  expect_equal(grep("  </header>", lines), 8)
  expect_equal(grep("  <body>", lines), 9)
})

# set the wd to test directory
with(globalenv(), {
  setwd(.old_wd)
})