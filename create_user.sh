#!/bin/bash

echo "Enter your desired username"
read name

adduser $name --gecos 

usermod -aG sudo $name

su - $name
