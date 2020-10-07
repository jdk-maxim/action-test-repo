#!/bin/bash

echo "Staring push actions"
ls
git status
git log -n 3
which python3
python3 --version
pylint --version


# Install required packages
# TODO: Will replace with docker in future
#apt-get install git
#apt-get install python
#sudo apt install python3-venv python3-pip

# all pip missing from ubuntu version: atomicwrites numpy onnx packagin pluggy protobuf py pylint pyparsing pytest
pip3 --version

pip3 install Cython 

pip3 install -r requirements.txt 
if [ $? != 0 ]
then
	echo "Failed to install requirements.txt"
	exit 1
else
	echo "requirements.txt install passed" 
fi

pip3 install -r requirements_distiller.txt 
if [ $? != 0 ]
then
	echo "Failed to install requirements_distiller.txt"
	exit 1
else
	echo "requirements_distiller.txt intall passed" 
fi

#git diff master | grep "diff --" | grep "\.py$" | awk '{ print $4 }' | sed "s/^b/\./" | xargs pylint
#echo "git diff pylint return code: " $?
pylint compute.py

if [ $? != 0 ]
then
	echo "Expected this to pass"
	exit 1
else
	echo "compute.py pylint passes" 
fi

pylint bad_compute.py

if [ $? == 0 ]
then
	echo "Expected this to fail"
	exit 1 
else
	echo "bad_compute.py pylint return code: " $?
fi

# exit 1 for errors, exit 0 for success
