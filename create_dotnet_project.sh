#!/bin/bash

# Use the dotnet CLI to bootstrap a dotnet project.
# Chris Joakim, Microsoft

app_name="DotnetConsoleApp"

echo ''
echo '=========='
echo 'removing app directory...'
rm -rf $app_name

echo ''
echo '=========='
echo 'checking dotnet --version  (5.0.x is expected, as of August 2021)'
dotnet --version

echo ''
echo '=========='
echo 'creating project...'
dotnet new console -o DotnetConsoleApp
cd     DotnetConsoleApp

echo 'adding packages...'
dotnet add package Azure.Storage.Blobs
dotnet add package Microsoft.Azure.Cosmos

# other packages of interest:
# dotnet add package CsvHelper
# dotnet add package DocumentFormat.OpenXml 
# dotnet add package Faker.Net
# dotnet add package Microsoft.EntityFrameworkCore.Cosmos
# dotnet add package Microsoft.EntityFrameworkCore.Sqlite
# dotnet add package Microsoft.Azure.DataLake.Store

cat    DotnetConsoleApp.csproj
dotnet restore
dotnet list package
dotnet build
dotnet run

echo ''
echo 'done'
