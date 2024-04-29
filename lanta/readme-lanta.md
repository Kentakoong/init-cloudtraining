# Guides and Scripts for LANTA

## Scripts for initalizing Jupyter Server

This script will help you to install Jupyter Server on your server.

```bash
ssh <name>@lanta.nstda.or.th
```

## Initializing the submit script

***Note: SSH into the server as the user created in the previous step first.***

```bash
mkdir scripts
cd scripts

wget https://github.com/Kentakoong/init-cloudtraining/releases/download/LANTA-1.0.0/setup.sh

chmod 700 setup.sh

./setup.sh
```

Then follow the interactive prompt to setup the Jupyter Server.

## Inspecting the Jupyter Server when script finishes

After the script finishes, check your queue to see if the script has been submitted.

```bash
myqueue
```

If the script has been submitted, check your current directory with `ls` to see the slurm file.

```bash
ls

cat slurm-xxxxxx.out
```

The slurm file will contain the URL to access the Jupyter Server.

## Accessing the Jupyter Server

To access the Jupyter Server, copy the URL from the slurm file and paste it into your browser.

```bash
ssh -L <PORT>:<HOST>:<PORT> <username>@lanta.nstda.or.th -i <path-to-private-key>
```

Then open your browser and go to `localhost:<PORT>`  
or copy the URL with the token from the slurm file and paste it into your browser.

## Stopping the Jupyter Server

To stop the Jupyter Server, go to the terminal where you ran the batch script.

Run the following command to see the job ID.

```bash
myqueue
```

Then run the following command to stop the Jupyter Server.

```bash
scancel <job-id>
```

## Basic Slurm Commands

### s* commands

`sbatch` - Submit a batch script to the queue.
`scancel` - Cancel a job.
`sbalance` - Check the balance of the queue (GPU hours).

### my* commands

`myqueue` - Check the queue.
`myquota` - Check your quota (Disk usage, projects).
