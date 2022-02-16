
# Display the generated datasets
# Chris Joakim, Microsoft

echo 'displaying zip contents:'
jar tvf data/retail/retail_dataset.zip

echo ''
echo 'product_catalog:'
Get-Content data/retail/product_catalog.json -Head 1

echo ''
echo 'stores:'
Get-Content data/retail/stores.json -Head 1

echo ''
echo 'customers:'
Get-Content data/retail/customers.json -Head 1

echo ''
echo 'sales1:'
Get-Content data/retail/sales1.json -Head 3

echo ''
echo 'sales2:'
Get-Content data/retail/sales2.json -Head 3
echo 'done'
