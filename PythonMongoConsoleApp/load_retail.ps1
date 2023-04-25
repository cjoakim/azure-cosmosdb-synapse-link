
# Load the CosmosDB/Mongo database with the generated "ecommerce retail" dataset
# consisting of customers, products, sales, and line items.
# Chris Joakim, Microsoft

# .\venv\Scripts\Activate.ps1
python --version

python main.py load_container retail customers customer_id data/customers.json
python main.py load_container retail products  upc         data/product_catalog.json
python main.py load_container retail stores    store_id    data/stores.json
python main.py load_container retail sales     sale_id     data/sales1.json

# execute during demonstration:
# python main.py load_container retail sales sale_id data/sales2.json

python main.py count_documents retail customers
python main.py count_documents retail products
python main.py count_documents retail stores
python main.py count_documents retail sales

echo 'done'
