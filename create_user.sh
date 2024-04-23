#!/bin/bash

echo "Enter your desired username"
read name

adduser machima --disabled-password --gecos ""

usermod -aG sudo machima

su - machima
