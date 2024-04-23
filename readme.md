# Scripts for initializing the server

Installation scripts has some steps that needs manual intervention. This script will help you to automate the process.

Do the scripts step-by-step. Don't proceed to the next step until the current step is completed.

## Login to the server as root, and clone the repository

```bash
git clone https://github.com/Kentakoong/init-cloudtraining.git
```

## Create User

Conda doesn't like to be installed as root. So, we need to create a user to install conda.

```bash
chmod +x create_user.sh
./create_user.sh
```

on finished, you as the administrator needs to  logout, and login to ssh into the server as the user created in the previous step.

```bash
ssh <created-username>@<server-ip>
```

## Update CUDA version

For pytorch to work properly, we need to install the correct version of CUDA. This script will help you to install the correct version of CUDA.

```bash
chmod +x cuda_upgrade.sh
./cuda_upgrade.sh
```

then it will log the versions available, select the version you want to install (usually the recommended version).

```bash
sudo apt install <version>
```

then reboot the server.

```bash
sudo reboot
```

then ssh into the server again.

```bash
ssh <created-username>@<server-ip>
```

## Install Conda and base packages

***Note: SSH into the server as the user created in the previous step first.***

```bash
chmod +x install_conda.sh
./install_conda.sh

source ~/.bashrc

```
