#$ -N calcScores
#$ -l h_vmem=32G
#$ -l h_rt=48:00:00
#$ -e /exports/igmm/eddie/GenScotDepression/amelia/GS_episcores/job_logs
#$ -o /exports/igmm/eddie/GenScotDepression/amelia/GS_episcores/job_logs
#$ -m beas
#$ -M amelia.edmondson-stait@ed.ac.uk

cd /exports/eddie/scratch/$USER
mkdir episcore_output
mkdir episcore_weights
export PATH=$PATH:/exports/eddie/scratch/$USER/osca-0.46.1-linux-x86_64/

## Get weights of CpGs to make scores
# - Get list of weights from supplementary file in Gadd et al. 
# - Read this into R and make a file for each protein, with the CpGs and their weights.
# - The format of these files must be like `myblp.probe.blp` here: https://yanglab.westlake.edu.cn/software/osca/#PredictionAnalysis
# - The prefix of the name of each file is the protein. Suffix is ".probe.blp"

wget -O episcore_weights/elife-71802-supp1-v2.xlsx https://cdn.elifesciences.org/articles/71802/elife-71802-supp1-v2.xlsx

# location of this script will be wherever you cloned the github repo
Rscript /exports/igmm/eddie/GenScotDepression/amelia/GS_episcores/Scripts/makeWeightFiles.R

# Calculate scores for each protein
FILENAMES=$(ls episcore_weights)
SCORES=$(printf '%s\n' "${FILENAMES//.probe.blp/}")

for SCORE in $SCORES
do
    osca-0.46.1 --befile 20k_GRM_corrected/GS20K_GRMcorrected --score episcore_weights/"$SCORE".probe.blp --out episcore_output/"$SCORE"
done

