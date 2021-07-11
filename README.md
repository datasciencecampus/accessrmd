# accessrmd

<!-- badges: start -->
[![R build status](https://github.com/datasciencecampus/accessrmd/workflows/R-CMD-check/badge.svg)](https://github.com/datasciencecampus/accessrmd/actions) ![Codecov test coverage](https://codecov.io/gh/datasciencecampus/accessrmd/branch/master/graph/badge.svg)
[![Codecov test coverage](https://codecov.io/gh/datasciencecampus/accessrmd/branch/main/graph/badge.svg)](https://codecov.io/gh/datasciencecampus/accessrmd?branch=main)
<!-- badges: end -->

accessrmd is a package with functions intended to improve the accessibility of Rmarkdown documents. 

View a [comparison of accessibility checks](https://datasciencecampus.github.io/accessrmd/)
before and after applying "accessrmd" functions.


> [Alt text length guidance](https://www.w3.org/WAI/GL/WCAG20/tests/test3.html)
"If the Alt text is greater than 100 characters (English) then it must be
shortened or the user must confirm that it is the shortest Alt text possible."

> Maximum Alt text Length  
eng	100  
ger	115  
kor	90  

> [placeholder alt text guidance](https://www.w3.org/WAI/GL/WCAG20/tests/test6.html)
Check each img element and compare its alt attribute value to the list of placeholder values.
alt attribute placeholder values are: 'nbsp', 'spacer' and src attribute value (filename).
