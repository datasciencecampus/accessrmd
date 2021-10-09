with(globalenv(), {
  .old_wd <- setwd(tempdir())
})


# deps --------------------------------------------------------------------

en_file <- tempfile(fileext = ".Rmd")
file.create(en_file)
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
  con = en_file
)

de_file <- tempfile(fileext = ".Rmd")
file.create(de_file)
writeLines(
  '---
title: "Untitled"
author: "Richard Leyshon"
date: "12/07/2021"
output:
  html_document:
    lang: "de"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown',
  con = de_file
)

ko_file <- tempfile(fileext = ".Rmd")
file.create(ko_file)
writeLines(
  '---
title: "Untitled"
author: "Richard Leyshon"
date: "12/07/2021"
output:
  html_document:
    lang: "ko"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown',
  con = ko_file
)

us_file <- tempfile(fileext = ".Rmd")
file.create(us_file)
writeLines(
  '---
title: "Untitled"
author: "Richard Leyshon"
date: "12/07/2021"
output:
  html_document:
    lang: "en-us"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown',
  con = us_file
)

cymru_file <- tempfile(fileext = ".Rmd")
file.create(cymru_file)
writeLines(
  '---
title: "test"
author: "Richard Leyshon"
date: "02/07/2021"
output:
  html_document:
    lang: "cy"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown',
  con = cymru_file
)

# tests -------------------------------------------------------------------

test_that("Func returns correct limits", {
  expect_identical(find_alt_lim(handle_rmd_path(en_file)), 100)
  expect_identical(find_alt_lim(handle_rmd_path(de_file)), 115)
  expect_identical(find_alt_lim(handle_rmd_path(ko_file)), 90)
  expect_identical(find_alt_lim(handle_rmd_path(us_file)), 100)
})

test_that("Func returns NULL if no limit found", {
  expect_null(find_alt_lim(handle_rmd_path(cymru_file)))
})

with(globalenv(), {
  setwd(.old_wd)
})
