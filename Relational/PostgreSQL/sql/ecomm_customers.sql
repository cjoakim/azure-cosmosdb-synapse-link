-- DDL to create the customers table in the Azure PostgreSQL demo database.
-- Chris Joakim, Microsoft, October 2021

-- customers
-- pk|customer_id|name|first|last|street|city|state|zip
-- 0074993967749|0074993967749|James Mccullough|James|Mccullough|057 Gray Parkways Suite 627|Lisaview|KY|90783

drop table customers;

CREATE TABLE "customers" (
	"pk"          character varying(80) not null,
	"customer_id" character varying(80) not null,
	"name"        character varying(80) not null,
	"first"       character varying(40) not null,
	"last"        character varying(40) not null,
	"street"      character varying(80) not null,
	"city"        character varying(40) not null,
	"state"       character varying(40) not null,
	"zip"         character varying(40) not null
);
