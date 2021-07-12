# accessrmd News

## Changelog

### Version: 0.0.0.9000

#### access_head

* Replaces basic YAML with accessible HTML header. Currently supports title, 
author and date.
* Error if lan is NULL.


#### access_img

* Compatible with ggplot2 charts and pngs saved to disk.
* "" alt text warning for decorative images only.

#### handle_rmd_path

* Not exported. Handler checks rmd path is valid.

#### sus_alt

* Searches Rmd files for suspicious alt text.
* Warns on alt text set to placeholder text.
* Warns on alt text equal to src attribute value.


***

## To do

* wrapper function that finds all images and replaces with access_img code.
* wrapper function that packages up broken links, sus alt text, long alt text,
header hierarchy, correct img HTML in one go.
* There are 2 Errors on the accessrmd test.html relating to WCAG 1.4.6: Contrast (enhanced)(Level AAA) with the red text in the install_github line and the
access_img line. For WCAG 1.4.6 The contrast ratio should be at least 7:1 for
normal text and 4.4:1 for large text.
* correct header hierarchy
* broken links
* alt text exceeding a lang specific limit (see readme).
* search for Rmds within a file structure and copy into a single dir.
* access_head errors on no lang value attribute set.

### access_head

* additional required functionality: toc, toc_float, subtitle, lang,
inline r code for date.
* if lang found in YAML, use for html lang tag.


### access_img

* alt text exceeding a limit (find out which limit that is)
* intermediate plots occasionally appear in dir


## Tests

### access_head:

* grepl yaml bounds. Running on an Rmd containing the following url:
![Coloured stripes of chronologically ordered temperatures where they increase in red to show the warming global temperature](../images/_stripes_GLOBE---1850-2020-MO.png)
Results in non standard YAML bounds. Using regex to increase specificity but would make a good test case.
* Check on start / end lines for all cases.
* Reads correctly when no EOF marker included.

### access_img

* rmd knitting behaviour is producing saved intermediate chart images in the wd of the rmd. Once resolved, this would make a good test case.

### sus_alt

* More complex test cases including mix of acceptable html format and placeholder text.


## Parked

### access_img

* Only works for ggplot charts. Need to include logic for base plots too.
