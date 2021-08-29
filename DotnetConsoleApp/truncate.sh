#!/bin/bash

# usage: ./truncate.sh demo travel

echo 'counting docs in db: '$1' container: '$2
dotnet run count_documents $1 $2 

echo 'truncating...'
dotnet run truncate_container $1 $2 

echo 'counting after truncating...'
dotnet run count_documents $1 $2 
