## Run all batch correction combinations ##



##=====================================================================================##
## No batch correction, no normalization
##=====================================================================================##

R -e "rmarkdown::render(here::here('Documents', 'Mapping_EAE_traits.Rmd'))" --args "FALSE" "FALSE" "FALSE"
mv Documents/Mapping_EAE_traits.html Documents/Zeros_included_no-batch_no-norm.html


##=====================================================================================##
## B6 batch correction, no normalization
##=====================================================================================##

R -e "rmarkdown::render(here::here('Documents', 'Mapping_EAE_traits.Rmd'))" --args "TRUE" "FALSE" "FALSE"
mv Documents/Mapping_EAE_traits.html Documents/Zeros_included_B6-batch_no-norm.html


##=====================================================================================##
## covariate batch correction, no normalization
##=====================================================================================##

R -e "rmarkdown::render(here::here('Documents', 'Mapping_EAE_traits.Rmd'))" --args "FALSE" "TRUE" "FALSE"
mv Documents/Mapping_EAE_traits.html Documents/Zeros_included_covar-batch_no-norm.html

##=====================================================================================##
## No batch correction, rank Z normalization
##=====================================================================================##

R -e "rmarkdown::render(here::here('Documents', 'Mapping_EAE_traits.Rmd'))" --args "FALSE" "FALSE" "TRUE"
mv Documents/Mapping_EAE_traits.html Documents/Zeros_included_no-batch_rank-norm.html


##=====================================================================================##
## B6 batch correction, rank Z normalization
##=====================================================================================##

R -e "rmarkdown::render(here::here('Documents', 'Mapping_EAE_traits.Rmd'))" --args "TRUE" "FALSE" "TRUE"
mv Documents/Mapping_EAE_traits.html Documents/Zeros_included_B6-batch_rank-norm.html


##=====================================================================================##
## covar correction, rank Z normalization
##=====================================================================================##

R -e "rmarkdown::render(here::here('Documents', 'Mapping_EAE_traits.Rmd'))" --args "FALSE" "TRUE" "TRUE"
mv Documents/Mapping_EAE_traits.html Documents/Zeros_included_covar-batch_rank-norm.html

##=====================================================================================##
## run analysis comparison
##=====================================================================================##

R -e "rmarkdown::render(here::here('Documents', 'Compare_Analyses.Rmd'))"

