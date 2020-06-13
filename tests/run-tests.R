library('testthat')
wd<-getwd() #working directory difers when running from RStudio or from Rscript
print(wd)
output_file<-file.path(wd, "tests/testthat/test-reports/rreport.xml")
file.exists(output_file) # TRUE
options(testthat.output_file = output_file)
dir.exists("tests/testthat/test-reports/") #TRUE
#Sys.umask("113")
#Sys.umask("000")
testthat::test_dir('tests/testthat', reporter = "junit")

