#!/bin/bash

inform () {
  echo ''
  echo " *** $1 *** "
  echo ''
}

#Install depedencies
inform "Installing depedencies"
sudo apt-get -y install git yt-dlp racket && raco pkg install html-parsing

#Clone lambda-dl repo
inform "Cloning repo"
git clone https://github.com/jtsxtn/lambda-dl.git

#Build the project
inform "Building project"
cd lambda-dl
raco exe -o lambda-dl main.rkt

#Setting path
inform "Setting path"
echo "PATH=$PATH:$(pwd)" | sudo tee -a ~/.profile

inform "$(tput setaf 2) Installation completed $(tput setaf 7)"
echo "Run $(tput setaf 1)source ~/.profile $(tput setaf 7)to activate the new path."