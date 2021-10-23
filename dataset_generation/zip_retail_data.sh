#!/bin/bash

# Create a zip file of the generated retail data - store this
# file as a backup as necessary.
# Chris Joakim, Microsoft, 2021/10/23

cd data/wrangled/retail/

zip retail_data.zip  *.*

cd ../../..

echo ''
echo 'done'
