# sonarqube-analyzer usage
- The following example demonstrates how to use intellij-code-formatter in your project
```yaml
version: 2.1

orbs:
  sonarqube-analyzer: corballis/sonarqube-analyzer@0.1.1

jobs:
  build:
    docker:
      # specify the version you desire here
      - image: circleci/openjdk:8u151-jdk-node-browsers
    working_directory: ~/repo

    steps:
      - checkout
      - sonarqube-analyzer/check-code-quality:
          maven_working_directory: "~/repo"
          sonar_project_dir: "~/repo"
```

# Publishing intellij-code-formatter ORB to CircleCi Registry

 - Clone developer-tools project: ```git clone git@github.com:corballis/developer-tools.git```
 - ```cd``` to ```quality-management``` folder
 - In order to publish the new ORB version to the registry you need to use CicleCi CLI.
    - CLI only works on Linux environment. If you are using Windows the best option is to use CircleCi's docker image.
    - In ```quality-management``` folder execute the command below (from git bash) after you have made the following changes:
        - Replace the ```[VERSION]``` placeholder in the command with the new version of your orb. **Always follow Semver!!!**
        - Replace ```[YOUR_TOKEN_COMES_HERE]``` to your developer token. [Get your token here.](https://circleci.com/account/api)
```sh
docker run --rm -v $(pwd):/data circleci/circleci-cli:alpine orb publish /data/sonarqube-analyzer.orb.yml corballis/sonarqube-analyzer@[VERSION] --token [YOUR_TOKEN_COMES_HERE]
```
