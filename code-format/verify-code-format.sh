#!/usr/bin/env bash

#set -e

# Set the following environment varibales with the proper values before execute this script:
# DEVELOPER_TOOLS_PATH: ~/developer-tools
# $1: The path to the files which need to be formatted
# $2: The path to the root of the git repository of the formatted files

echo "Verify IntelliJ code format"

cd ~/intellij/*
./bin/format.sh -r $1 -m "*.java|*.ts|*.js|*.html|*.css|*.json" -s $DEVELOPER_TOOLS_PATH/intellij-config/codestyles/Greencode.xml
cd $2

echo "Checking that the formatted files are unchanged"
if [[ $(git status | grep "modified:" | wc -l) -gt 0 ]]; then
	echo "The code format of the following files have been changed:"
	git status
	exit 1
fi

echo "Files verified successfully"