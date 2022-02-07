-- DDL to create the customer_sales table in the Azure PostgreSQL
-- demo database.
-- Chris Joakim, Microsoft, February 2022

-- The schema for the source DataFrame in Azure Synapse Spark looks like this:
-- root
--  |-- customer_id: integer (nullable = true)
--  |-- _id: integer (nullable = true)
--  |-- pk: integer (nullable = true)
--  |-- order_count: long (nullable = false)
--  |-- total_dollar_amount: double (nullable = true)
--  |-- total_item_count: long (nullable = true)

-- The data looks like this:
-- $ head part-00000-212e8938-3e37-4ae0-9075-8320e5e83adb-c000.csv
-- customer_id,_id,pk,order_count,total_dollar_amount,total_item_count
-- 1,1,1,1,4633.63,2
-- 2,2,2,5,9969.06,11
-- 3,3,3,6,27992.590000000004,17

drop table customer_sales;

CREATE TABLE "customer_sales" (
	"customer_id"         integer not null,
	"_id"                 character varying(80) not null,
	"pk"                  integer not null,
	"order_count"         integer not null,
	"total_dollar_amount" money,
	"total_item_count"    integer not null
);
