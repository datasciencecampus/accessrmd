
# deps --------------------------------------------------------------------
html_head <- "
<header>
  <meta charset='utf-8'/>
  <title>Test Header</title>
  <h1 id='title toc-ignore'> test</h1>
  <h2 class='header_h2s'> Richard Leyshon</h2>
  <h2 class='header_h2s'> 02/07/2021</h2>
</header>
"


rmd_text <- "## some header
some p text
## Another header
### A H3 header
```{r}
# commented code
```
```{python}
# more commented code
```
"
lan <- "en"
lan1 <- "cy"

# tests -------------------------------------------------------------------

test_that("Lan messages behave", {
  expect_message(
    insert_yaml(
      toc = FALSE, header = html_head, text = rmd_text, lan = lan,
      theme = "default"
    ),
    "Setting html lan to en"
  )
  expect_message(
    insert_yaml(
      toc = FALSE, header = html_head, text = rmd_text, lan = lan1,
      theme = "default"
    ),
    "Setting html lan to cy"
  )
  expect_error(
    insert_yaml(
      toc = FALSE, header = html_head, text = rmd_text,
      theme = "default"
    ),
    '"lan" is missing'
  )
})

test_that("Output toc is correct", {
  expect_true(
    grepl(
      "      toc_float: true",
      insert_yaml(
        toc = TRUE,
        header = html_head,
        text = rmd_text,
        lan = lan,
        theme = "default"
      )
    )
  )
  expect_true(
    grepl(
      "output:\n    html_document:\n      toc: true\n      toc_float: true\n",
      insert_yaml(
        toc = TRUE,
        header = html_head,
        text = rmd_text,
        lan = lan,
        theme = "default"
      )
    )
  )
})

test_that("Func applies default theme only", {
  expect_true(grepl("theme: default", insert_yaml(
    toc = FALSE,
    header = html_head,
    text = rmd_text,
    lan = lan,
    theme = "default"
  )))
  expect_warning(
    insert_yaml(
      toc = FALSE,
      header = html_head,
      text = rmd_text,
      lan = lan,
      theme = "cerulean"
    ),
    "The cerulean theme has known accessibility errors and is
    not supported by this function."
  )
})
