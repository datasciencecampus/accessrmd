# store the current wd in global scope and setwd to tempdir
with(globalenv(), {
  .old_wd <- setwd(tempdir())
})
# create dependencies -----------------------------------------------------
test_rmd <- tempfile(fileext = ".Rmd")
file.create(test_rmd)
writeLines(
  "---
title: \"test\"
author: \"Richard Leyshon\"
date: \"02/07/2021\"
output: html_document
---

```
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a si <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes

```
summary(cars)
```

## Including Plots

You can also embed plots, for example:

```
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent",
  con = test_rmd
)

# expected output dir for inplace = FALSE
rmd_file <- basename(test_rmd)
# store dir loc
dir_loc <- paste0(str_remove(test_rmd, rmd_file), "accessrmd/")
# outfile saves to accessrmd dir
outfile <- paste0(dir_loc, rmd_file)

# test file for no YAML
no_yaml_rmd <- tempfile(fileext = ".Rmd")
file.create(no_yaml_rmd)
writeLines("```
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a <http://rmarkdown.rstudio.com>.",
  con = no_yaml_rmd
)


# test file for non-standard YAML

err_yaml_rmd <- tempfile(fileext = ".Rmd")
file.create(err_yaml_rmd)
writeLines("---
title: \"test\"
author: \"Richard Leyshon\"
date: \"02/07/2021\"
output: html_document
---
---

```
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown", con = err_yaml_rmd)

# test file for non-HTML output
non_html_rmd <- tempfile(fileext = ".Rmd")
file.create(non_html_rmd)
writeLines("---
title: \"test\"
author: \"Richard Leyshon\"
date: \"02/07/2021\"
output: pdf_document
---

```
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown", con = non_html_rmd)

# testfile for YAML-specified lang attribute
lang_rmd <- tempfile(fileext = ".Rmd")
file.create(lang_rmd)
writeLines("---
title: \"Untitled\"
author: \"Richard Leyshon\"
date: \"12/07/2021\"
output:
  html_document:
    lang: \"en\"
---

```
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown", con = lang_rmd)

# inline code testfile
inline_rmd <- tempfile(fileext = ".Rmd")
file.create(inline_rmd)
writeLines("
---
title: \"test_inline_code\"
author: \"Richard Leyshon\"
date: \"`r Sys.Date()`\"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown", con = inline_rmd)

# toc: true testfile
toc_file <- tempfile(fileext = ".Rmd")
file.create(toc_file)
writeLines(
  '---
title: "test_TOC"
author: "Richard Leyshon"
date: "09/08/2021"
output:
  html_document:
    toc: true
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
## R Markdown

## Including Plots
',
  con = toc_file
)

# tests -------------------------------------------------------------------

test_that("Expected behaviour on inplace = FALSE", {
  # check no warnings
  expect_message(access_head(test_rmd, lan = "en"), "Setting html lan to en")
  # check warnings for file exists
  expect_warning(access_head(test_rmd, lan = "en"), "already exists")
  # check file exists
  expect_true(file.exists(outfile))
})

test_that("Errors on non-standard Rmd", {
  expect_error(access_head(no_yaml_rmd, lan = "en"), "YAML header not found.")
  expect_error(
    access_head(err_yaml_rmd, lan = "en"),
    "Non standard YAML found."
  )
  expect_error(
    access_head(non_html_rmd, lan = "en"),
    "only works with html output."
  )
})


test_that("YAML lang is set to HTML attr", {
  expect_message(
    access_head(lang_rmd, inplace = TRUE),
    "Setting html lan to en"
  )
})

test_that("Behaves as expected with toc: true", {
  expect_message(
    access_head(toc_file, lan = "cy", inplace = TRUE),
    "Setting html lan to cy"
  )
})

# check test outputs ------------------------------------------------------
# check structure has written
lang_html <- readLines(lang_rmd)
lang <- lang_html[grep("lang=", lang_html)]
toc_lines <- readLines(toc_file)
test_that("YAML lang has been written as HTML", {
  expect_equal(lang, "<html lang=\"en\">")
})

test_that("Expected behaviour on inplace = TRUE", {
  expect_message(
    access_head(test_rmd, lan = "en", inplace = TRUE),
    "Setting html lan to en"
  )
  # YAML should be replaced from source file with html
  expect_false(all(grepl(pattern = "---", readLines(test_rmd))))
  # check no warnings
  expect_message(
    access_head(inline_rmd, lan = "en", inplace = TRUE),
    "Setting html lan to en"
  )
})

test_that("Inline code has been correctly written", {
  expect_true(grepl("r Sys.Date()", readLines(inline_rmd)[7]))
})

test_that("Toc code chunk has been inserted", {
  expect_true(grep(
    "render_toc\\(basename\\(knitr::current_input\\(\\)\\)\\)",
    toc_lines
  ) > 0)
})

# set the wd to test directory
with(globalenv(), {
  setwd(.old_wd)
})
