# accessrmd
accessrmd is a package with functions intended to improve the accessibility of Rmarkdown documents. 


## Todo

### access_head

* Add YAML title as html title and h1
* Add expected CSS selectors to all header elements.
* additional required functionality: toc, toc_float, subtitle, lang.

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
