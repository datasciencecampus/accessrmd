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
dir_loc <- str_remove(test_rmd, rmd_file)
# outfile appends accessrmd to filenm
outfile <- paste0(dir_loc, "accessrmd_", rmd_file)
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
date: \"`r format(Sys.Date(), '%d %b %y')`\"
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
# create test files for config chunk specification
hashed_config <- tempfile(fileext = ".Rmd")
file.create(hashed_config)
writeLines('---
title: "Hashed config"
author: "Richard Leyshon"
date: "29/11/2021"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
#knitr::opts_chunk$set(comment = "")
```

## R Markdown', con = hashed_config)

no_setup <- tempfile(fileext = ".Rmd")
file.create(no_setup)
writeLines('---
title: "subitle testing"
author: "Richard Leyshon"
date: "30/11/2021"
output: html_document
---

```{r}
knitr::opts_chunk$set(echo = TRUE)
#knitr::opts_chunk$set(comment = "")
```

## R Markdown', con = no_setup)

no_comment <- tempfile(fileext = ".Rmd")
file.create(no_comment)
writeLines('---
title: "Hashed config"
author: "Richard Leyshon"
date: "29/11/2021"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown', con = no_comment)

# tests -------------------------------------------------------------------
test_that("Expected behaviour on inplace = FALSE", {
  # check no warnings
  expect_message(access_head(test_rmd, lan = "en"), "Setting html lan to en")
  expect_message(
    access_head(test_rmd, lan = "en"),
    "Writing file to"
  )
  expect_true(file.exists(outfile))
})
test_that(
  "Errors on non-standard Rmd",
  expect_error(
    access_head(no_yaml_rmd, lan = "en"), "YAML header not found."
  )
)
test_that("YAML lang is set to HTML attr", {
  expect_message(
    access_head(lang_rmd, inplace = TRUE),
    "Setting html lan to en"
  )
})
# move to insert_toc tests
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
})
test_that("Inline code has been correctly written", {
  expect_true(any(grepl(
    "`r format\\(Sys.Date\\(\\), '%d %b %y'\\)`",
    readLines(inline_rmd)
  )))
})

test_that("Config chunk gets correct conditional treatment", {
  expect_message(access_head(hashed_config, lan = "en", inplace = TRUE),
                 "Activating comment config.")
  adj_hashed_config <- readLines(hashed_config)
  expect_false(grepl("^#",
                     adj_hashed_config[grep(
                       'set\\(comment = \"\"\\)', adj_hashed_config)]
                     ))
  expect_message(access_head(no_setup, lan = "en", inplace = TRUE),
                 "Inserting config chunk.")
  adj_no_setup <- readLines(no_setup)
  expect_true(any(grepl("```\\{r setup, include=FALSE\\}", adj_no_setup)) &
                any(
                  grepl("knitr::opts_chunk\\$set\\(comment = \"\"\\)",
                        adj_no_setup))
              )
  expect_message(access_head(no_comment, lan = "en", inplace = TRUE),
                 "Specifying config comment.")
  adj_no_comment <- readLines(no_comment)
  expect_true(any(grepl("knitr::opts_chunk\\$set\\(comment = \"\"\\)",
                        adj_no_comment)))
  })

test_that("Func errors on recursive use", 
          expect_error(expect_message(
            access_head(test_rmd, lan = "en", inplace = TRUE),
            "Have you previously run 'access_head()' on this file?")
            )
)

# set the wd to test directory
with(globalenv(), {
  setwd(.old_wd)
})
