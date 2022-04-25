# store the current wd in global scope and setwd to tempdir
with(globalenv(), {
  .old_wd <- setwd(tempdir())
})

# deps --------------------------------------------------------------------

test_file <- tempfile(fileext = ".Rmd")
test_f <- basename(test_file)
test_dir <- str_remove(test_file, test_f)
out_file <- paste0(test_dir, "accessrmd_", test_f)
test_toc <- tempfile(fileext = ".Rmd")

# tests -------------------------------------------------------------------

test_that("Func behaves as expected on minimal parameters", {
  expect_message(
    access_rmd(test_file, title = "minimal test", lan = "en"),
    "Setting html lan to en"
  )
  expect_warning(
    access_rmd(test_file, title = "minimal test", lan = "en", force = TRUE),
    "Overwriting filenm."
  )

  expect_message(
    access_rmd(test_toc,
      title = "minimal test", lan = "en",
      toc = TRUE
    ),
    "Using toc_float YAML"
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
        "  <h1 class=\"title toc-ignore\">minimal test</h1>",
        lines
      )
    )
  )
  expect_true(any(grepl(Sys.info()[8], lines)))
  expect_true(any(grepl(format(Sys.Date(), "%d %b %Y"), lines)))
  expect_true(any(grepl("</header>", lines)))
  expect_true(any(grepl("<body>", lines)))
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

test_that(
  "Func handles filenm suffix as expected",
  expect_message(
    access_rmd(
      filenm = "forgotten_suffix",
      title = "I forgot to include a suffix", lan = "en"
    ),
    "Writing file to forgotten_suffix.Rmd"
  )
)

# teardown ----------------------------------------------------------------

temps <- c(test_file, test_toc, out_file, test_dir)
unlink(temps)
# files written to temp with access_rmd()
temp_rmds <- c("error_file.Rmd", "another_error.Rmd", "forgotten_suffix.Rmd")
unlink(temp_rmds)

# set the wd to test directory
with(globalenv(), {
  setwd(.old_wd)
})
