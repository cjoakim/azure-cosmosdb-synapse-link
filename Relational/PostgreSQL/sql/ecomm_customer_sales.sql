-- DDL to create the customer_sales table in the Azure PostgreSQL
-- demo database.
-- Chris Joakim, Microsoft

drop table customer_sales;

CREATE TABLE "customer_sales" (
	"id"                  character varying(80) not null,
	"customer_id"         character varying(80) not null,
	"order_count"         integer not null,
	"total_dollar_amount" money,
	"total_item_count"    integer not null
);
