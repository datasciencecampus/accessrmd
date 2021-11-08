# accessrmd News

## Changelog

### Version: 0.0.0.9000

#### access_head

* Replaces basic YAML with accessible HTML header. Currently supports title, 
author and date.
* Error if lan is NULL.
* If lang found in YAML, use for html lang tag.
* Errors if no lang value attribute set.
* 'access_head()' works with inline code.
* Inserts floating toc YAML if finds `toc: true` or `toc: yes`.
* Specifies character encoding as "utf-8" by default.
* Uses 'assemble_header()'.
* Incompatible with specific types of html output, such as Flexdashboard,
ioslides, slidy and xaringan.
* Inline code syntax bug fix.
* Bug fix: Func can handle colons in title, date or author fields.
* 'inplace = FALSE' behaviour is now to append 'accessrmd_' to file name.
* Messages location of written file.
* Works with in-built themes. Accessibility issues with the cerulean and simplex
themes, therefore specifying those particular themes results in overriding with
a null theme and a warning to console.
* Sets highlight to null - the only option that does not result in accessibility
issues.

#### 'access_img()'

* Used to insert images into Rmarkdown documents that predictably renders alt
text (as opposed to markdown syntax which can be unreliable).
* Compatible with ggplot2 charts and pngs saved to disk.
* Currently does not support base R plots.
* "" alt text warning for decorative images only.
* Dimension parameter defaults set to 'NULL'.
* Includes 'css_class' & 'css_id' parameters.

#### 'access_rmd()'

* Produce an accessible R markdown template with the specified metadata.
* Inserts floating toc YAML if toc parameter is set to TRUE.
* Uses 'assemble_header()'.
* Messages location of written file.
* Works with in-built themes. Accessibility issues with the cerulean and simplex
themes, therefore specifying those particular themes results in overriding with
a null theme and a warning to console.
* Sets highlight to null - the only option that does not result in accessibility
issues.

#### 'assemble_header()' (Not exported)

* Takes document metadata as text and assembles html header.

#### 'find_alt_lim()' (Not exported)

* Finds html lang value with 'detect_html_lang()'.
* Checks if found lang value has an associated alt text length limit.
* Returns a found limit.

#### 'find_theme()' (Not exported)

* Finds YAML theme settings.
* Returns the found theme.
* Returns YAML syntax 'null' if no theme set.

#### 'check_compat()' (Not exported)

* Handler that stops if output is ioslides, xaringan, flexdashboard, slidy or 
not a html_document output.

#### 'check_urls()'

* Check urls in an Rmarkdown for errors.
* Returns line numbers of any urls that respond with an error.

#### 'detect_html_lang()' (Not exported)

* Searches lines for lang values.
* Compare lang value to langs subtag registry.

#### 'handle_rmd_path()' (Not exported)

* Handler checks rmd path is valid.

#### 'insert_yaml()' (Not exported)

* Handler assembles html document with inserted toc code.
* Messages on toc or toc_float.

#### 'find_all_imgs()' (Not exported)

* Helper func to find all images within an Rmd.

#### 'retrieve_rmds()'

* Search for Rmds within a file structure, return relative paths.
* Output relative paths to txt file for posterity.

#### 'return_heading()' (Not exported)

* Returns NULL if heading text is length zero.
* Returns required heading level and class if text exceeds length zero.

#### 'sus_alt()'

* Searches Rmd files for suspicious alt text.
* Warns on alt text set to placeholder text, including missing alt values.
* Warns on alt text equal to src attribute value.
* Warns on alt text exceeding a lang specific limit (see readme).

***

## To do

**MVP**
* Refactor 'insert_yaml()', inserted code chunk should contain a call to 
* correct header hierarchy.
* refactor: find all alts
* wrapper function that packages up broken links, sus alt text, long alt text,
header hierarchy, correct img HTML in one go.
* 'access_img()' leading to intermediate plots being saved on Windows.
Investigate tmpfile behaviour.

## Parked

* 'assemble_header()' handles errors gracefully. Consider refactoring and
handling cases where no date, no author, what about other potential metas like
abstract for academic papers?
* wrapper function that finds all images and replaces with 'access_img()' code.
* 'check_urls()' links like: <http://rmarkdown.rstudio.com> aren't found.
* Microsoft Azure Cognitive Services free API: automate alt text generation for
images. Appears to only work with web-hosted images. Can local files be
uploaded?
* .Rmds modified with 'access_head()' render with a warning about title
metadata. May wish to consider the alternative format [.rhtml](https://bookdown.org/yihui/rmarkdown-cookbook/html-hardcore.html).

### access_head

* additional required functionality: toc_float
* code_folding compatibility.

### access_rmd

* code folding compatibility
* toc_float functionality
* Include more extensive accessibility guidance within the template text.

### access_img

* intermediate plots occasionally appear in dir

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


### sus_alt

***

## Parked

### access_img

* Only works for ggplot charts. Need to include logic for base plots too.
