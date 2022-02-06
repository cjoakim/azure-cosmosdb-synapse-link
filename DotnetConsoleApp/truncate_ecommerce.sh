#!/bin/bash

# Delete all documents from the five containers.
# Display document counts both before and after the deletions.
# Chris Joakim, Microsoft, February 2022


echo 'count_documents before ...'
dotnet run count_documents demo customers
dotnet run count_documents demo products
dotnet run count_documents demo stores
dotnet run count_documents demo sales
dotnet run count_documents demo sales_aggregates

echo 'truncate_containers ...'
dotnet run truncate_container demo customers
dotnet run truncate_container demo products
dotnet run truncate_container demo stores
dotnet run truncate_container demo sales
dotnet run truncate_container demo sales_aggregates

echo 'count_documents after ...'
dotnet run count_documents demo customers
dotnet run count_documents demo products
dotnet run count_documents demo stores
dotnet run count_documents demo sales
dotnet run count_documents demo sales_aggregates

echo 'done'
