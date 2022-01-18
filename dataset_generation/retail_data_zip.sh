#!/bin/bash

# Create a zip file creating the resulting generated dataset.
# Chris Joakim, Microsoft, January 2022

echo 'creating dataset.zip ...'
cd data/products
rm *.zip
zip retail_dataset.zip *.*
cd ../..

echo 'done'
