#!/bin/bash

# Compile and package the application with the Gradle build tool.
# Chris Joakim, Microsoft, January 2022

echo 'clean ...'
./gradlew clean --quiet

echo 'build ...'
./gradlew build  --warning-mode all

echo 'creating deployable uberJar ...'
./gradlew uberJar

find . | grep app-uber.jar

echo 'done'
