# PythonConsoleApp

## Links 

- https://pymongo.readthedocs.io/en/stable/
- https://pymongo.readthedocs.io/en/stable/tutorial.html
- https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/mongodb-introduction
- https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/create-mongodb-python 
- https://docs.microsoft.com/en-us/azure/cosmos-db/mongodb/find-request-unit-charge-mongodb


## Quick Setup

```
$ git clone https://github.com/cjoakim/azure-cosmosdb-synapse-link.git

$ cd azure-cosmosdb-synapse-link

$ cd PythonConsoleApp//

$ ./venv.sh

$ source venv/bin/activate

$ python --version
Python 3.9.10

$ python main.py
Usage:
    python main.py list_databases
    python main.py list_containers demo
    python main.py count_documents demo stores
    python main.py load_container dbname cname pkattr infile
    python main.py load_container demo stores store_id data/stores.json --verbose
    python main.py execute_query demo stores find_by_pk --pk 2
    python main.py execute_query demo stores find_by_pk_id --pk 2 --id 61e6d8407a0af4624aaf0212 --verbose
```

TODO - add comments for load more containers
