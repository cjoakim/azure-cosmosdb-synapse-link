#!/bin/bash

# Delete and recreate the demo database and its containers.
# Chris Joakim, Microsoft

dbname="demo"
db_rus="4000"

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
dotnet run create_container $dbname sales_aggregates /pk 0

echo 'sleeping 20 ...'
sleep 20

echo 'listing databases ...'
dotnet run list_databases

echo 'listing containers ...'
dotnet run list_containers $dbname

echo 'done'


# Partial Output:
# Sun Jan 23 13:34:46 EST 2022
# Sun Jan 23 13:37:01 EST 2022
# CountDocuments demo customers -> 10000
# CountDocuments demo products -> 20894
# CountDocuments demo stores -> 100
# CountDocuments demo sales -> 101159
