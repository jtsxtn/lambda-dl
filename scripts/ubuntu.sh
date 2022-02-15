#!/bin/bash

#Install depedencies
echo ''
echo " ***  Installing depedencies  *** "
echo ''
sudo apt-get -y install git yt-dlp racket && raco pkg install html-parsing
echo ''

#Clone lambda-dl repo
echo " ***  Cloning repo  *** "
echo ''
git clone https://github.com/jtsxtn/lambda-dl.git
echo ''

#Build the project
echo " ***  Building project  *** "
echo ''
cd lambda-dl
raco exe -o lambda-dl main.rkt
echo ''

#Setting path
echo " *** Setting path *** "
echo ''
echo "PATH=$PATH:$(pwd)" | sudo tee -a ~/.profile
echo ''

echo "$(tput setaf 2)  ***  Installation completed  *** "
echo ''
echo "Run $(tput setaf 1)source ~/.profile $(tput setaf 2)to activate the new path."