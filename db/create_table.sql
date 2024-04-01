-- CREATE DATABASE on_demand_services_db;

CREATE TYPE SEX AS ENUM ('male','female','another');

CREATE TYPE STATUS AS ENUM ('active','inactive');

CREATE TYPE RULES AS ENUM ('admin','supplier','consumer');

CREATE TABLE avatars (
    created_at TIMESTAMP with time zone,
    deleted_at TIMESTAMP with time zone,
    updated_at TIMESTAMP with time zone,
    created_by INT,
    deleted_by INT,
    updated_by INT,
    id SERIAL PRIMARY KEY,
    avatar_base64 TEXT
);

CREATE TABLE users (
    created_at TIMESTAMP with time zone,
    deleted_at TIMESTAMP with time zone,
    updated_at TIMESTAMP with time zone,
    created_by INT,
    deleted_by INT,
    updated_by INT,
    id SERIAL PRIMARY KEY,
    email VARCHAR(255),
    password VARCHAR(255),
    full_name VARCHAR(255),
    birth_day DATE,
    avatar_id INT,
    gender SEX,
    is_super_admin BOOLEAN,
    address VARCHAR(2000),
    status STATUS,
    FOREIGN KEY (avatar_id) REFERENCES avatars (id)
);

CREATE UNIQUE INDEX user_email_idx ON users(email);

