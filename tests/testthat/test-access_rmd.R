# store the current wd in global scope and setwd to tempdir
with(globalenv(), {
  .old_wd <- setwd(tempdir())
})
# tests -------------------------------------------------------------------

test_file <- tempfile(fileext = ".Rmd")
test_toc <- tempfile(fileext = ".Rmd")

test_that("Func behaves as expected on minimal parameters", {
  expect_message(
    access_rmd(test_file, title = "minimal test", lan = "en"),
    "Setting html lan to en"
  )
  expect_message(
    access_rmd(test_toc,
      title = "minimal test", lan = "en",
      toc = TRUE
    ),
    "Embedding render_toc code chunk"
  )
  expect_true(file.exists(test_file))
})

test_that("Func errors as expected", {
  expect_error(
    access_rmd("error_file", title = "error testing"),
    "No value provided to 'lan'."
  )
  expect_error(
    access_rmd(filenm = "another_error", lan = "en"),
    "No title is provided."
  )
  expect_error(
    access_rmd(test_file, title = "Already Exists", lan = "en"),
    "filenm found on disk. 'force' is FALSE."
  )
})

# test output
lines <- readLines(test_file)
toc_lines <- readLines(test_toc)
test_that("Output has been written as expected", {
  expect_true(any(grepl("  <meta charset=\"utf-8\"/>", lines)))
  expect_true(any(grepl("  <title>minimal test</title>", lines)))
  expect_true(
    any(
      grepl(
        "  <h1 id=\"title toc-ignore\" class=\"toc-ignore\">minimal test</h1>",
        lines
      )
    )
  )
  expect_true(any(grepl(Sys.info()[8], lines)))
  expect_true(any(grepl(format(Sys.Date(), "%d %b %Y"), lines)))
  expect_true(any(grepl("</header>", lines)))
  expect_true(any(grepl("<body>", lines)))
  expect_true(any(grepl("render_toc", toc_lines)))
})

test_that(
  "Func warns as expected",
  expect_warning(
    access_rmd(test_file,
      title = "Already Exists", lan = "en",
      force = TRUE
    ),
    "'force' is TRUE. Overwriting filenm."
  )
)

# set the wd to test directory
with(globalenv(), {
  setwd(.old_wd)
})
