# Calculate protein episcores from [Gadd et al. 2022](https://elifesciences.org/articles/71802) in the GS 20k sample

- Use GRM corrected m-vals on the full 20k sample, located on the `GenScotDepression` datastore server (`smb://cmvm.datastore.ed.ac.uk/igmm/GenScotDepression`) here:`/exports/igmm/datastore/GenScotDepression/data/genscot/methylation/20k_GRM_corrected/`
- These are in [OSCA file format](https://yanglab.westlake.edu.cn/software/osca/#BODformat).
- Use [OSCA](https://yanglab.westlake.edu.cn/software/osca/#PredictionAnalysis) to calculate episcores for each protein.
- Combine the episcores into a dataframe, where each column is a protein episcore and each row is a GS participant.
- Use these scores in combination with covariates located here: `/exports/igmm/datastore/GenScotDepression/data/genscot/methylation/20k_GRM_corrected/covariates_xs.tsv`
- **Final file to use is located on datastore here: /exports/igmm/datastore/GenScotDepression/data/genscot/methylation/GRM_corrected_episcores/GRM_corrected_episcores.csv**

## Stage methylation data into scratch space from datastore
```
qlogin -q staging
mkdir /exports/eddie/scratch/$USER/20k_GRM_corrected
cp /exports/igmm/datastore/GenScotDepression/data/genscot/methylation/20k_GRM_corrected/GS20K_GRMcorrected* /exports/eddie/scratch/$USER/20k_GRM_corrected/
ls /exports/eddie/scratch/$USER/20k_GRM_corrected
exit
```

## Download OSCA
```
cd /exports/eddie/scratch/$USER
wget https://yanglab.westlake.edu.cn/software/osca/download/osca-0.46.1-linux-x86_64.zip
unzip osca-0.46.1-linux-x86_64.zip
export PATH=$PATH:/exports/eddie/scratch/s1211670/osca-0.46.1-linux-x86_64/
```

## Calculate scores (including downloading and formatting weights for the 100+ protein episcores)
```
qsub /exports/igmm/eddie/GenScotDepression/amelia/GS_episcores/Scripts/calcScores.sh

```

If you get an error similar to "osca: command not found" then you haven't added the excutable path to osca. Run something like: `export PATH=$PATH:/exports/eddie/scratch/s1211670/osca-0.46.1-linux-x86_64/`.

### Combine scores into one dataframe
```
qsub /exports/igmm/eddie/GenScotDepression/amelia/GS_episcores/Scripts/combineScores.sh

```

### Copy files to datastore to run downstream analysis

```
qlogin -q staging
cd /exports/igmm/datastore/GenScotDepression/data/genscot/methylation/
mkdir GRM_corrected_episcores
cp /exports/eddie/scratch/s1211670/episcore_output/GRM_corrected_episcores.csv /exports/igmm/datastore/GenScotDepression/data/genscot/methylation/GRM_corrected_episcores/GRM_corrected_episcores.csv
# add a readme with a link to this github repo
vi GRM_corrected_episcores/README.md
```

