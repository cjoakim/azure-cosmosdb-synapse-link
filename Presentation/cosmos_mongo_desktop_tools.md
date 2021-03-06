# CosmosDB/Mongo with Third Party Desktop Tools

## Matlab

### Documentation Links

- https://www.mathworks.com/products/get-matlab.html
- https://www.mathworks.com/help/database/ug/database-toolbox-interface-for-mongodb-installation.html
- https://www.mathworks.com/help/database/ug/mongo.html
- https://github.com/mathworks-ref-arch/matlab-azure-cosmos-db

### Example code

See Azure Portal for your CosmosDB/Mongo configuration values.

```
server = "cjoakimcslcosmosmongo.mongo.cosmos.azure.com";
port   = 10255;
dbname = "demo";
user   = "cjoakimcslcosmosmongo";
pass   = "M57pYUxx******************************************************************************==";
collection = "sales";

conn = mongo(server, port, dbname, 'UserName', user, 'Password', pass, 'SSLEnabled', true)

n = count(conn,collection)

close(conn)
```

### Screen Shot

<p align="center"><img src="img/matlab-query.png" width="99%"></p>

---

## Studio 3T 

See https://studio3t.com/

### Screen Shots

#### Query with IntelliShell

<p align="center"><img src="img/studio3t-query.png" width="99%"></p>

#### Configuration 

Configure the Server, Authentication, and SSL tabs as shown below.

<p align="center"><img src="img/studio3t-config1.png" width="60%"></p>

---

<p align="center"><img src="img/studio3t-config2.png" width="60%"></p>

---

<p align="center"><img src="img/studio3t-config3.png" width="60%"></p>
