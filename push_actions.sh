#!/bin/sh -l

do_a_test_expect_success()
{
	echo
	printf "\t ***> Running Test %s with command: %s\n" "$2" "$1"
	echo

	# Run the command, parameter 1
	if ! $1;
	then
		echo
		printf "\t ***> Failed to %s\n" "$2"
		echo
		exit 1
	else
		echo
		printf "\t ***> %s Completed without Error\n" "$2"
		echo
	fi
}

do_a_test_expect_failure()
{
	echo
	printf "\t ***> Running Test %s with command: %s\n" "$2" "$1"
	echo

	# Run the command, parameter 1

	if $1;
	then
		echo
		printf "\t ***> %s Completed without Error, but was expected to fail\n" "$2"
		echo
		exit 1
	else
		echo
		printf "\t ***> %s Failed as expected\n" "$2"
		echo
	fi
}

echo "Starting push actions"
echo "Running on OS: $(uname -a)"
command -v python3
python3 --version
pip3 --version

# FIXME: Should these be in requirements.txt ?
pip3 install Cython 
pip3 install pylint

pylint --version

do_a_test_expect_success "pip3 install -r requirements.txt" "Install requirements.txt"
do_a_test_expect_success "pip3 install -r requirements_distiller.txt" "Install requirements_distiller.txt"

# command to check all python files modified in this commit
# will NOT run in tensorflow docker unless git is installed
#git diff master | grep "diff --" | grep "\.py$" | awk '{ print $4 }' | sed "s/^b/\./" | xargs pylint

do_a_test_expect_success "pylint compute.py" "pylint compute.py"
do_a_test_expect_failure "pylint bad_compute.py" "pylint bad_compute.py"
