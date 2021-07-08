# accessrmd
accessrmd is a package with functions intended to improve the accessibility of Rmarkdown documents. 


## Todo

* wrapper function that finds all images and replaces with access_img code.
* wrapper function that packages up broken links, sus alt text, long alt text,
header hierarchy, correct img HTML in one go.
* There are 2 Errors on the accessrmd test.html relating to WCAG 1.4.6: Contrast (enhanced)(Level AAA) with the red text in the install_github line and the
access_img line. For WCAG 1.4.6 The contrast ratio should be at least 7:1 for
normal text and 4.4:1 for large text.
* correct header hierarchy
* broken links
* suspicious alt text feature request: alt text is identical to file name
* alt text exceeding a limit (find out which limit that is)

### access_head

* additional required functionality: toc, toc_float, subtitle, lang,
inline r code for date.

### access_img

* "" alt text should be warning for decorative images only.
* suspicious alt text feature request: alt text is identical to file name
* alt text exceeding a limit (find out which limit that is)


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





## Parked

### access_img

* Only works for ggplot charts. Need to include logic for base plots too.


## Tests

### access_head:

* grepl yaml bounds. Running on an Rmd containing the following url:
![Coloured stripes of chronologically ordered temperatures where they increase in red to show the warming global temperature](../images/_stripes_GLOBE---1850-2020-MO.png)
Results in non standard YAML bounds. Using regex to increase specificity but would make a good test case.
* Check on start / end lines for all cases.
* Reads correctly when no EOF marker included.

### access_img

* rmd knitting behaviour is producing saved intermediate chart images in the wd of the rmd. Once resolved, this would make a good test case.
