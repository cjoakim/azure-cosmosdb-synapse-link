# Synapse


"push down predicate" example
df = spark.read.load(blob_url, format='csv', header=True, sep='|').filter(col("from_iata") == "CLT")



