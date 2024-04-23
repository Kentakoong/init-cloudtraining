#!/bin/bash

echo "Enter your desired username"
read name

adduser $name --disabled-password --gecos ""

usermod -aG sudo $name

su - $name
