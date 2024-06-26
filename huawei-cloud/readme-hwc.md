# Scripts for initializing the server

Installation scripts has some steps that needs manual intervention. This script will help you to automate the process.

Do the scripts step-by-step. Don't proceed to the next step until the current step is completed.

## Login to the server as root, and clone the repository

```bash
git clone https://github.com/Kentakoong/init-cloudtraining.git
```

## Create User

Conda doesn't like to be installed as root. So, we need to create a user to install conda.

SSH in as root, and create a user.

```bash
ssh root@<server-ip>
```

```bash
adduser <created-username> --gecos ""

usermod -aG sudo <created-username>
```

then set the password for the user.

```bash

su - <created-username>

```

On finished, you as the administrator quit the ssh session and access the server with the created user via Visual Studio Code.

```bash
ssh <created-username>@<server-ip>
```

## Update CUDA version

***Note: SSH into the server as the user created in the previous step first.***

```bash
cd init-cloudtraining/huawei-cloud
```

For PyTorch to work properly, we need to install the correct version of CUDA. This script will help you to install the correct version of CUDA.

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

```bash
chmod +x install_conda.sh
./install_conda.sh
```

then source the bash, to make the conda command available.

```bash
source ~/.bashrc
```

then install the base packages and initialize juptyer notebook.

```bash
chmod +x install_packages.sh
./install_packages.sh
```