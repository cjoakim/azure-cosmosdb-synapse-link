-- DDL to create the customer_sales table in the Azure PostgreSQL
-- demo database.
-- Chris Joakim, Microsoft

-- The Aggregated Spark Dataframe used to load this table looks like this:
-- customer_id: integer (nullable = true)
-- id: integer (nullable = true)
-- pk: integer (nullable = true)
-- order_count: long (nullable = false)
-- total_dollar_amount: double (nullable = true)
-- total_item_count: long (nullable = true)

drop table customer_sales;

CREATE TABLE "customer_sales" (
	"customer_id"         integer not null,
	"id"                  integer,
	"pk"                  integer,
	"order_count"         integer,
	"total_dollar_amount" money,
	"total_item_count"    integer
);
