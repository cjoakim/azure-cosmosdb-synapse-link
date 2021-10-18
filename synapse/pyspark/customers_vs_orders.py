#!/usr/bin/env python
# coding: utf-8

# # Process the Customers vs Orders Synapse Link Data

# In[ ]:


# Load the SynapseLink Customers data into a Dataframe

df_customers = spark.read    .format("cosmos.olap")    .option("spark.synapse.linkedService", "demoCosmosDB")    .option("spark.cosmos.container", "customers")    .load()
display(df_customers.limit(3))


# In[ ]:


# Load the SynapseLink Orders data into a Dataframe

df_orders = spark.read    .format("cosmos.olap")    .option("spark.synapse.linkedService", "demoCosmosDB")    .option("spark.cosmos.container", "orders")    .load()
display(df_orders.limit(3))


# In[ ]:


# Select just the doctype == 'orders' from the Orders Dataframe
# Exclude the line_item and delivery document types

df_order_docs = df_orders.filter(df_orders["doctype"].isin(["order"]))
display(df_order_docs.limit(3))


# In[ ]:


# Display the Observed Schemas of the Dataframes

print('=== df_customers')
df_customers.printSchema()

print('=== df_orders')
df_orders.printSchema()

print('=== df_order_docs')
display(df_order_docs.printSchema())


# In[ ]:


# Display the shapes of the Dataframes

print('df_customers:')
print((df_customers.count(), len(df_customers.columns)))

print('df_orders')
print((df_orders.count(), len(df_orders.columns)))

print('df_order_docs')
print((df_order_docs.count(), len(df_order_docs.columns)))


# In[84]:


# Create Minimal Dataframes for Join operation 

from pyspark.sql.functions import col

df_customers_minimal = df_customers.select(
    col('customerId'),
    col('name'))

print('df_customers_minimal')
display(df_customers_minimal.printSchema())
print((df_customers_minimal.count(), len(df_customers_minimal.columns)))

df_orders_minimal = df_order_docs.select(
    col('orderId'),
    col('customerId'),
    col('item_count'),
    col('order_total'))

print('df_orders_minimal')
display(df_orders_minimal.printSchema())
print((df_orders_minimal.count(), len(df_orders_minimal.columns)))


# In[85]:


# Join the Customers to their Order documents

df_joined = df_orders_minimal.join(df_customers_minimal, ['customerId'])

display(df_joined.printSchema())
print((df_joined.count(), len(df_joined.columns)))


# In[86]:


display(df_joined.limit(30))


# In[ ]:




df_grouped = df_joined.groupby("customerId").sum("order_total").alias('total_orders')

display(df_grouped.printSchema())
print((df_grouped.count(), len(df_grouped.columns)))


# In[104]:


import pyspark.sql.functions as F 

df_agg = df_joined.groupBy("customerId")     .agg(
        F.count("customerId").alias('order_count'), \
        F.sum("order_total").alias("total_dollar_amount"), \
        F.sum("item_count").alias("total_item_count"))

display(df_agg.printSchema())
print((df_agg.count(), len(df_agg.columns)))


# In[105]:


display(df_agg.limit(30))


# In[99]:


import pyspark.sql.functions as F 

df_agg2 = df_joined.groupBy("customerId").agg(
    {"order_total": "sum", "item_count": "sum", "customerId":"count"})
display(df_agg2.printSchema())
print((df_agg2.count(), len(df_agg2.columns)))


# In[101]:


display(df_agg2.limit(30))


# In[ ]:




