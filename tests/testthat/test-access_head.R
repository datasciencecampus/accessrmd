# store the current wd in global scope and setwd to tempdir
with(globalenv(), {.old_wd <- setwd(tempdir())})
# create dependencies -----------------------------------------------------


# set the wd to test directory
with(globalenv(), {setwd(.old_wd)})