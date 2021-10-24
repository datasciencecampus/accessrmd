test_that("Tag is returned", {
  eg_title <- return_heading(txt = "Some title.", lvl = 1, class = "title")
  expect_true(class(eg_title) == "shiny.tag")
})

test_that("lvl results in correct heading tag",
          expect_true(grepl("h1", unlist(eg_title))[1])
          )
test_that("Correct class returned", 
          expect_true(grepl("title toc-ignore", unlist(eg_title))[2])
          )
