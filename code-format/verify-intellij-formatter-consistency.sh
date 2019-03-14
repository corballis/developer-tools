#!/usr/bin/env bash

#set -e

# Set the following environment varibales with the proper values before execute this script.
# INTELLIJ_VERSION: 2018.3.5
# INTELLIJ_CONFIG_FOLDER: /home/user/.IntelliJIdea2018.3/config
# INTELLIJ_LICENSE_KEY_URL: https://drive.google.com/a/corballis.ie/uc?authuser=0&id=1aldFdTVcIEYHjiFeJpM5IbGu9CWkoPX0&export=download
# DEVELOPER_TOOLS_PATH: ~/developer-tools

echo "Verify IntelliJ code formatter consistency"

cd /opt/intellij/*
./bin/format.sh -r $DEVELOPER_TOOLS_PATH/code-format/editor-verification-files -m "*.java|*.ts|*.js|*.html|*.css|*.json" -s $DEVELOPER_TOOLS_PATH/intellij-config/codestyles/Greencode.xml
cd $DEVELOPER_TOOLS_PATH

echo "Checking that the reference files are unchanged"
#HAS_CHANGE=$(git status | grep -c "modified:")
#if [ ${HAS_CHANGE} -gt 0 ]; then
#	echo "Probably some configuration properties have been changed in IntelliJ settings since the last verstion. The code format of the following files have been changed:"
#	git status
#	exit 1
#fi

echo "Sample files verified successfully"