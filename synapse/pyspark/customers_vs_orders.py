#!/usr/bin/env python
# coding: utf-8

# # Process the Customers vs Orders Synapse Link Data

# ## Load the SynapseLink Customers data into a Dataframe

# In[ ]:


df_customers = spark.read    .format("cosmos.olap")    .option("spark.synapse.linkedService", "demoCosmosDB")    .option("spark.cosmos.container", "customers")    .load()

display(df_customers.limit(10))


# 

# ## Load the SynapseLink Orders data into a Dataframe

# In[ ]:



df_orders = spark.read    .format("cosmos.olap")    .option("spark.synapse.linkedService", "demoCosmosDB")    .option("spark.cosmos.container", "orders")    .load()

display(df_orders.limit(10))


# ## Display the Observed Schemas of the Dataframes

# In[ ]:


display('=== df_customers')
display(df_customers.printSchema())

display('=== df_orders')
display(df_orders.printSchema())


# ## Select just the doctype == 'orders' from the Orders Dataframe
# 
# Exclude the line_item and delivery document types

# In[ ]:


df_order_docs = df_orders.filter(df_orders["doctype"].isin(["order"]))
display(df_order_docs.limit(10))
display(df_order_docs.printSchema())


# 
