#!/usr/bin/env bash

#set -e

# Here you can initialize the defaults to the environment variables which are required for IntelliJ code formatting. 
WORKING_DIRECTORY=${WORKING_DIRECTORY:-/home/circleci}
INTELLIJ_VERSION=${INTELLIJ_VERSION:-2022.3.2}
INTELLIJ_CONFIG_FOLDER=${INTELLIJ_CONFIG_FOLDER:-/home/circleci/.config/JetBrains/IntelliJIdea2022.3}

echo "Working with the following environment: "
echo "WORKING_DIRECTORY = $WORKING_DIRECTORY"
echo "INTELLIJ_VERSION = $INTELLIJ_VERSION"
echo "INTELLIJ_CONFIG_FOLDER = $INTELLIJ_CONFIG_FOLDER"
