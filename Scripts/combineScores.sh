#$ -N combineScores
#$ -hold_jid calcScores
#$ -l h_vmem=32G
#$ -l h_rt=48:00:00
#$ -e /exports/igmm/eddie/GenScotDepression/amelia/GS_episcores/job_logs
#$ -o /exports/igmm/eddie/GenScotDepression/amelia/GS_episcores/job_logs
#$ -m beas
#$ -M amelia.edmondson-stait@ed.ac.uk

. /etc/profile.d/modules.sh
module load igmm/apps/R/3.6.1

Rscript /exports/igmm/eddie/GenScotDepression/amelia/GS_episcores/Scripts/combineScores.R

