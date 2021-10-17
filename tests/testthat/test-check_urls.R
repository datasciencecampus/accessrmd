# store the current wd in global scope and setwd to tempdir
with(globalenv(), {
  .old_wd <- setwd(tempdir())
})
# deps --------------------------------------------------------------------
good_links <- tempfile(fileext = ".Rmd")
writeLines("text and a [markdown link](https://datasciencecampus.ons.gov.uk/)
an inline <a href=\"https://datasciencecampus.ons.gov.uk/\">html link</a>",
           con = good_links)

bad_links <- tempfile(fileext = ".Rmd")
writeLines(
"[empty url]()
a [problematic link](https://datasciencecampus.ons.gov.uk/broken/)
a <a href=\"https://datasciencecampus.ons.gov.uk/broken/\">broke html link</a>",
con = bad_links)

# tests -------------------------------------------------------------------

test_that("Func messages if no error found",
          expect_message(check_urls(good_links), "No links returned an error."))

test_that("Func warns if errors found",
          expect_warning(check_urls(bad_links),
          "Check lines for broken links:")
          )

# set the wd to test directory
with(globalenv(), {
  setwd(.old_wd)
})
