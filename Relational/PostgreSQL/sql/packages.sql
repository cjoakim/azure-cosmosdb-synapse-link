-- DDL to create the package_and_version table in the Azure PostgreSQL demo database.
-- Chris Joakim, Microsoft

drop table packages;

CREATE TABLE "packages" (
	"package_and_version" character varying(100) not null
);
