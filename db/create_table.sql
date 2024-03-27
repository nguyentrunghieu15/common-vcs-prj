CREATE DATABASE on_demand_services_db;

CREATE TYPE SEX AS ENUM ('male','female','another');

CREATE TYPE STATUS AS ENUM ('active','inactive');

CREATE TYPE RULES AS ENUM ('admin','supplier','consumer');
	
CREATE TABLE users (
	createAt TIMESTAMP with time zone,
	deleteAt TIMESTAMP with time zone,
	updateAt TIMESTAMP with time zone,
	createBy INT,
	deleteBy INT,
	updateBy INT,
	id SERIAL PRIMARY KEY,
	email varchar(255),
	password varchar(255),
	fullName varchar(255),
	birthDay date,
	gender SEX,
	address varchar(2000),
	status STATUS
);

CREATE TABLE rules_users (
	createAt TIMESTAMP with time zone,
	deleteAt TIMESTAMP with time zone,
	updateAt TIMESTAMP with time zone,
	createBy INT,
	deleteBy INT,
	updateBy INT,
	id SERIAL PRIMARY KEY,
	userId INT,
	rules RULES,
	foreign key (userId) references users (id)
);