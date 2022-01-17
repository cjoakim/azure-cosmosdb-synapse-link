#!/bin/bash

dbname="demo"
db_rus="10000"

echo '==='
echo 'deleting database ...'
dotnet run delete_database $dbname

echo 'sleeping 20 ...'
sleep 20

echo '==='
echo 'creating database ...'
dotnet run create_database $dbname $db_rus

echo 'sleeping 20 ...'
sleep 20

echo '==='
echo 'creating containers ...'
dotnet run create_container $dbname customers /pk 0
dotnet run create_container $dbname products /pk 0
dotnet run create_container $dbname stores /pk 0
dotnet run create_container $dbname sales /pk 0

echo 'sleeping 20 ...'
sleep 20

echo 'listing databases ...'
dotnet run list_databases

echo 'listing containers ...'
dotnet run list_containers $dbname

echo 'done'


# Output:

