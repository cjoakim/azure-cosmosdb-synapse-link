#!/bin/bash

mkdir -p out
rm out/q*.json

dotnet run execute_queries demo travel sql/queries.txt

echo ''
echo 'queries completed'
