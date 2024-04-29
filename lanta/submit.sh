#!/bin/bash
#SBATCH -p gpu                      # Specify partition [Compute/Memory/GPU]
#SBATCH -N 1 -c 16                  # Specify number of nodes and processors per task
#SBATCH --gpus-per-task=4           # Specify the number of GPUs
#SBATCH --ntasks-per-node=1         # Specify tasks per node
#SBATCH -t 2:00:00                  # Specify maximum time limit (hour: minute: second)
#SBATCH -A 123123                 # Specify project name
#SBATCH -J jupyter_notebook         # Specify job name

module load Mamba/23.11.0-0      # Load the module that you want to use
conda activate tensorflow-2.12.1 # Activate your environment

port=$(shuf -i 6000-9999 -n 1)
USER=$(whoami)
node=$(hostname -s)

#jupyter notebookng instructions to the output file
echo -e "

    Jupyter server is running on: $(hostname)
    Job starts at: $(date)

    Copy/Paste the following command into your local terminal
    --------------------------------------------------------------------
    ssh -L $port:$node:$port $USER@lanta.nstda.or.th -i id_rsa
    --------------------------------------------------------------------

    Open a browser on your local machine with the following address
    --------------------------------------------------------------------
    http://localhost:${port}/?token=XXXXXXXX (see your token below)
    --------------------------------------------------------------------
    "

## start a cluster instance and launch jupyter server

unset XDG_RUNTIME_DIR
if [ "$SLURM_JOBTMP" != "" ]; then
    export XDG_RUNTIME_DIR=$SLURM_JOBTMP
fi

jupyter notebook --no-browser --port $port --notebook-dir=$(pwd) --ip=$node
