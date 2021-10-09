# store the current wd in global scope and setwd to tempdir
with(globalenv(), {
  .old_wd <- setwd(tempdir())
})

# dependencies ------------------------------------------------------------
toc_file <- tempfile(fileext = ".Rmd")
file.create(toc_file)
writeLines('---
title: "tocfile"
author: "Richard Leyshon"
date: "19/09/2021"
output: html_document
---

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for 

When you click the **Knit** button a document will be generated that includes  

```{r cars}
summary(cars)
```

## Including Plots

### 3rd level header

#### 4th level header

#### ignore me please{.toc-ignore}

#### tabset test{.tabset}

#### id test{#someID}

You can also embed plots, for example:

```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent',
  con = toc_file
)

test_base <- tempfile(fileext = ".Rmd")
file.create(test_base)
writeLines('---
title: "testbase"
author: "Richard Leyshon"
date: "19/09/2021"
output: html_document
---

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for 

When you click the **Knit** button a document will be generated that includes',
  con = test_base
)

multiple_chunks <- tempfile(fileext = ".Rmd")
file.create(multiple_chunks)
writeLines('---
title: "multichunks"
author: "Richard Leyshon"
date: "09/10/2021"
output: html_document
---

## R Markdown

```{r, setup}
# Some commented code should not appear in toc
## Neither should this

```
## Reticulate

```{python, reticulate}
# Lets check this too

```', con = multiple_chunks)

# tests -------------------------------------------------------------------

test_that("Output is of stated class", {
  expect_true(class(render_toc(toc_file)) == "knit_asis")
})

test_that("TOC has required id", {
  expect_true(grepl("<nav id=\"TOC\">", render_toc(toc_file)))
})

test_that("toc_depth excludes correctly", {
  # check for exclusions
  expect_false(grepl(
    "4th level header",
    render_toc(toc_file, toc_depth = 2)[1]
  ))
  expect_false(grepl(
    "3rd level header",
    render_toc(toc_file, toc_depth = 1)[1]
  ))
  expect_false(grepl(
    "ignore me please",
    render_toc(toc_file)[1]
  ))
  # check for inclusion
  expect_true(grepl(
    "3rd level header",
    render_toc(toc_file, toc_depth = 2)[1]
  ))
  expect_true(grepl(
    "Including Plots",
    render_toc(toc_file, toc_depth = 1)[1]
  ))
})

test_that("func returns empty toc if base level evaluates to 0", {
  expect_true(grepl(
    "<nav id=\"TOC\">\n\n</nav>",
    render_toc(test_base, base_level = 1)
  ))
})

test_that("Errors on incorrect base level set", {
  expect_error(
    render_toc(toc_file, base_level = 3),
    "Cannot have negative header levels. Problematic header"
  )
})

test_that("No # or {content} appear in toc link text", {
  expect_false(grepl("\\[#", render_toc(toc_file)))
  expect_false(grepl("\\{\\.|#.+\\}(\\s+)?$", render_toc(toc_file)))
})

test_that("Commented code in code chunks are excluded from toc", {
  expect_false(grepl("Some commented code should not appear in toc",
    "commented code",
    ignore.case = TRUE, useBytes = TRUE
  ))
  expect_false(grepl(
    "Neither should this",
    render_toc(multiple_chunks)
  ))
  expect_false(grepl(
    "Lets check this too",
    render_toc(multiple_chunks)
  ))
})

# set the wd to test directory
with(globalenv(), {
  setwd(.old_wd)
})
