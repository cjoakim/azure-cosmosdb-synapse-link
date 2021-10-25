-- DDL to create the customer_sales table in the Azure PostgreSQL demo database.
-- Chris Joakim, Microsoft, October 2021

-- customer_id,id,order_count,total_dollar_amount,total_item_count
-- 0099999951721,402e3211-1ec8-45dd-818d-7c563574e1de,4,527.05,9

drop table customer_sales;

CREATE TABLE "customer_sales" (
	"customer_id"         character varying(80) not null,
	"id"                  character varying(80) not null,
	"order_count"         integer not null,
	"total_dollar_amount" money,
	"total_item_count"    integer not null
);
