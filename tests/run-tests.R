library('testthat')
wd<-getwd() #working directory difers when running from RStudio or from Rscript
output_file<-file.path(wd, "tests/testthat/test-reports/rreport.xml")
file.exists(output_file) # TRUE
options(testthat.output_file = output_file)
dir.exists("tests/testthat") #TRUE
Sys.umask("777")
testthat::test_dir('tests/testthat', reporter = "junit")

