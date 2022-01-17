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

# $ ./recreate_demo_db.sh
# ===
# deleting database ...
# GetDatabase demo -> Exception Microsoft.Azure.Cosmos.CosmosException : Response status code does not indicate success: NotFound (404); Substatus: 0; ActivityId: ce4f3dc2-f5e2-4aa1-ba7e-e726b101b964; Reason: (
# Errors : [
#   "Resource Not Found. Learn more: https://aka.ms/cosmosdb-tsg-not-found"
# ... exception messages ...
# DeleteDatabase demo -> statusCode -1
# sleeping 20 ...
# ===
# creating database ...
# CreateDatabase demo 10000 -> status code Created, RU 3
# sleeping 20 ...
# ===
# creating containers ...
# CreateContainer demo customers 0 -> Id customers
# CreateContainer demo products 0 -> Id products
# CreateContainer demo stores 0 -> Id stores
# CreateContainer demo sales 0 -> Id sales
# sleeping 20 ...
# listing databases ...
# demo
# ListDatabases - count 1
# database 1: demo current RU 1000
# listing containers ...
# ListContainers - count 4
# container in db: demo -> products
# container in db: demo -> customers
# container in db: demo -> stores
# container in db: demo -> sales
# done
