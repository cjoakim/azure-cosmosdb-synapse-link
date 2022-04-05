
# Load the CosmosDB/Mongo database with the generated "ecommerce retail" dataset
# consisting of customers, products, sales, and line items.
# Chris Joakim, Microsoft

# .\venv\Scripts\Activate.ps1
python --version

python main.py load_container demo customers customer_id data/customers.json
python main.py load_container demo products  upc         data/product_catalog.json
python main.py load_container demo stores    store_id    data/stores.json
python main.py load_container demo sales     sale_id     data/sales1.json

# execute during demonstration:
# python main.py load_container demo sales     sale_id     data/sales2.json

python main.py count_documents demo customers
python main.py count_documents demo products
python main.py count_documents demo stores
python main.py count_documents demo sales

echo 'done'
