
# Create a zip file creating the resulting generated dataset.
# Chris Joakim, Microsoft

echo 'creating dataset.zip ...'
cd data/retail
rm *.zip
zip retail_dataset.zip *.*
cd ../..

echo 'done'
