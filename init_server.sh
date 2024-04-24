#!/bin/bash

mkdir -p ~/miniconda3

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh

bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3

rm -rf ~/miniconda3/miniconda.sh

~/miniconda3/bin/conda init bash

source ~/.bashrc

conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia

pip install -r requirements.txt

jupyter notebook --generate-config

config_file=~/.jupyter/jupyter_notebook_config.py

configs="""
c.NotebookApp.ip = ''
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False
c.NotebookApp.quit_button = False
c.TerminalManager.cull_inactive_timeout = 0
c.TerminalManager.cull_idle_timeout = 0
"""

echo "$configs" >>$config_file
