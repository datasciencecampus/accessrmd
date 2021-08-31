with(.GlobalEnv, {
  .old_wd <- setwd(tempdir())
})
# deps --------------------------------------------------------------------

html_file <- tempfile()
file.create(html_file)
writeLines(
  '<!DOCTYPE html>
  <html lang="en">
    <header>
    </header>
    <body>
    </body>
  </html>', con = html_file
)

yaml_file <- tempfile()
file.create(yaml_file)
writeLines(
  '---
title: "Untitled"
author: "Richard Leyshon"
date: "12/07/2021"
output:
  html_document:
    lang: "en"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown', con = yaml_file
)

# tests -------------------------------------------------------------------

test_that("Func returns found lang", {
  expect_identical(detect_html_lang(readLines(html_file)), "en")
  expect_identical(detect_html_lang(readLines(yaml_file)), "en")
})

with(.GlobalEnv, {
  setwd(.old_wd)
})
