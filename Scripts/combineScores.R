# Combine the episcores created in OSCA into one dataframe

setwd("/exports/eddie/scratch/s1211670")

library(stringr)
library(dplyr)

files <- list.files(path = "episcore_output/", pattern = ".profile")

scores <- lapply(files, function(file){

newName <- str_remove(file, ".profile")
read.table(paste0("episcore_output/", file), header = T) %>%
select(c(IID, SCORE)) %>%
rename({{newName}} := SCORE) 

})

head(scores[[1]])

df <- Reduce(function(x, y) merge(x, y, by="IID"), scores)
head(df)

write.csv(df, "episcore_output/GRM_corrected_episcores.csv", row.names = F, quote = F)

