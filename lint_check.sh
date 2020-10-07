#!/usr/bin/bash
git diff master | grep "diff --" | grep "\.py$" | awk '{ print $4 }' | sed "s/^b/\./" | xargs pylint
echo "git diff pylint return code: " $?
pylint compute.py
echo "compute.py pylint return code: " $?
