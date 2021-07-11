# store the current wd in global scope and setwd to tempdir
with(globalenv(), {.old_wd <- setwd(tempdir())})










# set the wd to test directory
with(globalenv(), {setwd(.old_wd)})