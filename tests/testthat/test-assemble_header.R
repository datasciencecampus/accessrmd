
# deps --------------------------------------------------------------------
eg_title <- "title: Habits"
eg_sub <- "subtitle: More about Habits"
eg_auth <- "author: John Doe"
eg_date <- "date: March 22, 2005"
eg_enc <- "UTF-8"

# run func ----------------------------------------------------------------

header1 <- assemble_header(
  title = eg_title, auth = eg_auth,
  doc_date = eg_date, enc = eg_enc
)[["children"]]
header2 <- assemble_header(
  title = eg_title, subtitle = eg_sub, auth = eg_auth,
  doc_date = eg_date, enc = eg_enc
)[["children"]]

# tests -------------------------------------------------------------------

test_that("Metas render correctly without subtitle", {
  # title is h1
  expect_equal(
    any(grepl("title toc-ignore", unlist(header1[[3]]))),
    any(grepl("h1", unlist(header1[[3]])))
  )
  # author is set
  expect_true(any(grepl("author: John Doe", unlist(header1[[4]][[1]]))))
  # date is set
  expect_true(any(grepl("date: March 22, 2005", unlist(header1[[4]][[2]]))))
})

test_that("Metas render correctly with subtitle", {
  # title is h1
  expect_equal(
    any(grepl("title toc-ignore", unlist(header2[[3]]))),
    any(grepl("h1", unlist(header2[[3]])))
  )
  # subtitle is p tag
  expect_equal(
    any(grepl(
      "subtitle: More about Habits",
      unlist(header2[[4]][[1]])
    )),
    any(grepl("^p$", unlist(header2[[4]][[1]])))
  )
  # author is p tag
  expect_equal(
    any(grepl("author: John Doe", unlist(header2[[4]][[2]]))),
    any(grepl("^p$", unlist(header2[[4]][[2]])))
  )
  # date is p tag
  expect_equal(
    any(grepl("date: March 22, 2005", unlist(header2[[4]][[3]]))),
    any(grepl("^p$", unlist(header2[[4]][[3]])))
  )
})

test_that(
  "Func errors on no title found",
  expect_error(
    assemble_header(title = character()),
    "No document title found. Please adjust the Rmarkdown."
  )
)
