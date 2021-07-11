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







# set the wd to test directory
with(globalenv(), {setwd(.old_wd)})