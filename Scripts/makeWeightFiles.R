## Get weights of CpGs to make scores
# - Get list of weights from supplementary file in Gadd et al. 
# - Read this into R and make a file for each protein, with the CpGs and their weights.
# - The format of these files must be like `myblp.probe.blp` here: https://yanglab.westlake.edu.cn/software/osca/#PredictionAnalysis
# - The prefix of the name of each file is the protein. Suffix is ".probe.blp"

setwd("/exports/eddie/scratch/s1211670")

library(xlsx)
library(dplyr)
library(tidyr)

supp <- read.xlsx("episcore_weights/elife-71802-supp1-v2.xlsx", sheetIndex = 6, startRow = 3, endRow = 10273, stringsAsFactors = F)

head(supp)

dfLong <- supp %>%
	unite("Episcore",  c("Gene.Name", "Panel")) %>%
	select(c("Episcore", "CpG.Site", "CpG.Coeficient")) %>%
	mutate("CpG.Coeficient" = round(CpG.Coeficient, 9))

length(unique(dfLong$Episcore))

dfList <- split(dfLong, f = dfLong$Episcore)

lapply(dfList[1:3], head)

# Check number of CpGs used to predict proteins:
sapply(dfList, nrow) %>% sort()

lapply(1:length(dfList), function(i){
write.table(select(dfList[[i]], -"Episcore"), paste0("episcore_weights/", names(dfList[i]) , ".probe.blp"), sep = "\t", row.names = F, col.names = F, quote = F)
	})

