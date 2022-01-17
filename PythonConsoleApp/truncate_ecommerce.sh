#!/bin/bash

# Delete all documents from the five containers.
# Display document counts both before and after the deletions.
# Chris Joakim, Microsoft, January 2022

echo 'count_documents before ...'
python main.py count_documents demo customers
python main.py count_documents demo products
python main.py count_documents demo stores
python main.py count_documents demo sales
python main.py count_documents demo sales_aggregates

echo 'truncate_containers ...'
python main.py truncate_container demo customers
python main.py truncate_container demo products
python main.py truncate_container demo stores
python main.py truncate_container demo sales
python main.py truncate_container demo sales_aggregates

echo 'count_documents after ...'
python main.py count_documents demo customers
python main.py count_documents demo products
python main.py count_documents demo stores
python main.py count_documents demo sales
python main.py count_documents demo sales_aggregates

echo 'done'
