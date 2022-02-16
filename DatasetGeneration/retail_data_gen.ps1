
# Generate simulated and correlated "ecommerce retail" datasets 
# consisting of products, stores, customers, orders, and line items.
# These are for loading into CosmosDB with the DotnetConsoleApp.
# Chris Joakim, Microsoft

mkdir -p data/retail
rm data/retail/*.*

echo 'activating venv ...'
.\venv\Scripts\Activate.ps1
python --version

python retail_data_gen.py create_product_catalog 12 20 90 
python retail_data_gen.py create_stores 100
python retail_data_gen.py create_customers 10000
python retail_data_gen.py create_sales_data 2021-01-01 2022-02-17 75 3

python retail_data_gen.py slice_sales_data 2022-02-17
echo 'removing sales.json, it was just split into two files ...'
#rm data/retail/sales.json

echo 'creating retail_dataset.zip ...'
cd data
cd retail

rm *.zip
jar cvf retail_dataset.zip *.*

cd ..
cd ..

echo 'done'
