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
		printf "\t ***> %s Completed, Success\n" "$2"
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
		printf "\t ***> %s Failed as expected, Success\n" "$2"
		echo
	fi
}

echo "Starting push actions"
echo "Running on OS: $(uname -a)"
command -v python3
git --version
python3 --version
pip3 --version

# FIXME: Should these be in requirements.txt ?
# FIXME: Shoudl not be needed? pip3 install Cython 
pip3 install pylint
pip3 install flake8

pylint --version
flake8 --version

echo "PWD $(pwd)"
echo "Directory contents: $(ls)"

echo "git diff"
git diff

echo "git diff HEAD^"
git diff HEAD^

echo "git diff master^"
git diff master^

#do_a_test_expect_success "pip3 install -r requirements.txt" "Install requirements.txt"
#do_a_test_expect_success "pip3 install -r requirements_distiller.txt" "Install requirements_distiller.txt"

# command to check all python files modified in this commit
# will NOT run in pytorch docker unless git is installed
echo "Gathering up all python files changed in last commit"
git log -n5
git status
echo "GITHUB_SHA: $GITHUB_SHA"
git show $GITHUB_SHA
echo "GITHUB_REF: $GITHUB_REF"
git show $GITHUB_REF


LINT_LIST=$(git diff master^ | grep "diff --" | grep "\.py$" | awk '{ print $4 }' | sed "s/^b/\./")
echo "Python files changed: $LINT_LIST"

do_a_test_expect_success "pylint $LINT_LIST" "pylint all python files modifed in this commit"

# Fixme, find a way to not die on fixme type warnings/errors, pylint returns exit code 4 for these
do_a_test_expect_success "pylint compute.py" "pylint compute.py"
do_a_test_expect_failure "pylint bad_compute.py" "pylint bad_compute.py"
