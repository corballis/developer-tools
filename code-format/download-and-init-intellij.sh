#!/usr/bin/env bash

set -e

# Set the following environment varibales with the proper values before execute this script.
# INTELLIJ_VERSION: 2018.3.5
# INTELLIJ_CONFIG_FOLDER: /home/user/.IntelliJIdea2018.3/config
# INTELLIJ_LICENSE_KEY_URL: https://drive.google.com/a/corballis.ie/uc?authuser=0&id=1aldFdTVcIEYHjiFeJpM5IbGu9CWkoPX0&export=download
# DEVELOPER_TOOLS_PATH: ~/developer-tools

cd /opt/intellij
if [[ $(ls | sort -n | head -1 | wc -c) -eq 0 ]]; then
	echo "Downloading IntellijJ $INTELLIJ_VERSION"

	sudo curl -L "https://download.jetbrains.com/idea/ideaIU-${INTELLIJ_VERSION}.tar.gz" --output ~/intellij.tar.gz
	sudo tar xzf ~/intellij.tar.gz -C /opt/intellij
fi 

echo "Setting up development configuration"
mkdir -p "${INTELLIJ_CONFIG_FOLDER}"
cp -r $DEVELOPER_TOOLS_PATH/intellij-config/* $INTELLIJ_CONFIG_FOLDER

echo "Configure IntelliJ license file"
sudo curl -L "${INTELLIJ_LICENSE_KEY_URL}" --output "${INTELLIJ_CONFIG_FOLDER}/idea.key"

echo "IntelliJ is ready to use"