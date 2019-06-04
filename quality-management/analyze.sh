#!/usr/bin/env bash

#set -e

cd $1

SONAR_SERVER_URL=$2
SONAR_LOGIN=$3
SONAR_EXCLUSIONS=$4

echo "Current directory: $1, SonarQube server: $SONAR_SERVER_URL, Sonar token: $SONAR_LOGIN, Exclusions: $SONAR_EXCLUSIONS"

if [ -z "${PROJECT_KEY}" ]; then
	echo "Generating project key..."
	PROJECT_NAME=$(mvn -q -Dexec.executable=echo -Dexec.args='${project.artifactId}' --non-recursive exec:exec 2>/dev/null)
	BRANCH_NAME=$(git branch | grep \* | cut -d ' ' -f2)
	PROJECT_KEY="$PROJECT_NAME:$BRANCH_NAME"
fi

echo "SonarQube will analyze this project with the following key: $PROJECT_KEY"

echo "Waiting for SonarQube task to start (might take a while....)"
TASK_URL=$(mvn compile -DskipTests sonar:sonar -Dsonar.projectKey=$PROJECT_KEY -Dsonar.projectName=$PROJECT_KEY -Dsonar.host.url=$SONAR_SERVER_URL -Dsonar.exclusions=$SONAR_EXCLUSIONS -Dsonar.login=$SONAR_LOGIN | tee out | grep -Eo 'http.*/api/ce/task.*')

echo "Task result will be available at $TASK_URL. Polling started..."

CONNECT_RETRY=30
 
counter=0
echo "Started to query SonarQube"
while [ $(curl -s -u $SONAR_LOGIN: $TASK_URL 2>&1 | grep 'analysisId' | wc -l) -lt 0 ]&&[ $counter -lt $CONNECT_RETRY ]; do
  sleep 5
  ((counter++))
  echo "waiting for SonarQube task to be ready ($counter/$CONNECT_RETRY)"
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
