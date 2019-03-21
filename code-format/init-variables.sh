#!/usr/bin/env bash

#set -e

# Here you can initialize the defaults to the environment variables which are required for IntelliJ code formatting. 
INTELLIJ_VERSION=${INTELLIJ_VERSION:-2018.3.5}
INTELLIJ_CONFIG_FOLDER=${INTELLIJ_CONFIG_FOLDER:-/home/circleci/.IntelliJIdea2018.3/config}
DEVELOPER_TOOLS_PATH=${DEVELOPER_TOOLS_PATH:-/home/circleci/developer-tools}

echo "Working with the following environment: "
echo "INTELLIJ_VERSION = $INTELLIJ_VERSION"
echo "INTELLIJ_CONFIG_FOLDER = $INTELLIJ_CONFIG_FOLDER"
echo "DEVELOPER_TOOLS_PATH = $DEVELOPER_TOOLS_PATH"
