#!/usr/bin/env python
# coding: utf-8

# # Process the Customers vs Orders Synapse Link Data

# In[40]:


# Load the SynapseLink Customers data into a Dataframe

df_customers = spark.read    .format("cosmos.olap")    .option("spark.synapse.linkedService", "demoCosmosDB")    .option("spark.cosmos.container", "customers")    .load()
display(df_customers.limit(3))


# In[41]:


# Load the SynapseLink Orders data into a Dataframe

df_orders = spark.read    .format("cosmos.olap")    .option("spark.synapse.linkedService", "demoCosmosDB")    .option("spark.cosmos.container", "orders")    .load()
display(df_orders.limit(3))


# In[42]:


# Select just the doctype == 'orders' from the Orders Dataframe
# Exclude the line_item and delivery document types

df_order_docs = df_orders.filter(df_orders["doctype"].isin(["order"]))
display(df_order_docs.limit(3))


# In[43]:


# Display the Observed Schemas of the Dataframes

print('=== df_customers')
df_customers.printSchema()

print('=== df_orders')
df_orders.printSchema()

print('=== df_order_docs')
display(df_order_docs.printSchema())


# In[44]:


# Display the shapes of the Dataframes

print('df_customers:')
print((df_customers.count(), len(df_customers.columns)))

print('df_orders')
print((df_orders.count(), len(df_orders.columns)))

print('df_order_docs')
print((df_order_docs.count(), len(df_order_docs.columns)))


# In[45]:


# Join the Customers to the Order documents

df_joined = df_order_docs.join(df_customers, df_order_docs.customerId == df_customers.customerId, "inner")
display(df_joined.printSchema())
print((df_joined.count(), len(df_joined.columns)))

