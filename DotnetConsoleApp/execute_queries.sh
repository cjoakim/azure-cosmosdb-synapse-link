#!/bin/bash

# Chris Joakim, Microsoft, October 2021

mkdir -p out
rm out/q*.json

dotnet run execute_queries demo travel sql/queries.txt

echo ''
echo 'queries completed'
