## Run all prioritization networks ##



##=====================================================================================##
## central nervous system
##=====================================================================================##

R -e "rmarkdown::render(here::here('Documents', 'Prioritization.Rmd'))" --args "central nervous system" "FALSE"
mv Documents/Prioritization.html Documents/Prioritization_Central_Nervous_System.html


##=====================================================================================##
## hemolymphoid system
##=====================================================================================##

R -e "rmarkdown::render(here::here('Documents', 'Prioritization.Rmd'))" --args "hemolymphoid system" "FALSE"
mv Documents/Prioritization.html Documents/Prioritization_hemolymphoid_system.html


##=====================================================================================##
## spleen
##=====================================================================================##

#R -e "rmarkdown::render(here::here('Documents', 'Prioritization.Rmd'))" --args "spleen" "FALSE"
#mv Documents/Prioritization.html Documents/Prioritization_spleen.html
