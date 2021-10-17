
# deps --------------------------------------------------------------------

xar_yaml <- '---
title: "Presentation Ninja"
subtitle: "⚔<br/>with xaringan"
author: "Yihui Xie"
institute: "RStudio, PBC"
date: "2016/12/12 (updated: `r Sys.Date()`)"
output:
  xaringan::moon_reader:
  
    lib_dir: libs
    nature:
      highlightStyle: github
      highlightLines: true
      countIncrementalSlides: false
---'

io_yaml <- '---
title: "Untitled"
author: "rich leyshon"
date: "15/10/2021"
output: ioslides_presentation
---'

flex_yaml <- '---
title: "Untitled"
output:
  flexdashboard::flex_dashboard:
    orientation: columns
    vertical_layout: fill
---'

slidy_yaml <- '---
title: "Untitled"
author: "rich leyshon"
date: "15/10/2021"
output: slidy_presentation
---'

non_html_yaml <- "---
title: \"test\"
author: \"Richard Leyshon\"
date: \"02/07/2021\"
output: pdf_document
---"
html_yaml <- c(
  "---",
  'title: "Testing"',
  'author: "Rich Leyshon"',
  'date: "15/10/2021"',
  "output: html_document"
)

# tests -------------------------------------------------------------------

test_that("func errors as expected", {
  expect_error(
    check_compat(non_html_yaml),
    "only works with html output."
  )
  expect_error(
    check_compat(xar_yaml),
    "xaringan output is not compatible."
  )
  expect_error(
    check_compat(io_yaml),
    "ioslides output is not compatible."
  )
  expect_error(
    check_compat(flex_yaml),
    "flexdashboard output is not compatible."
  )
  expect_error(
    check_compat(slidy_yaml),
    "slidy output is not compatible."
  )
})
