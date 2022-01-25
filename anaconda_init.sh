eval "$(~/Applications/anaconda3/bin/conda shell.bash hook)"
conda init
conda config --set auto_activate_base false

## create anaconda envs
echo SETTING UP CONDA ENVS
for env in ./conda_envs/*.yml
do
  conda env create -f $env
done