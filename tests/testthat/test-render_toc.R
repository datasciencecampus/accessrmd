# store the current wd in global scope and setwd to tempdir
with(globalenv(), {
  .old_wd <- setwd(tempdir())
})

# dependencies ------------------------------------------------------------
toc_file <- tempfile(fileext = ".Rmd")
file.create(toc_file)
writeLines("## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for 

When you click the **Knit** button a document will be generated that includes  

```{r cars}
summary(cars)
```

## Including Plots

### 3rd level header

#### 4th level header

You can also embed plots, for example:

```{r pressure, echo=FALSE}
plot(pressure)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent",
           con = toc_file)

# tests -------------------------------------------------------------------
test_that("Output is of stated class", {
  expect_true(class(render_toc(toc_file)) == "knit_asis") 
})

test_that("TOC has required id", {
  expect_true(grepl("<nav id=\"TOC\">", render_toc(toc_file)))
})

test_that("Errors on incorrect base level set", {
  expect_error(render_toc(toc_file, base_level = 3),
               "Cannot have negative header levels. Problematic header")
})


# set the wd to test directory
with(globalenv(), {
  setwd(.old_wd)
})