#!/bin/bash

# Execute the SQL queries in file sql/queries.txt with DotNet SDK.
# Chris Joakim, Microsoft

mkdir -p out
rm out/q*.json

dotnet run execute_queries demo travel sql/queries.txt

echo ''
echo 'queries completed'
