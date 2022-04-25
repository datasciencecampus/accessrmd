# store the current wd in global scope and setwd to tempdir
with(globalenv(), {
  .old_wd <- setwd(tempdir())
})
# create dependencies -----------------------------------------------------
# dirs
parent <- tempdir()
search <- paste(parent, "search_dir", sep = "/")
child <- paste(search, "child_dir", sep = "/")
# files
parent_file <- tempfile(fileext = ".Rmd")
search_file <- paste(search, basename(tempfile(fileext = ".Rmd")), sep = "/")
child_file <- paste(child, basename(tempfile(fileext = ".Rmd")), sep = "/")
# iterables
all_dirs <- c(parent, search, child)
all_files <- c(parent_file, search_file, child_file)
# create dirs
suppressWarnings(sapply(all_dirs, dir.create))
# create the files
sapply(all_files, file.create)

# tests -------------------------------------------------------------------

test_that("func returns expected length vec", {
  # test recurse TRUE
  expect_equal(length(retrieve_rmds(search)), 2)
  expect_equal(length(retrieve_rmds(child)), 1)
})

test_that("recurse = FALSE returns expected length vec", {
  expect_equal(length(retrieve_rmds(search, recurse = FALSE)), 1)
  expect_equal(length(retrieve_rmds(child, recurse = FALSE)), 1)
})

test_that("recurse = FALSE returns expected length vec", {
  expect_message(
    retrieve_rmds(search, to_txt = TRUE),
    "Relative paths written to"
  )
  expect_message(
    retrieve_rmds(child, to_txt = TRUE),
    "Relative paths written to"
  )
})

# teardown ----------------------------------------------------------------

unlink(c(all_files, all_dirs))

# set the wd to test directory
with(globalenv(), {
  setwd(.old_wd)
})
