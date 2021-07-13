# store the current wd in global scope and setwd to tempdir
with(globalenv(), {.old_wd <- setwd(tempdir())})
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

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a si <http://rmarkdown.rstudio.com>.

When you click the **Knit** button a document will be generated that includes

```{r cars}
summary(cars)
```

## Including Plots

You can also embed plots, for example:

```{r pressure, echo=FALSE}
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
noYAML_rmd <- tempfile(fileext = ".Rmd")
file.create(noYAML_rmd)
writeLines("```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a <http://rmarkdown.rstudio.com>.",
           con = noYAML_rmd
  
)


# test file for non-standard YAML

errYAML_rmd <- tempfile(fileext = ".Rmd")
file.create(errYAML_rmd)
writeLines("---
title: \"test\"
author: \"Richard Leyshon\"
date: \"02/07/2021\"
output: html_document
---
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown", con = errYAML_rmd)

# test file for non-HTML output
non_html_rmd <- tempfile(fileext = ".Rmd")
file.create(non_html_rmd)
writeLines("---
title: \"test\"
author: \"Richard Leyshon\"
date: \"02/07/2021\"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown", con = non_html_rmd)


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

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown", con = lang_rmd)

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
  expect_error(access_head(noYAML_rmd, lan = "en"), "YAML header not found.")
  expect_error(access_head(errYAML_rmd, lan = "en"), "Non standard YAML found.")
  expect_error(access_head(non_html_rmd, lan = "en"),
               "only works with html output.")
})

test_that("Errors if no html lang attribute set", {
  expect_error(access_head(test_rmd),
               'No value provided to "lan" or lang value found in YAML.')
})

test_that("YAML lang is set to HTML attr", {
  expect_message(access_head(lang_rmd, inplace = TRUE),
                 "YAML lang found. Setting HTML lang as en")
})

test_that("Expected behaviour on inplace = TRUE", {
  expect_message(access_head(test_rmd, lan = "en", inplace = TRUE),
                 "Setting html lan to en")
  # YAML should be replaced from source file with html
  expect_false(all(grepl(pattern = "---", readLines(test_rmd))))
})

# set the wd to test directory
with(globalenv(), {setwd(.old_wd)})