CREATE TABLE rules_users (
    created_at TIMESTAMP with time zone,
    deleted_at TIMESTAMP with time zone,
    updated_at TIMESTAMP with time zone,
    created_by INT,
    deleted_by INT,
    updated_by INT,
    id SERIAL PRIMARY KEY,
    user_id INT,
    rules RULES,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE actions (
    created_at TIMESTAMP with time zone,
    deleted_at TIMESTAMP with time zone,
    updated_at TIMESTAMP with time zone,
    created_by INT,
    deleted_by INT,
    updated_by INT,
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    description TEXT
);

CREATE TABLE permission_actions(
    created_at TIMESTAMP with time zone,
    deleted_at TIMESTAMP with time zone,
    updated_at TIMESTAMP with time zone,
    created_by INT,
    deleted_by INT,
    updated_by INT,
    user_id INT,
    action_id INT,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (action_id) REFERENCES actions (id)
);

CREATE TABLE notification_settings (
    created_at TIMESTAMP with time zone,
    deleted_at TIMESTAMP with time zone,
    updated_at TIMESTAMP with time zone,
    created_by INT,
    deleted_by INT,
    updated_by INT,
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    description TEXT
);

CREATE TABLE notification_setting_users(
    created_at TIMESTAMP with time zone,
    deleted_at TIMESTAMP with time zone,
    updated_at TIMESTAMP with time zone,
    created_by INT,
    deleted_by INT,
    updated_by INT,
    user_id INT,
    notification_setting_id INT,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (notification_setting_id) REFERENCES notification_settings (id)
);

CREATE TABLE payment_methods(
    created_at TIMESTAMP with time zone,
    deleted_at TIMESTAMP with time zone,
    updated_at TIMESTAMP with time zone,
    created_by INT,
    deleted_by INT,
    updated_by INT,
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    description TEXT
);

CREATE TABLE user_payment_methods(
    created_at TIMESTAMP with time zone,
    deleted_at TIMESTAMP with time zone,
    updated_at TIMESTAMP with time zone,
    created_by INT,
    deleted_by INT,
    updated_by INT,
    user_id INT,
    payment_method_id INT,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods (id)
);

CREATE TABLE providers (
    created_at TIMESTAMP with time zone,
    deleted_at TIMESTAMP with time zone,
    updated_at TIMESTAMP with time zone,
    created_by INT,
    deleted_by INT,
    updated_by INT,
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    address VARCHAR(2000),
    status status,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE services (
    created_at TIMESTAMP with time zone,
    deleted_at TIMESTAMP with time zone,
    updated_at TIMESTAMP with time zone,
    created_by INT,
    deleted_by INT,
    updated_by INT,
    id SERIAL PRIMARY KEY,
    rate REAL,
    description TEXT,
    provider_id INT,
    FOREIGN KEY (provider_id) REFERENCES providers (id)
);

CREATE TABLE feedbacks(
    created_at TIMESTAMP with time zone,
    deleted_at TIMESTAMP with time zone,
    updated_at TIMESTAMP with time zone,
    created_by INT,
    deleted_by INT,
    updated_by INT,
    id SERIAL PRIMARY KEY,
    user_id INT,
    content TEXT,
    rate INT,
    FOREIGN KEY (user_id) REFERENCES users (id),
    service_id INT,
    FOREIGN KEY (service_id) REFERENCES services (id)
);



-- CREATE administrative_regions TABLE
CREATE TABLE administrative_regions (
	id integer NOT NULL,
	"name" varchar(255) NOT NULL,
	name_en varchar(255) NOT NULL,
	code_name varchar(255) NULL,
	code_name_en varchar(255) NULL,
	CONSTRAINT administrative_regions_pkey PRIMARY KEY (id)
);


-- CREATE administrative_units TABLE
CREATE TABLE administrative_units (
	id integer NOT NULL,
	full_name varchar(255) NULL,
	full_name_en varchar(255) NULL,
	short_name varchar(255) NULL,
	short_name_en varchar(255) NULL,
	code_name varchar(255) NULL,
	code_name_en varchar(255) NULL,
	CONSTRAINT administrative_units_pkey PRIMARY KEY (id)
);


-- CREATE provinces TABLE
CREATE TABLE provinces (
	code varchar(20) NOT NULL,
	"name" varchar(255) NOT NULL,
	name_en varchar(255) NULL,
	full_name varchar(255) NOT NULL,
	full_name_en varchar(255) NULL,
	code_name varchar(255) NULL,
	administrative_unit_id integer NULL,
	administrative_region_id integer NULL,
	CONSTRAINT provinces_pkey PRIMARY KEY (code)
);


-- provinces foreign keys

ALTER TABLE provinces ADD CONSTRAINT provinces_administrative_region_id_fkey FOREIGN KEY (administrative_region_id) REFERENCES administrative_regions(id);
ALTER TABLE provinces ADD CONSTRAINT provinces_administrative_unit_id_fkey FOREIGN KEY (administrative_unit_id) REFERENCES administrative_units(id);

CREATE INDEX idx_provinces_region ON provinces(administrative_region_id);
CREATE INDEX idx_provinces_unit ON provinces(administrative_unit_id);


-- CREATE districts TABLE
CREATE TABLE districts (
	code varchar(20) NOT NULL,
	"name" varchar(255) NOT NULL,
	name_en varchar(255) NULL,
	full_name varchar(255) NULL,
	full_name_en varchar(255) NULL,
	code_name varchar(255) NULL,
	province_code varchar(20) NULL,
	administrative_unit_id integer NULL,
	CONSTRAINT districts_pkey PRIMARY KEY (code)
);


-- districts foreign keys

ALTER TABLE districts ADD CONSTRAINT districts_administrative_unit_id_fkey FOREIGN KEY (administrative_unit_id) REFERENCES administrative_units(id);
ALTER TABLE districts ADD CONSTRAINT districts_province_code_fkey FOREIGN KEY (province_code) REFERENCES provinces(code);

CREATE INDEX idx_districts_province ON districts(province_code);
CREATE INDEX idx_districts_unit ON districts(administrative_unit_id);



-- CREATE wards TABLE
CREATE TABLE wards (
	code varchar(20) NOT NULL,
	"name" varchar(255) NOT NULL,
	name_en varchar(255) NULL,
	full_name varchar(255) NULL,
	full_name_en varchar(255) NULL,
	code_name varchar(255) NULL,
	district_code varchar(20) NULL,
	administrative_unit_id integer NULL,
	CONSTRAINT wards_pkey PRIMARY KEY (code)
);


-- wards foreign keys

ALTER TABLE wards ADD CONSTRAINT wards_administrative_unit_id_fkey FOREIGN KEY (administrative_unit_id) REFERENCES administrative_units(id);
ALTER TABLE wards ADD CONSTRAINT wards_district_code_fkey FOREIGN KEY (district_code) REFERENCES districts(code);

CREATE INDEX idx_wards_district ON wards(district_code);
CREATE INDEX idx_wards_unit ON wards(administrative_unit_id);