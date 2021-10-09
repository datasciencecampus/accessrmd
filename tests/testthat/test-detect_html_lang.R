with(globalenv(), {
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
  </html>',
  con = html_file
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

## R Markdown',
  con = yaml_file
)

no_lang <- tempfile()
file.create(no_lang)
writeLines(
  '---
title: "Untitled"
author: "Richard Leyshon"
date: "12/07/2021"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown',
  con = no_lang
)

# invalid lang value
invalid_lang <- tempfile()
file.create(invalid_lang)
writeLines(
  '---
title: "Untitled"
author: "Richard Leyshon"
date: "12/07/2021"
output:
  html_document:
    lang: "em"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown',
  con = invalid_lang
)


# tests -------------------------------------------------------------------

test_that("Func returns found lang", {
  expect_identical(detect_html_lang(readLines(html_file)), "en")
  expect_identical(detect_html_lang(readLines(yaml_file)), "en")
})

test_that("Func errors as expected", {
  expect_error(detect_html_lang(readLines(no_lang)), "No lang value found.")
  expect_error(
    detect_html_lang(readLines(invalid_lang)),
    "lang value is invalid. Please specify a valid lang value."
  )
})

with(globalenv(), {
  setwd(.old_wd)
})
