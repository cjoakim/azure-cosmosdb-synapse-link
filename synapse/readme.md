# Synapse


"push down predicate" example
df = spark.read.load(blob_url, format='csv', header=True, sep='|').filter(col("from_iata") == "CLT")

## Adding PyPi and Java/Scala Libraries

- https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-manage-python-packages
- https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-version-support

- https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-manage-scala-packages#workspace-packages
- https://spark-packages.org/package/graphframes/graphframes

## Spark 3 Runtime

-  https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-version-support
- https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-3-runtime

spark-graphx_2.12-3.1.2.5.0-50849917.jar

## Listing the installed libraries

```
import pkg_resources

plist = list()

for d in sorted(pkg_resources.working_set):
    plist.append(str(d))

for p in sorted(plist):
    print(p)
```

## graphframes


```

```

