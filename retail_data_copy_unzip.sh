#!/bin/bash

# Copy the generated retail_dataset.zip file to the app-specific Xxx\data\ directories
# and unzip it there.
# Chris Joakim, Microsoft

zipfile="DatasetGeneration/data/retail/retail_dataset.zip"
basename="retail_dataset.zip"

echo '==='
echo 'creating data directories ...'
mkdir -p DotnetSqlConsoleApp/data/
mkdir -p JavaMongoConsoleApp/app/data/
mkdir -p JavaSqlConsoleApp/app/data/
mkdir -p PythonMongoConsoleApp/data/
mkdir -p PythonSqlConsoleApp/data/

echo '==='
echo 'listing zipfile contents ...'
jar tvf $zipfile

echo '==='
echo 'copying zip file to target ConsoleApp directories ...'
cp $zipfile DotnetSqlConsoleApp/data/
cp $zipfile JavaMongoConsoleApp/app/data/
cp $zipfile JavaSqlConsoleApp/app/data/
cp $zipfile PythonMongoConsoleApp/data/
cp $zipfile PythonSqlConsoleApp/data/

echo '==='
echo 'unzipping in DotnetConsoleApp ...'
cd DotnetSqlConsoleApp/data/
unzip -o $basename
pwd
ls -al
cd ../..

echo '==='
echo 'unzipping in JavaMongoConsoleApp ...'
cd JavaMongoConsoleApp/app/data/
unzip -o $basename
pwd
ls -al
cd ../../..

echo '==='
echo 'unzipping in JavaSqlConsoleApp ...'
cd JavaSqlConsoleApp/app/data/
unzip -o $basename
pwd
ls -al
cd ../../..

echo '==='
echo 'unzipping in PythonMongoConsoleApp ...'
cd PythonMongoConsoleApp/data/
unzip -o $basename
pwd
ls -al
cd ../..

echo '==='
echo 'unzipping in PythonSqlConsoleApp ...'
cd PythonSqlConsoleApp/data/
unzip -o $basename
pwd
ls -al
cd ../..

echo 'done'
