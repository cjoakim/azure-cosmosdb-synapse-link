#!/bin/bash

# Display a related sale and line_item.
# Chris Joakim, Microsoft

echo ''
echo 'sales document; doctype = sale:'
cat data/retail/sales1.json | grep \"sale\" | tail -1 | jq 

echo ''
echo 'related sales document; doctype = line_item:'
cat data/retail/sales1.json | grep \"line_item\" | tail -1 | jq 

echo 'done'
