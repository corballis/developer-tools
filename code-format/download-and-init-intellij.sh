#!/usr/bin/env bash

set -e

# Set the following environment varibales with the proper values before execute this script.
# INTELLIJ_VERSION: 2019.3.3
# INTELLIJ_CONFIG_FOLDER: /home/user/.IntelliJIdea2018.3/config
# INTELLIJ_LICENSE_KEY_URL: https://pathtoyour.license
# WORKING_DIRECTORY: /home/circleci


if [[ ! -d "/home/circleci/intellij" ]]; then
	echo "Downloading IntellijJ $INTELLIJ_VERSION"
	sudo curl -L "https://download.jetbrains.com/idea/ideaIU-${INTELLIJ_VERSION}.tar.gz" --output ~/intellij.tar.gz
	sudo mkdir -p ~/intellij
	sudo tar xzf ~/intellij.tar.gz -C ~/intellij
fi 

echo "Setting up development configuration"
mkdir -p "${INTELLIJ_CONFIG_FOLDER}"
cp -r ${WORKING_DIRECTORY}/developer-tools/intellij-config/* $INTELLIJ_CONFIG_FOLDER

echo "Configure IntelliJ license file from ${INTELLIJ_LICENSE_KEY_URL}"
sudo curl -L "${INTELLIJ_LICENSE_KEY_URL}" --output "${INTELLIJ_CONFIG_FOLDER}/idea.key"
sudo chmod 777 "${INTELLIJ_CONFIG_FOLDER}/idea.key"

echo "IntelliJ is ready to use"
