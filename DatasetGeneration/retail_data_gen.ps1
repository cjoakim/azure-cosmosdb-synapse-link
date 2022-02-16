
# Generate simulated and correlated "ecommerce retail" datasets 
# consisting of products, stores, customers, orders, and line items.
# These are for loading into CosmosDB with the DotnetConsoleApp.
# Chris Joakim, Microsoft

mkdir -p data/retail
rm data/retail/*.*

source venv/bin/activate
python --version

python retail_data_gen.py create_product_catalog 12 20 90 
python retail_data_gen.py create_stores 100
python retail_data_gen.py create_customers 10000
python retail_data_gen.py create_sales_data 2021-01-01 2022-02-17 75 3

python retail_data_gen.py slice_sales_data 2022-02-17
echo 'removing sales.json, it was just split into two files ...'
rm data/retail/sales.json

echo 'creating retail_dataset.zip ...'
cd data/retail
rm *.zip
zip retail_dataset.zip *.*

echo 'displaying zip contents:'
jar tvf retail_dataset.zip

cd ../..

echo ''
echo 'product_catalog:'
head -1 data/retail/product_catalog.json
wc -l   data/retail/product_catalog.json

echo ''
echo 'stores:'
head -1 data/retail/stores.json
wc -l   data/retail/stores.json

echo ''
echo 'customers:'
head -1 data/retail/customers.json
wc -l   data/retail/customers.json

echo ''
echo 'sales1:'
tail -5 data/retail/sales1.json
wc -l   data/retail/sales1.json

echo ''
echo 'sales2:'
head -5 data/retail/sales2.json
wc -l   data/retail/sales2.json

echo 'done'
