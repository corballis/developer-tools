#!/usr/bin/env bash

#set -e

cd $1

SONAR_SERVER_URL=$2
SONAR_LOGIN=$3
SONAR_PROJECT_DIR=$4
SONAR_EXCLUSIONS=$5

echo "Current directory: $1, SonarQube server: $SONAR_SERVER_URL, Sonar token: $SONAR_LOGIN, Base dir: $SONAR_PROJECT_DIR, Exclusions: $SONAR_EXCLUSIONS"

if [ -z "${PROJECT_KEY}" ]; then
	echo "Generating project key..."
	PROJECT_NAME=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.artifactId}' --non-recursive exec:exec 2>/dev/null)
	BRANCH_NAME=$(git branch | grep \* | cut -d ' ' -f2)
	PROJECT_KEY="$PROJECT_NAME:$BRANCH_NAME"
fi

echo "SonarQube will analyze this project with the following key: $PROJECT_KEY"

SONAR_SCANNER_VERSION=3.3.0.1492

echo "Downloading Sonar Scanner SONAR_SCANNER_VERSION"

set -x &&\
curl --insecure -o ~/sonarscanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION-linux.zip &&\
unzip -d ~/ ~/sonarscanner.zip &&\
#   ensure Sonar uses the provided Java for musl instead of a borked glibc one
sed -i 's/use_embedded_jre=true/use_embedded_jre=false/g' ~/sonar-scanner-$SONAR_SCANNER_VERSION-linux/bin/sonar-scanner

SONAR_RUNNER_HOME=~/sonar-scanner-$SONAR_SCANNER_VERSION-linux
PATH="$SONAR_RUNNER_HOME/bin${PATH:+:${PATH}}"

echo "Looking for binaries in all maven modules..."
BINARIES=""
for i in $(find . -name pom.xml); do
    level=$(mvn help:evaluate -f $i -Dexpression=project.build.directory -q -DforceStdout)
    level=$(readlink -f $level)
	[[ -z "$BINARIES" || ! -d "$level" ]] && BINARIES="$level" || BINARIES="$BINARIES,$level"
done
echo "Scan will be executed on the following java binaries: $BINARIES"

LIBRARIES_LOCATION=$(mvn -q exec:exec -Dexec.executable=echo -Dexec.args="%classpath" | sed 's/:/,/g')

echo "Location of the binaries $BINARIES"

echo "Waiting for SonarQube task to start (might take a while....)"

TASK_URL=$(sonar-scanner -D sonar.projectKey=$PROJECT_KEY \
 -Dsonar.projectName=$PROJECT_KEY \
 -Dsonar.projectBaseDir=$SONAR_PROJECT_DIR \
 -Dsonar.host.url=$SONAR_SERVER_URL \
 -Dsonar.login=$SONAR_LOGIN \
 -Dsonar.java.binaries=$BINARIES \
 -Dsonar.java.libraries="$LIBRARIES_LOCATION" \
 -Dsonar.java.test.libraries="$LIBRARIES_LOCATION" \
 -Dsonar.exclusions=$SONAR_EXCLUSIONS | tee out | grep -Eo 'http.*/api/ce/task.*')

#TASK_URL=$(mvn compile -DskipTests sonar:sonar -Dsonar.projectKey=$PROJECT_KEY -Dsonar.projectName=$PROJECT_KEY -Dsonar.projectBaseDir=$SONAR_PROJECT_DIR -Dsonar.host.url=$SONAR_SERVER_URL -Dsonar.exclusions=$SONAR_EXCLUSIONS -Dsonar.login=$SONAR_LOGIN | tee out | grep -Eo 'http.*/api/ce/task.*')

CONNECT_RETRY=30
counter=0
echo "Task result will be available at $TASK_URL. Polling started..."
while [ -z ${SONAR_TASK_READY} ]; do
  echo "Waiting for SonarQube task to be ready ($counter/$CONNECT_RETRY)"
  if [[ "$(curl --silent -u $SONAR_LOGIN: $TASK_URL 2>&1 | grep -q 'analysisId'; echo $?)" = 0 ]]; then
      SONAR_TASK_READY=true;
  fi
  echo "Still not ready. Retrying..."
  if [[ ${counter} -eq ${CONNECT_RETRY} ]]; then
    echo "Max attempts reached"
    exit 1
  fi
  counter=$((counter+1))
  sleep 2
done

echo "Task result: "
curl -s -u $SONAR_LOGIN: $TASK_URL

ANALYSIS_ID=$(curl -s -u $SONAR_LOGIN: $TASK_URL | sed -e 's/[{}]/''/g' | awk -v RS=',"' -F: '/^analysisId/ {print $2}' | grep -oP '"\K[^"]+')

if [ -z "${ANALYSIS_ID}" ]; then
    echo "Something went wrong. ANALYSIS_ID is unset."
	exit 1
fi

ANALYSIS_URL="$SONAR_SERVER_URL/api/qualitygates/project_status?analysisId=$ANALYSIS_ID"

echo "Verify Quality Gate results for analysis $ANALYSIS_ID ($ANALYSIS_URL)"

if [[ $(curl -s -u $SONAR_LOGIN: $ANALYSIS_URL 2>&1 | grep "ERROR" | wc -l) -gt 0 ]]; then
	echo "Quality Gate has been broken:"
	curl -s -u $SONAR_LOGIN: $ANALYSIS_URL
	exit 1
fi

echo "Oooh happy day. Code quality is great"
