#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# https://docs.microsoft.com/en-us/azure/synapse-analytics/spark/apache-spark-development-using-notebooks?tabs=classical#bring-data-to-a-notebook

from pyspark.sql import SparkSession

# Azure Storage account and blob info:
blob_account_name = 'cjoakimstorage' # replace with your blob name
blob_container_name = 'synapse' # replace with your container name
blob_relative_path = 'usa-states.csv' # replace with your relative folder path
linked_service_name = 'cjoakimstorageAzureBlobStorage'

blob_sas_token = mssparkutils.credentials.getConnectionStringOrCreds(linked_service_name)
print('blob_sas_token: {}'.format(blob_sas_token))

wasb_path = 'wasbs://%s@%s.blob.core.windows.net/%s' % (blob_container_name, blob_account_name, blob_relative_path)

spark.conf.set('fs.azure.sas.%s.%s.blob.core.windows.net' % (blob_container_name, blob_account_name), blob_sas_token)
print('wasb_path: {}'.format(wasb_path))

df = spark.read.option("header", "true")             .option("delimiter","|")             .csv(wasb_path)

display(df.limit(10))


# In[ ]:



spark.conf.set("my.number", 42)


# In[ ]:


n = spark.conf.get("my.number")
print(n)


# In[ ]:


from pyspark.sql import SparkSession

# Azure Storage account and blob info:
blob_account_name = 'cjoakimstorage' # replace with your blob name
blob_container_name = 'synapse' # replace with your container name
blob_relative_path = 'usa-states-mod.csv' # replace with your relative folder path
linked_service_name = 'cjoakimstorageAzureBlobStorage'

blob_sas_token = mssparkutils.credentials.getConnectionStringOrCreds(linked_service_name)
print('blob_sas_token: {}'.format(blob_sas_token))

wasb_path = 'wasbs://%s@%s.blob.core.windows.net/%s' % (blob_container_name, blob_account_name, blob_relative_path)
print('wasb_path: {}'.format(wasb_path))

df.coalesce(1).write.csv(wasb_path, mode='overwrite', header='true')
print('df written to blob storage')

df2 = spark.read.option("header", "true")             .option("delimiter",",")             .csv(wasb_path)

display(df2.limit(100))


# In[ ]:





# In[ ]:




