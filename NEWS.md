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
* Inserts accessible toc chunk if finds `toc: true` or `toc: yes`.
* Specifies character encoding as "utf-8" by default.


#### 'access_img()'

* Used to insert images into Rmarkdown documents that predictably renders alt
text (as opposed to markdown syntax which can be unreliable).
* Compatible with ggplot2 charts and pngs saved to disk.
* Currently does not support base R plots.
* "" alt text warning for decorative images only.

#### 'access_rmd()'

* Produce an accessible R markdown template with the specified metadata.
* TOC compatible.

#### 'find_alt_lim()' (Not exported)

* Finds html lang value with 'detect_html_lang()'.
* Checks if found lang value has an associated alt text length limit.
* Returns a found limit.

#### 'detect_html_lang()' (Not exported)

* Searches lines for lang values.
* Compare lang value to langs subtag registry.

#### 'handle_rmd_path()' (Not exported)

* Handler checks rmd path is valid.

#### 'find_all_imgs()' (Not exported)

* Helper func to find all images within an Rmd.

#### 'render_toc()'

* Finds all headers within an rmd & renders a standard toc
* Original author credit to Garrick Aiden-Buie
* [Original author's gist](https://gist.github.com/gadenbuie/c83e078bf8c81b035e32c3fc0cf04ee8)
* **Adaptations follow:**
* Avoid stripping digits from start of headers
* Include nav tag in toc output
* Avoid ID hashes showing up in nav links
* Strip curly braces if no spaces follow header, eg "## 2nd lvl header{.toc-ignore}"
* \{.toc-ignore\} compatibility.


#### 'retrieve_rmds()'

* Search for Rmds within a file structure, return relative paths.
* Output relative paths to txt file for posterity.

#### 'sus_alt()'

* Searches Rmd files for suspicious alt text.
* Warns on alt text set to placeholder text, including missing alt values.
* Warns on alt text equal to src attribute value.
* Warns on alt text exceeding a lang specific limit (see readme).


***

## To do

* toc newline or br tags not working. create test and resolve.
* figure alignment for 'access_img()'.
* correct header hierarchy.
* wrapper function that finds all images and replaces with access_img code.
* wrapper function that packages up broken links, sus alt text, long alt text,
header hierarchy, correct img HTML in one go.
* urlchecker - broken or permanent redirects.

**MVP**

* There are 2 Errors on the accessrmd test.html relating to WCAG 1.4.6: Contrast (enhanced)(Level AAA) with the red text in the install_github line and the
access_img line. For WCAG 1.4.6 The contrast ratio should be at least 7:1 for
normal text and 4.4:1 for large text.
* Microsoft Azure Cognitive Services free API: automate alt text generation for
images. Appears to only work with web-hosted images. Can local files be
uploaded?
* refactor: funcs for detect html lang, find all alts
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

### render_toc

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
