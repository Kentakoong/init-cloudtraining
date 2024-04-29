#!/bin/bash

# ------------------------------ Jupyter Script ------------------------------ #

jupyter='''
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
'''

# -------------------------- Select Option Function -------------------------- #

function select_option() {
    local options=("$@")
    local selection

    select opt in "${options[@]}" "Quit"; do
        case $opt in
        "Quit")
            echo "Exiting..."
            return 1
            ;;
        *)
            if [[ " ${options[*]} " =~ " ${opt} " ]]; then
                selection="$opt"
                break
            else
                echo "Invalid option $REPLY"
            fi
            ;;
        esac
    done

    echo "$selection"
}

tput clear

processors=("1 (128c)" "1/2 (64c)" "1/4 (32c)" "1/8 (16c)")
echo "Please select one of the following options:"
PROCESSORS_TYPE=$(select_option "${processors[@]}")

if [ "$PROCESSORS_TYPE" == "${processors[0]}" ]; then
    PROCESSORS_TYPE=128
elif [ "$PROCESSORS_TYPE" == "${processors[1]}" ]; then
    PROCESSORS_TYPE=64
elif [ "$PROCESSORS_TYPE" == "${processors[2]}" ]; then
    PROCESSORS_TYPE=32
elif [ "$PROCESSORS_TYPE" == "${processors[3]}" ]; then
    PROCESSORS_TYPE=16
fi

tput clear
echo "Processors Type: $PROCESSORS_TYPE"
echo ""

gpus=("1" "2" "3" "4")
echo "Please select the number of GPUs:"
gpus=$(select_option "${gpus[@]}")

tput clear
echo "Processors Type: $PROCESSORS_TYPE"
echo "Number of GPUs: $gpus"
echo ""

echo "Please enter the maximum time limit (hour: minute: second):"
read -p "Time limit: " time_limit

IFS=':' read -r hours minutes seconds <<<"$time_limit"
total_seconds=$((hours * 3600 + minutes * 60 + seconds))

threshold_hours=120
threshold_seconds=$((threshold_hours * 3600))

tput clear

if [ $total_seconds -gt $threshold_seconds ]; then
    echo "The input time exceeds $threshold_hours hours, setting to default time limit. (2:00:00)"
    echo ""
    time_limit="2:00:00"
elif [ -z "$time_limit" ]; then
    echo "Time limit not specified, setting to default time limit. (2:00:00)"
    echo ""
    time_limit="2:00:00"
elif [[ ! $time_limit =~ ^[0-9]{1,2}:[0-9]{2}:[0-9]{2}$ ]]; then
    echo "Invalid time format, setting to default time limit. (2:00:00)"
    echo ""
    time_limit="2:00:00"
fi

echo "Processors Type: $PROCESSORS_TYPE"
echo "Number of GPUs: $gpus"
echo "Time limit: $time_limit"

myquota

read -p "Project Name (check myquota for project names place ltxxxxxx): " project_name

if [ -z "$project_name" ]; then
    echo "Project name cannot be empty. Exiting..."
    exit 1
fi

if [ ${#PROCESSORS_TYPE} -eq 3 ]; then
    SPACES_PROCESSORS="               "
else
    SPACES_PROCESSORS="                "
fi

params="""#!/bin/bash
#SBATCH -p gpu                      # Specify partition [Compute/Memory/GPU]
#SBATCH -N 1 -c $PROCESSORS_TYPE $SPACES_PROCESSORS # Specify number of nodes and processors per task
#SBATCH --gpus-per-task=$gpus           # Specify the number of GPUs
#SBATCH --ntasks-per-node=1         # Specify tasks per node
#SBATCH -t $time_limit                  # Specify maximum time limit (hour: minute: second)
#SBATCH -A $project_name                 # Specify project name
#SBATCH -J jupyter_notebook         # Specify job name
"""

cat <<EOF
$params 
EOF

read -p "Press enter to confirm the parameters... "

tput clear

module load Mamba/23.11.0-0 # Load the module that you want to use

conda env list

read -p "Please enter the name of the conda environment: " conda_env

if [ -z "$conda_env" ]; then
    echo "Conda environment is empty, using pytorch-2.2.2"
    exit 1
fi

read -p "Press enter to copy the following parameters to submit.sh... "

cat <<EOF >./submit.sh
$params 
EOF

cat <<EOF >>./submit.sh
module load Mamba/23.11.0-0
conda activate $conda_env
EOF

cat <<EOF >>./submit.sh
$jupyter
EOF

tput clear

echo "Parameters copied to submit.sh"

cat ./submit.sh

read -p "Confirm the file, then press enter to submit the job... "

sbatch ./submit.sh