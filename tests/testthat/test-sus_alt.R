# store the current wd in global scope and setwd to tempdir
with(globalenv(), {.old_wd <- setwd(tempdir())})



# dependencies ------------------------------------------------------------

good_img <- tempfile(fileext = ".Rmd")
file.create(good_img)
writeLines("<img src='something' alt='something else'/>", con = good_img)

# tests -------------------------------------------------------------------

expect_message(sus_alt(good_img),
               "No images with equal src and alt values found.")





# set the wd to test directory
with(globalenv(), {setwd(.old_wd)})
