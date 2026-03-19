#!/bin/bash

mkdir ~/programs
cd ~/programs
# clone Flye
git clone https://github.com/fenderglass/Flye

cd Flye

make
export PATH=$HOME/programs/Flye/bin:$PATH

# check version
flye -v
