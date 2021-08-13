# accessrmd News

## Changelog

### Version: 0.0.0.9000

#### access_head

* Replaces basic YAML with accessible HTML header. Currently supports title, 
author and date.
* Error if lan is NULL.
* if lang found in YAML, use for html lang tag.
* Errors if no lang value attribute set.
* 'access_head()' works with inline code.


#### 'access_img()'

* Compatible with ggplot2 charts and pngs saved to disk.
* "" alt text warning for decorative images only.

#### 'handle_rmd_path()' (Not exported)

* Handler checks rmd path is valid.

#### 'find_all_imgs()' (Not exported)

* Helper func to find all images within an Rmd.

#### 'render_toc()'

* Finds all headers within an rmd & renders a standard toc
* Original author credit to Garrick Aiden-Buie
* [Original author's gist](https://gist.github.com/gadenbuie/c83e078bf8c81b035e32c3fc0cf04ee8)
* Adapted to avoid stripping digits from start of headers
* Adapted to include nav tag in toc output

#### 'retrieve_rmds()'

* Search for Rmds within a file structure, return relative paths.
* Output relative paths to txt file for posterity.

#### 'sus_alt()'

* Searches Rmd files for suspicious alt text.
* Warns on alt text set to placeholder text, including missing alt values.
* Warns on alt text equal to src attribute value.

***

## To do

* refactor: funcs for detect html lang, find all alts
* correct header hierarchy
* alt text exceeding a lang specific limit (see readme).
* wrapper function that finds all images and replaces with access_img code.
* wrapper function that packages up broken links, sus alt text, long alt text,
header hierarchy, correct img HTML in one go.
* There are 2 Errors on the accessrmd test.html relating to WCAG 1.4.6: Contrast (enhanced)(Level AAA) with the red text in the install_github line and the
access_img line. For WCAG 1.4.6 The contrast ratio should be at least 7:1 for
normal text and 4.4:1 for large text.
* Microsoft Azure Cognitive Services free API: automate alt text generation for
images. Appears to only work with web-hosted images. Can local files be
uploaded?

### access_head

* additional required functionality: toc, toc_float, subtitle, lang,
inline r code for date.
* module for find_lang and use as default behaviour for lan argument.

### access_img

* alt text exceeding a limit
* intermediate plots occasionally appear in dir

### render_toc

* {.toc-ignore} compatability required.
* toc-float support if possible.

***

## Tests

### access_head:

* grepl yaml bounds. Running on an Rmd containing the following url:
![Coloured stripes of chronologically ordered temperatures where they increase in red to show the warming global temperature](../images/_stripes_GLOBE---1850-2020-MO.png)
Results in non standard YAML bounds. Using regex to increase specificity but would make a good test case.
* Check on start / end lines for all cases.
* Reads correctly when no EOF marker included.

### access_img

* rmd knitting behaviour is producing saved intermediate chart images in the wd of the rmd. Once resolved, this would make a good test case.

### render_toc

* special header slug "\\{#.+\\}(\\s+)?$" - {.classes} and {#IDs} are showing
up in toc links.
* preceding hashes on any header with an {#ID} are showing up in toc links

### sus_alt

***

## Parked

### access_img

* Only works for ggplot charts. Need to include logic for base plots too.
