## Users and Roles

By Default postgres created a superuser postgres

```
CREATE ROLE messi WITH
	LOGIN
	NOSUPERUSER
	CREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1
	VALID UNTIL '2025-08-19T00:00:00+05:30'
	PASSWORD 'xxxxxx';
```

DB Creation

```
CREATE DATABASE ainszon
    WITH
    OWNER = admin
    TEMPLATE = "France"
    ENCODING = 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE ainszon
    IS 'test db';
```

### Create Table

CREATE TABLE customers(
customer_id SERIAL PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(150),
age INT
)

### Fetch all table

`select * from customers`

### Insert into table

```
INSERT INTO customers(first_name,last_name,email,age)
VALUES ('Messi','lionel','messi@gmail.com',37),
VALUES ('Ronaldo','Cristiano','ronaldo@gmail.com',39)
RETURNING *

```

### Update Table

```
UPDATE customers
SET
	email = 'messi11@gmail.com',
	first_name = 'lionel'
where customer_id = 2 -- single record

UPDATE customers
SET
    is_enable = 'Y' -- ALL records
```

### Delete records in table

```
DELETE FROM customers
where customer _id = 1 -- single record


DELETE FROM customers -- All records

```

### QUERY

#### Order By

```
select * from user
order by first_name asc NULLS LAST

select * from user
order by first_name desc NULLS FIRST
```

```
select * from movies
release_date asc
movie_name desc

combination of two columns
```
