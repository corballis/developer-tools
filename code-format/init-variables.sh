#!/usr/bin/env bash

#set -e

# Here you can initialize the defaults to the environment variables which are required for IntelliJ code formatting. 
INTELLIJ_VERSION=${INTELLIJ_VERSION:-2019.1.4}
INTELLIJ_CONFIG_FOLDER=${INTELLIJ_CONFIG_FOLDER:-/home/circleci/.IntelliJIdea2019.1/config}

echo "Working with the following environment: "
echo "INTELLIJ_VERSION = $INTELLIJ_VERSION"
echo "INTELLIJ_CONFIG_FOLDER = $INTELLIJ_CONFIG_FOLDER"
