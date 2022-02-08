-- DDL to create the orders table in the Azure PostgreSQL demo database.
-- Chris Joakim, Microsoft

-- orders
-- pk|doctype|order_id|customer_id|order_date|item_count|version|order_total|delivery_count
-- 9e94bf8e-203e-42ce-bfef-b0e8c12a36f1|order|9e94bf8e-203e-42ce-bfef-b0e8c12a36f1|0021038058139|2021-01-19|3|v2|211.28|1

drop table orders;

CREATE TABLE "orders" (
	"pk"             character varying(80) not null,
	"doctype"        character varying(20) not null,
	"order_id"       character varying(80) not null,
	"customer_id"    character varying(80) not null,
	"order_date"     character varying(10) not null,
	"item_count"     integer not null,
	"version"        character varying(8)  not null,
	"order_total"    money,
	"delivery_count" integer not null
);
