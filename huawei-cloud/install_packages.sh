#!/bin/bash

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
