#!/usr/bin/env python
# coding: utf-8

# # Read the CosmosDB Synapse Link Data into a Spark Dataframe

# In[ ]:



df = spark.read    .format("cosmos.olap")    .option("spark.synapse.linkedService", "demoCosmosDB")    .option("spark.cosmos.container", "travel")    .load()

display(df.printSchema())


# ## Display the Shape of the Dataframe - row and column count

# In[ ]:


# Print the row and column counts of the Dataframe

print((df.count(), len(df.columns)))


# ## Display the first 10 rows

# In[ ]:


display(df.limit(10))


# ## 

# ## Select and display the first 10 rows of the MIA:MAO route, sorted by date

# In[ ]:


from pyspark.sql.functions import col

# unpack the structs of type string into another dataframe, df2
df2 = df.select(
    col('route'),
    col('id'),
    col('doc_time'),
    col('date'),
    col('count'),
    col('to_airport_country'),
    col('to_airport_name')).filter("_ts > 1630355233") 

# rename the unpacked columns, into new dataframe df3
new_column_names = ['route','id','doc_time','date','count','to_airport_country','to_airport_name']
df3 = df2.toDF(*new_column_names)

# create new df4, filtering by route 'ATL:MBJ', sorting by 'doc_time' descending
df4 = df3.filter("route == 'MIA:MAO'").sort("doc_time", ascending=False)

# display the first 10 rows
df4.show(n=20)

