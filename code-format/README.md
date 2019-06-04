# intellij-code-formatter usage
- The following example demonstrates how to use intellij-code-formatter in your project
```yaml
version: 2.1

orbs:
  intellij-code-format: corballis/intellij-code-format@2018.3.5

jobs:
  build:
    docker:
      # specify the version you desire here
      - image: circleci/openjdk:8u151-jdk-node-browsers
    working_directory: ~/repo
    environment:
      INTELLIJ_LICENSE_KEY_URL: https://path.to/yourlicense
      CIRCLE_WORKING_DIRECTORY: /home/circleci/repo

    steps:
      - checkout
      - intellij-code-format/verify-code-format
```

# Publishing intellij-code-formatter ORB to CircleCi Registry

 - Clone developer-tools project: ```git clone git@github.com:corballis/developer-tools.git```
 - In ```code-format``` folder open ```init-variables.sh``` for edit
 - Change ```INTELLIJ_VERSION``` and ```INTELLIJ_CONFIG_FOLDER``` varibales according to your current IntelliJ settings.
 - Update the cache keys in ```code-formatter.orb.yml``` to the new IntelliJ version 
 - In order to publish the new ORB version to the registry you need to use CicleCi CLI.
    - CLI only works on Linux environment. If you are using Windows the best option is to use CircleCi's docker image.
    - In code-format folder execute the command below (from git bash) after you have made the following changes:
        - Replace the ```[VERSION]``` placeholder in the command with the current IntelliJ version. e.g: 2018.3.5 (use the same as you used earlier in ```INTELLIJ_VERSION``` variable)
        - Replace ```[YOUR_TOKEN_COMES_HERE]``` to your developer token. [Get your token here.](https://circleci.com/account/api)
```sh
docker run --rm -v $(pwd):/data circleci/circleci-cli:alpine orb publish /data/code-formatter.orb.yml corballis/intellij-code-format@[VERSION] --token [YOUR_TOKEN_COMES_HERE]
```

- If you need to make changes in the ORB's code it's better to use dev versions. In order to do this use ```@dev:any-string-you-want``` when you publish your ORB. Don't forget to publish the final version when you are finished with the development because dev versions will be removed after a period of time.

# Create new ORB/namespace on Windows environment:
- In order to create new ORB in the registry you need to use CicleCi CLI.
    - CLI only works on Linux environment. If you are using Windows the best option is to use CircleCi's docker image.
    - This sometimes doesn't work properly when you need to answer questions (y/n) in the command.
    - In these cases you need to execute the command in the container. To do so, execute the following command in a regular CMD window (you need to be in the same folder where your CircleCi config is placed):
```sh
docker run -it -v %cd%:/data --entrypoint /bin/sh circleci/circleci-cli:alpine
```
- In the container, you can use ```cicleci``` command as it is described in the documentation.
