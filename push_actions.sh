#!/bin/sh -l

echo "Starting push actions"
echo "Running on OS: $(uname -a)"
which python3
python3 --version
pip3 --version

pip3 install Cython 
pip3 install pylint

pylint --version

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
	echo "requirements_distiller.txt install passed"
fi

#git diff master | grep "diff --" | grep "\.py$" | awk '{ print $4 }' | sed "s/^b/\./" | xargs pylint

echo "Running pylint on compute.py"
pylint compute.py

if [ $? != 0 ]
then
	echo "Expected this to pass"
	exit 1
else
	echo "compute.py pylint passes" 
fi

echo "Running pylint on compute.py"
pylint bad_compute.py

if [ $? == 0 ]
then
	echo "Expected this to fail"
	exit 1 
else
	echo "bad_compute.py pylint return code: " $?
fi

# exit 1 for errors, exit 0 for success
