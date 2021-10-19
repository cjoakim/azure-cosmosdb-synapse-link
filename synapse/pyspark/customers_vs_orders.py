#!/usr/bin/env python
# coding: utf-8

# # Process the Customers vs Orders Synapse Link Data

# In[40]:


# Load the SynapseLink Customers and Orders data into a Dataframes.
# Then, filter the Orders for just the 'order' doctype.

df_customers = spark.read    .format("cosmos.olap")    .option("spark.synapse.linkedService", "demoCosmosDB")    .option("spark.cosmos.container", "customers")    .load()

df_orders = spark.read    .format("cosmos.olap")    .option("spark.synapse.linkedService", "demoCosmosDB")    .option("spark.cosmos.container", "orders")    .load()

df_order_docs = df_orders.filter(df_orders["doctype"].isin(["order"]))

print('df_customers, shape: {} x {}'.format(
        df_customers.count(), len(df_customers.columns)))
df_customers.printSchema()

print('df_orders, shape: {} x {}'.format(
        df_orders.count(), len(df_orders.columns)))
df_orders.printSchema()

print('df_order_docs, shape: {} x {}'.format(
        df_order_docs.count(), len(df_order_docs.columns)))


# In[41]:


# Display the first few rows of the df_customers Dataframe

display(df_customers.limit(3))


# In[42]:


# Display the first few rows of the df_order_docs Dataframe

display(df_order_docs.limit(3))


# In[43]:


# Create Narrower/Minimal Dataframes for the Join operation 

from pyspark.sql.functions import col

df_customers_minimal = df_customers.select(
    col('customerId'),
    col('name'))

print('df_customers_minimal, shape: {} x {}'.format(
        df_customers_minimal.count(), len(df_customers_minimal.columns)))
df_customers_minimal.printSchema()

df_orders_minimal = df_order_docs.select(
    col('orderId'),
    col('customerId'),
    col('item_count'),
    col('order_total'))

print('df_orders_minimal, shape: {} x {}'.format(
        df_orders_minimal.count(), len(df_orders_minimal.columns)))
df_orders_minimal.printSchema()


# In[51]:


# Join the (narrow) Customers to their (narrow) Order documents

df_joined = df_orders_minimal.join(df_customers_minimal, ['customerId'])     .sort("customerId", ascending=False)


print('df_joined, shape: {} x {}'.format(
        df_joined.count(), len(df_joined.columns)))
df_joined.printSchema()


# In[52]:


# Display the first few rows of the df_joined Dataframe

display(df_joined.limit(20))


# In[53]:


# Group the df_joined Dataframe by customerId, sum on order total and total_orders

df_grouped = df_joined.groupby("customerId")     .sum("order_total").alias('total_orders')     .sort("customerId", ascending=False)

display(df_grouped.printSchema())
print((df_grouped.count(), len(df_grouped.columns)))


# In[54]:


import pyspark.sql.functions as F 

df_agg = df_joined.groupBy("customerId")     .agg(
        F.count("customerId").alias('order_count'), \
        F.sum("order_total").alias("total_dollar_amount"), \
        F.sum("item_count").alias("total_item_count")) \
        .sort("customerId", ascending=False)

display(df_agg.printSchema())
print((df_agg.count(), len(df_agg.columns)))


# In[55]:


display(df_agg.limit(30))

