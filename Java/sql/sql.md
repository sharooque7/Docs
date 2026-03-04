# Complete SQL - The Ultimate Interview Guide 📊

*Your comprehensive go-to reference for all SQL concepts with brief explanations and code examples*

---

## **📋 TABLE OF CONTENTS**

1. [What is SQL?](#1-what-is-sql)
2. [SQL vs NoSQL](#2-sql-vs-nosql)
3. [SQL Command Categories](#3-sql-command-categories)
4. [Data Types](#4-data-types)
5. [Constraints](#5-constraints)
6. [Keys in SQL](#6-keys-in-sql)
7. [Basic Queries](#7-basic-queries)
8. [WHERE Clause and Operators](#8-where-clause-and-operators)
9. [Joins](#9-joins)
10. [Set Operations](#10-set-operations)
11. [Aggregation and Grouping](#11-aggregation-and-grouping)
12. [HAVING vs WHERE](#12-having-vs-where)
13. [Subqueries](#13-subqueries)
14. [Window Functions](#14-window-functions)
15. [Common Table Expressions (CTEs)](#15-common-table-expressions-ctes)
16. [Recursive CTEs](#16-recursive-ctes)
17. [Indexes](#17-indexes)
18. [Views](#18-views)
19. [Stored Procedures](#19-stored-procedures)
20. [Triggers](#20-triggers)
21. [Functions](#21-functions)
22. [Transactions and ACID](#22-transactions-and-acid)
23. [Normalization](#23-normalization)
24. [Denormalization](#24-denormalization)
25. [Query Optimization](#25-query-optimization)
26. [Execution Plan](#26-execution-plan)
27. [Common Patterns](#27-common-patterns)
28. [Interview Questions](#28-interview-questions)
29. [Quick Reference Cheat Sheet](#29-quick-reference-cheat-sheet)

---

## **1. WHAT IS SQL?**

> **Concept:** SQL (Structured Query Language) is the industry-standard language for managing and querying relational databases. It enables storing, retrieving, and analyzing structured data efficiently .

```sql
-- Basic SQL query example
SELECT first_name, last_name, salary
FROM employees
WHERE department = 'Sales'
ORDER BY salary DESC
LIMIT 10;
```

**Why SQL Matters:**
- **Universal compatibility** – Works across MySQL, PostgreSQL, SQL Server, Oracle 
- **Declarative** – You specify what data you need, not how to get it 
- **Scalability** – Handles millions of transactions in banking, billions of records in social media 
- **72% of developers use SQL daily** 

---

## **2. SQL vs NOSQL**

| Feature | SQL Databases | NoSQL Databases |
|---------|---------------|-----------------|
| **Data Model** | Tables with rows and columns | Document, key-value, graph, column-family |
| **Schema** | Fixed schema, predefined structure | Dynamic schema, flexible |
| **Relationships** | Foreign keys, joins | Embedded documents, references |
| **ACID** | Strong ACID compliance | BASE (Basically Available, Soft state, Eventually consistent) |
| **Scaling** | Vertical scaling (more power) | Horizontal scaling (more servers) |
| **Examples** | MySQL, PostgreSQL, Oracle, SQL Server | MongoDB, Cassandra, Redis, Neo4j |

```sql
-- SQL: Structured, related tables
CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- NoSQL (MongoDB): Embedded document
-- {
--   "_id": 1,
--   "customer": {
--     "name": "John Doe",
--     "email": "john@example.com"
--   },
--   "items": [
--     {"product": "laptop", "qty": 1}
--   ]
-- }
```

---

## **3. SQL COMMAND CATEGORIES**

> **Concept:** SQL commands are grouped into five categories based on their purpose .

| Category | Purpose | Example Commands |
|----------|---------|------------------|
| **DDL (Data Definition Language)** | Defines database structure | `CREATE`, `ALTER`, `DROP`, `TRUNCATE` |
| **DML (Data Manipulation Language)** | Handles data within tables | `INSERT`, `UPDATE`, `DELETE` |
| **DQL (Data Query Language)** | Fetches data | `SELECT` |
| **DCL (Data Control Language)** | Manages user permissions | `GRANT`, `REVOKE` |
| **TCL (Transaction Control Language)** | Ensures data consistency | `BEGIN`, `COMMIT`, `ROLLBACK`, `SAVEPOINT` |

```sql
-- DDL: Create table structure
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10,2)
);

-- DML: Insert data
INSERT INTO employees (id, name, salary) VALUES (1, 'Alice', 60000);

-- DQL: Query data
SELECT * FROM employees WHERE salary > 50000;

-- TCL: Transaction control
BEGIN TRANSACTION;
UPDATE employees SET salary = 65000 WHERE id = 1;
COMMIT;
```

### **DELETE vs TRUNCATE vs DROP**

| Command | Category | What it does | Can rollback? | Speed |
|---------|----------|--------------|---------------|-------|
| **DELETE** | DML | Removes rows one by one | Yes (with transaction) | Slow |
| **TRUNCATE** | DDL | Removes all rows, resets table | No | Fast |
| **DROP** | DDL | Removes entire table structure | No | Fastest |

```sql
-- DELETE - removes rows, can have WHERE clause
DELETE FROM employees WHERE department = 'Temp';

-- TRUNCATE - removes all rows, faster
TRUNCATE TABLE temp_employees;

-- DROP - removes entire table
DROP TABLE old_employees;
```

---

## **4. DATA TYPES**

> **Concept:** SQL databases categorize data into distinct types for efficient storage and retrieval .

### **Common Data Types Across Databases **

| Category | Data Type | Description | Example |
|----------|-----------|-------------|---------|
| **Numeric** | `INT`, `BIGINT`, `SMALLINT` | Whole numbers | `age INT` |
| | `DECIMAL(p,s)`, `NUMERIC` | Precise decimal numbers | `price DECIMAL(10,2)` |
| | `FLOAT`, `REAL` | Approximate floating-point | `rating FLOAT` |
| **String** | `CHAR(n)` | Fixed-length string | `code CHAR(10)` |
| | `VARCHAR(n)` | Variable-length string | `name VARCHAR(50)` |
| | `TEXT` | Long text | `description TEXT` |
| **Date/Time** | `DATE` | Date only | `birth_date DATE` |
| | `TIME` | Time only | `start_time TIME` |
| | `DATETIME`, `TIMESTAMP` | Date and time | `created_at TIMESTAMP` |
| **Boolean** | `BOOLEAN` | True/false | `is_active BOOLEAN` |
| **Binary** | `BLOB`, `BINARY` | Binary data | `image BLOB` |

### **CHAR vs VARCHAR **

| Feature | CHAR | VARCHAR |
|---------|------|---------|
| **Storage** | Fixed-length | Variable-length |
| **Performance** | Faster for fixed-size data | More efficient for variable text |
| **Example** | `CHAR(10)` always stores 10 chars | `VARCHAR(10)` stores up to 10 chars |
| **Use when** | All values same length (codes, flags) | Variable text (names, addresses) |

```sql
CREATE TABLE products (
    product_code CHAR(8),      -- Fixed: ALWAYS 8 characters
    product_name VARCHAR(100),  -- Variable: up to 100 characters
    price DECIMAL(10,2),        -- 10 total digits, 2 after decimal
    created_at TIMESTAMP
);
```

---

## **5. CONSTRAINTS**

> **Concept:** Rules that limit the type of data that can go into a table to ensure data integrity .

| Constraint | Description | Example |
|------------|-------------|---------|
| **NOT NULL** | Column cannot have NULL values | `name VARCHAR(100) NOT NULL` |
| **UNIQUE** | All values in column must be different | `email VARCHAR(100) UNIQUE` |
| **PRIMARY KEY** | Uniquely identifies each row | `id INT PRIMARY KEY` |
| **FOREIGN KEY** | Links to another table | `FOREIGN KEY (dept_id) REFERENCES dept(id)` |
| **CHECK** | Validates values based on condition | `CHECK (age >= 18)` |
| **DEFAULT** | Sets default value if none provided | `status VARCHAR(20) DEFAULT 'active'` |

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(200) NOT NULL,
    age INT CHECK (age >= 18 AND age <= 65),
    department_id INT,
    salary DECIMAL(10,2) DEFAULT 50000,
    hire_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);
```

---

## **6. KEYS IN SQL**

> **Concept:** Keys define table relationships and ensure data integrity .

| Key Type | Purpose | Characteristics | Example |
|----------|---------|-----------------|---------|
| **Primary Key** | Uniquely identifies each row | NOT NULL, UNIQUE, one per table | `employee_id` |
| **Foreign Key** | Links to another table | References PK in another table | `dept_id` referencing `departments.id` |
| **Unique Key** | Ensures column values are unique | Allows NULL (one NULL allowed), multiple per table | `email`, `ssn` |
| **Composite Key** | Key using multiple columns | Combination must be unique | `(order_id, product_id)` |

```sql
-- Primary Key
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

-- Foreign Key
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Composite Primary Key
CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Unique Key
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    email VARCHAR(100) UNIQUE
);
```

---

## **7. BASIC QUERIES**

> **Concept:** Fundamental SQL statements for data retrieval .

### **SELECT Syntax**
```sql
SELECT column1, column2, ...
FROM table_name
WHERE condition
GROUP BY column
HAVING condition
ORDER BY column ASC|DESC
LIMIT n;
```

### **Basic Examples **
```sql
-- Retrieve all records
SELECT * FROM employees;

-- Retrieve specific columns
SELECT first_name, last_name, salary FROM employees;

-- Retrieve with filter
SELECT first_name, last_name 
FROM employees 
WHERE department = 'Finance';

-- Sort results
SELECT first_name, salary 
FROM employees 
ORDER BY salary DESC;

-- Limit results
SELECT * FROM employees LIMIT 5;
-- SQL Server alternative: SELECT TOP 5 * FROM employees;

-- Distinct values
SELECT DISTINCT department FROM employees;

-- Alias
SELECT first_name AS "First Name", salary AS "Monthly Salary"
FROM employees;
```

---

## **8. WHERE CLAUSE AND OPERATORS**

> **Concept:** WHERE clause filters records before aggregation .

### **Comparison Operators **

| Operator | Meaning | Example |
|----------|---------|---------|
| `=` | Equal to | `WHERE age = 25` |
| `<>` or `!=` | Not equal to | `WHERE status != 'inactive'` |
| `>` | Greater than | `WHERE salary > 50000` |
| `<` | Less than | `WHERE age < 65` |
| `>=` | Greater than or equal | `WHERE price >= 100` |
| `<=` | Less than or equal | `WHERE quantity <= 0` |

### **Logical Operators **

| Operator | Meaning | Example |
|----------|---------|---------|
| `AND` | Both conditions true | `WHERE age > 25 AND salary > 50000` |
| `OR` | Either condition true | `WHERE dept = 'Sales' OR dept = 'Marketing'` |
| `NOT` | Negates condition | `WHERE NOT status = 'inactive'` |
| `&&` | AND alternative (MySQL) | `WHERE age > 25 && salary > 50000` |
| `||` | OR alternative (MySQL) | `WHERE dept = 'Sales' || dept = 'Marketing'` |
| `!` | NOT alternative (MySQL) | `WHERE !status = 'inactive'` |

### **Special Operators**

```sql
-- BETWEEN - range check
SELECT * FROM employees WHERE salary BETWEEN 40000 AND 60000;

-- IN - list check
SELECT * FROM employees WHERE department IN ('Sales', 'IT', 'HR');

-- LIKE - pattern matching
-- % = any characters, _ = single character
SELECT * FROM employees WHERE last_name LIKE 'S%';     -- Starts with S
SELECT * FROM employees WHERE email LIKE '%@gmail.com'; -- Ends with @gmail.com
SELECT * FROM employees WHERE first_name LIKE 'J_';     -- J followed by 1 char

-- IS NULL / IS NOT NULL
SELECT * FROM employees WHERE manager_id IS NULL;

-- EXISTS
SELECT * FROM departments d
WHERE EXISTS (SELECT 1 FROM employees e WHERE e.dept_id = d.id);
```

---

## **9. JOINS**

> **Concept:** Joins combine data from two or more tables based on related columns .

### **Join Types Visualized**

```
INNER JOIN:      LEFT JOIN:       RIGHT JOIN:       FULL JOIN:
┌─────┐          ┌─────┐           ┌─────┐           ┌─────┐
│  A  │          │  A  │           │  A  │           │  A  │
│  ∩  │          │  ∩  │           │  ∩  │           │  ∩  │
│  B  │          │  B  │           │  B  │           │  B  │
└─────┘          └─────┘           └─────┘           └─────┘
```

### **INNER JOIN **
> Returns only matching rows from both tables.

```sql
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.id;
-- Returns only employees with valid department IDs
```

### **LEFT JOIN (LEFT OUTER JOIN) **
> Returns all rows from left table, matching rows from right. Non-matches show as NULL.

```sql
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.id;
-- Returns ALL employees, even those without departments
```

### **RIGHT JOIN (RIGHT OUTER JOIN) **
> Returns all rows from right table, matching rows from left. Non-matches show as NULL.

```sql
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.id;
-- Returns ALL departments, even those without employees
```

### **FULL OUTER JOIN**
> Returns all rows from both tables. Non-matches show as NULL.

```sql
SELECT e.first_name, e.last_name, d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.id;
-- Returns all employees and all departments
```

### **CROSS JOIN**
> Returns Cartesian product (every row from table1 paired with every row from table2).

```sql
SELECT e.first_name, p.project_name
FROM employees e
CROSS JOIN projects p;
-- If 10 employees and 5 projects → 50 rows
```

### **SELF JOIN**
> Joining a table with itself .

```sql
-- Find employees and their managers (manager is also in employees table)
SELECT e1.first_name AS employee, e2.first_name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.id;
```

### **Common Interview Question **
**Q: What's the difference between INNER JOIN and LEFT JOIN?**
- **INNER JOIN** only returns matches found in both tables
- **LEFT JOIN** returns all rows from left table, even with no match

```sql
-- Albums without tracks (using LEFT JOIN)
SELECT a.title
FROM albums a
LEFT JOIN tracks t ON a.id = t.album_id
WHERE t.id IS NULL;
```

---

## **10. SET OPERATIONS**

> **Concept:** Combine results of multiple SELECT statements .

| Operator | Description | Duplicates |
|----------|-------------|------------|
| **UNION** | Combines results, removes duplicates | No duplicates |
| **UNION ALL** | Combines results, keeps all rows | Includes duplicates |
| **INTERSECT** | Returns rows common to both queries | No duplicates |
| **EXCEPT / MINUS** | Returns rows in first query not in second | No duplicates |

```sql
-- UNION (removes duplicates)
SELECT city FROM customers
UNION
SELECT city FROM suppliers;

-- UNION ALL (keeps duplicates, faster)
SELECT city FROM customers
UNION ALL
SELECT city FROM suppliers;

-- INTERSECT (common cities)
SELECT city FROM customers
INTERSECT
SELECT city FROM suppliers;

-- EXCEPT (cities with customers but no suppliers)
SELECT city FROM customers
EXCEPT
SELECT city FROM suppliers;
```

**Rules for Set Operations :**
- Same number of columns in all SELECT statements
- Corresponding columns must have compatible data types
- ORDER BY goes at the very end

---

## **11. AGGREGATION AND GROUPING**

> **Concept:** Aggregate functions perform calculations on multiple rows, returning a single summary value .

### **Aggregate Functions **

| Function | Description | Example |
|----------|-------------|---------|
| **COUNT(*)** | Counts all rows | `COUNT(*)` |
| **COUNT(column)** | Counts non-NULL values | `COUNT(email)` |
| **SUM(column)** | Sums values | `SUM(salary)` |
| **AVG(column)** | Average value | `AVG(salary)` |
| **MIN(column)** | Minimum value | `MIN(salary)` |
| **MAX(column)** | Maximum value | `MAX(salary)` |

```sql
-- Basic aggregation
SELECT 
    COUNT(*) AS total_employees,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    SUM(salary) AS total_payroll
FROM employees;
```

### **GROUP BY **
> Groups rows that have the same values in specified columns.

```sql
-- Total salary per department
SELECT 
    department_id,
    COUNT(*) AS emp_count,
    SUM(salary) AS total_salary,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id;

-- Multiple columns grouping
SELECT 
    department_id,
    job_title,
    COUNT(*) AS count
FROM employees
GROUP BY department_id, job_title;
```

### **Common Interview Patterns **

**1. Top N per Group (MOST ASKED)**
```sql
-- Top 3 highest-paid employees per department
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS rn
    FROM employees
) t
WHERE rn <= 3;
```

**2. Running Totals **
```sql
SELECT
    order_date,
    SUM(amount) OVER (
        ORDER BY order_date
    ) AS running_total
FROM orders;
```

**3. Latest Record per User **
```sql
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY user_id
               ORDER BY activity_date DESC
           ) AS rn
    FROM user_activity
) t
WHERE rn = 1;
```

---

## **12. HAVING vs WHERE**

> **Concept:** WHERE filters rows before aggregation; HAVING filters groups after aggregation .

| Clause | When it applies | Can use aggregate functions |
|--------|-----------------|----------------------------|
| **WHERE** | Before GROUP BY | ❌ No |
| **HAVING** | After GROUP BY | ✅ Yes |

```sql
-- WHERE filters individual rows
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
WHERE hire_date > '2020-01-01'  -- Filters rows first
GROUP BY department_id;

-- HAVING filters groups
SELECT department_id, AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 60000;  -- Filters departments after aggregation

-- Combined
SELECT department_id, 
       COUNT(*) AS emp_count,
       AVG(salary) AS avg_salary
FROM employees
WHERE hire_date > '2020-01-01'        -- Filter rows
GROUP BY department_id
HAVING AVG(salary) > 50000            -- Filter groups
ORDER BY avg_salary DESC;
```

**Execution Order :**
1. FROM (get tables)
2. WHERE (filter rows)
3. GROUP BY (group rows)
4. HAVING (filter groups)
5. SELECT (select columns)
6. ORDER BY (sort results)
7. LIMIT (limit output)

---

## **13. SUBQUERIES**

> **Concept:** A query nested inside another query .

### **Types of Subqueries **

| Type | Description | Returns |
|------|-------------|---------|
| **Scalar** | Returns single value | One row, one column |
| **Multi-row** | Returns multiple values | Multiple rows, one column |
| **Correlated** | References outer query | Varies |

### **1. Scalar Subquery**
```sql
-- Find employees earning more than average
SELECT first_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Use in SELECT
SELECT 
    first_name,
    salary,
    (SELECT AVG(salary) FROM employees) AS company_avg
FROM employees;
```

### **2. Multi-row Subquery**
```sql
-- IN operator
SELECT first_name, department_id
FROM employees
WHERE department_id IN (
    SELECT id FROM departments WHERE location = 'New York'
);

-- ANY/SOME operator 
SELECT first_name, salary
FROM employees
WHERE salary > ANY (
    SELECT salary FROM employees WHERE department_id = 10
);
-- Returns true if > ANY salary in dept 10 (i.e., > the minimum)

-- ALL operator
SELECT first_name, salary
FROM employees
WHERE salary > ALL (
    SELECT salary FROM employees WHERE department_id = 10
);
-- Returns true if > ALL salaries in dept 10 (i.e., > the maximum)
```

### **3. Correlated Subquery**
```sql
-- Employees earning above their department's average
SELECT e1.first_name, e1.salary, e1.department_id
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id  -- Correlated
);

-- EXISTS operator 
SELECT d.department_name
FROM departments d
WHERE EXISTS (
    SELECT 1 FROM employees e 
    WHERE e.department_id = d.id AND e.salary > 100000
);
```

### **Subquery Operators **

| Operator | Description | Example |
|----------|-------------|---------|
| **IN** | Value in list | `WHERE id IN (SELECT id FROM ...)` |
| **ANY/SOME** | True if any subquery value satisfies condition | `WHERE salary > ANY (SELECT ...)` |
| **ALL** | True if all subquery values satisfy condition | `WHERE salary > ALL (SELECT ...)` |
| **EXISTS** | True if subquery returns any rows | `WHERE EXISTS (SELECT 1 FROM ...)` |

---

## **14. WINDOW FUNCTIONS**

> **Concept:** Perform calculations across rows while retaining individual row data .

### **Syntax**
```sql
function_name([columns]) OVER (
    [PARTITION BY column_list]
    [ORDER BY column_list]
    [frame_clause]
)
```

### **Ranking Functions **

| Function | Description | Ties |
|----------|-------------|------|
| **ROW_NUMBER()** | Sequential number (1,2,3,4) | Different numbers for ties |
| **RANK()** | Rank with gaps (1,2,2,4) | Same rank for ties, then skip |
| **DENSE_RANK()** | Rank without gaps (1,2,2,3) | Same rank for ties, no skip |

```sql
SELECT 
    first_name,
    salary,
    department_id,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
    RANK() OVER (ORDER BY salary DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank,
    ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS in_dept
FROM employees;
```

### **Aggregate Window Functions**
```sql
SELECT 
    first_name,
    salary,
    department_id,
    AVG(salary) OVER (PARTITION BY department_id) AS dept_avg,
    MAX(salary) OVER (PARTITION BY department_id) AS dept_max,
    MIN(salary) OVER (PARTITION BY department_id) AS dept_min,
    SUM(salary) OVER (PARTITION BY department_id) AS dept_total,
    salary - AVG(salary) OVER (PARTITION BY department_id) AS diff_from_avg
FROM employees;
```

### **Running Totals and Moving Averages **
```sql
-- Running total
SELECT 
    order_date,
    amount,
    SUM(amount) OVER (ORDER BY order_date) AS running_total
FROM orders;

-- Moving average (last 3 orders)
SELECT 
    order_date,
    amount,
    AVG(amount) OVER (ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) 
        AS moving_avg_3
FROM orders;

-- Reset per group
SELECT 
    customer_id,
    order_date,
    amount,
    SUM(amount) OVER (PARTITION BY customer_id ORDER BY order_date) 
        AS customer_running_total
FROM orders;
```

### **Lead and Lag**
```sql
-- Compare with previous/next rows
SELECT 
    order_date,
    amount,
    LAG(amount, 1) OVER (ORDER BY order_date) AS prev_amount,
    amount - LAG(amount, 1) OVER (ORDER BY order_date) AS diff_from_prev,
    LEAD(amount, 1) OVER (ORDER BY order_date) AS next_amount
FROM orders;
```

### **NTILE**
```sql
-- Divide into quartiles
SELECT 
    first_name,
    salary,
    NTILE(4) OVER (ORDER BY salary) AS salary_quartile
FROM employees;
```

---

## **15. COMMON TABLE EXPRESSIONS (CTEs)**

> **Concept:** CTEs create temporary result sets that can be referenced within a query .

### **Basic CTE**
```sql
WITH high_earners AS (
    SELECT first_name, last_name, salary
    FROM employees
    WHERE salary > 70000
)
SELECT * FROM high_earners ORDER BY salary DESC;
```

### **Multiple CTEs**
```sql
WITH 
dept_stats AS (
    SELECT 
        department_id,
        AVG(salary) AS avg_salary,
        COUNT(*) AS emp_count
    FROM employees
    GROUP BY department_id
),
company_stats AS (
    SELECT 
        AVG(salary) AS company_avg
    FROM employees
)
SELECT 
    d.department_name,
    ds.emp_count,
    ds.avg_salary,
    cs.company_avg,
    ds.avg_salary - cs.company_avg AS diff_from_company
FROM dept_stats ds
CROSS JOIN company_stats cs
JOIN departments d ON ds.department_id = d.id;
```

### **CTE for Clean Code **
```sql
-- Complex query broken into readable steps
WITH 
customer_totals AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
),
qualified_customers AS (
    SELECT *
    FROM customer_totals
    WHERE total_spent > 1000
)
SELECT 
    c.first_name,
    c.last_name,
    qc.total_spent
FROM qualified_customers qc
JOIN customers c ON qc.customer_id = c.id
ORDER BY qc.total_spent DESC;
```

---

## **16. RECURSIVE CTEs**

> **Concept:** CTEs that call themselves to handle hierarchical data .

```sql
-- Find employee hierarchy (who reports to whom)
WITH RECURSIVE emp_hierarchy AS (
    -- Anchor: start with CEO
    SELECT id, first_name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive: add direct reports
    SELECT e.id, e.first_name, e.manager_id, h.level + 1
    FROM employees e
    JOIN emp_hierarchy h ON e.manager_id = h.id
)
SELECT 
    level,
    CONCAT(REPEAT('  ', level - 1), first_name) AS name
FROM emp_hierarchy
ORDER BY level, first_name;

-- Generate number series (1 to 10)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;
```

---

## **17. INDEXES**

> **Concept:** Special lookup tables that speed up data retrieval .

### **Index Types **

| Type | Description | Characteristics |
|------|-------------|-----------------|
| **Clustered Index** | Sorts and stores data rows | One per table, physical order |
| **Non-Clustered Index** | Separate structure pointing to data | Multiple per table |

```sql
-- Create index
CREATE INDEX idx_emp_salary ON employees(salary);

-- Unique index
CREATE UNIQUE INDEX idx_emp_email ON employees(email);

-- Composite index
CREATE INDEX idx_emp_dept_salary ON employees(department_id, salary);

-- Drop index
DROP INDEX idx_emp_salary ON employees;

-- Clustered index (SQL Server)
CREATE CLUSTERED INDEX idx_emp_id ON employees(id);
-- In MySQL, PRIMARY KEY is clustered by default
```

### **When to Use Indexes**
- **Good for**: Frequently searched columns, JOIN columns, WHERE clause columns
- **Avoid on**: Small tables, frequently updated columns, low-cardinality columns

### **Index Impact**
```sql
-- Without index (table scan) - slow
SELECT * FROM employees WHERE last_name = 'Smith';

-- With index - fast
-- Index on last_name speeds up this query dramatically
```

---

## **18. VIEWS**

> **Concept:** Virtual tables based on the result of a SELECT query .

### **Regular View**
```sql
-- Create view
CREATE VIEW sales_summary AS
SELECT 
    p.category,
    DATE_TRUNC('month', o.order_date) AS month,
    SUM(oi.quantity * oi.price) AS total_sales,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
GROUP BY p.category, DATE_TRUNC('month', o.order_date);

-- Use view
SELECT * FROM sales_summary 
WHERE category = 'Electronics' 
ORDER BY month DESC;

-- Drop view
DROP VIEW sales_summary;
```

### **Materialized View**
> Physical copy of query result (refreshed periodically).

```sql
-- PostgreSQL
CREATE MATERIALIZED VIEW mv_sales_summary AS
SELECT 
    category,
    SUM(amount) AS total_sales
FROM orders
GROUP BY category;

-- Refresh
REFRESH MATERIALIZED VIEW mv_sales_summary;
```

**Benefits :**
- Security (hide sensitive columns)
- Simplicity (complex queries encapsulated)
- Consistency (standardized calculations)

---

## **19. STORED PROCEDURES**

> **Concept:** Pre-compiled SQL code that can be executed repeatedly .

```sql
-- MySQL example
DELIMITER //
CREATE PROCEDURE GetEmployeesByDept(IN dept_id INT, OUT emp_count INT)
BEGIN
    SELECT * FROM employees WHERE department_id = dept_id;
    
    SELECT COUNT(*) INTO emp_count 
    FROM employees 
    WHERE department_id = dept_id;
END //
DELIMITER ;

-- Call procedure
CALL GetEmployeesByDept(10, @count);
SELECT @count;

-- SQL Server example
CREATE PROCEDURE GetEmployeeSalary
    @EmployeeID INT,
    @Salary DECIMAL OUTPUT
AS
BEGIN
    SELECT @Salary = salary 
    FROM employees 
    WHERE id = @EmployeeID;
    
    SELECT * FROM employees WHERE id = @EmployeeID;
END;

-- Execute
DECLARE @sal DECIMAL;
EXEC GetEmployeeSalary @EmployeeID = 1, @Salary = @sal OUTPUT;
PRINT @sal;
```

**Benefits:**
- Reusability
- Performance (pre-compiled)
- Security (users can execute without table access)
- Reduced network traffic

---

## **20. TRIGGERS**

> **Concept:** Stored procedures that automatically execute when specific events occur .

```sql
-- MySQL trigger example
DELIMITER //
CREATE TRIGGER before_employee_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    -- Auto-generate employee ID
    SET NEW.id = UUID_SHORT();
    
    -- Set created timestamp
    SET NEW.created_at = NOW();
    
    -- Validate email
    IF NEW.email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Invalid email format';
    END IF;
END //
DELIMITER ;

-- Audit log trigger
CREATE TRIGGER after_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.salary != NEW.salary THEN
        INSERT INTO salary_audit (employee_id, old_salary, new_salary, changed_at)
        VALUES (NEW.id, OLD.salary, NEW.salary, NOW());
    END IF;
END;
```

### **Trigger Types **
- **BEFORE / AFTER**: When trigger executes
- **INSERT / UPDATE / DELETE**: Event that fires trigger
- **ROW / STATEMENT**: How many times trigger runs

---

## **21. FUNCTIONS**

> **Concept:** Reusable blocks that return a single value.

### **Scalar Functions**
```sql
-- MySQL function
DELIMITER //
CREATE FUNCTION CalculateBonus(salary DECIMAL)
RETURNS DECIMAL
DETERMINISTIC
BEGIN
    DECLARE bonus DECIMAL;
    
    IF salary > 100000 THEN
        SET bonus = salary * 0.2;
    ELSEIF salary > 50000 THEN
        SET bonus = salary * 0.15;
    ELSE
        SET bonus = salary * 0.1;
    END IF;
    
    RETURN bonus;
END //
DELIMITER ;

-- Use function
SELECT 
    first_name,
    salary,
    CalculateBonus(salary) AS bonus
FROM employees;
```

### **Table-Valued Functions**
```sql
-- SQL Server inline table function
CREATE FUNCTION GetTopEmployees(@n INT)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP(@n) first_name, salary
    FROM employees
    ORDER BY salary DESC
);

-- Use
SELECT * FROM GetTopEmployees(5);
```

---

## **22. TRANSACTIONS AND ACID**

> **Concept:** A transaction is a unit of work that must be executed completely or not at all .

### **ACID Properties **

| Property | Description | Example |
|----------|-------------|---------|
| **Atomicity** | All or nothing | Transfer either completes fully or fails fully |
| **Consistency** | Data integrity maintained | Account balances must sum to same total |
| **Isolation** | Concurrent transactions don't interfere | Two transfers don't interfere |
| **Durability** | Committed changes persist | Survives system failure |

### **Transaction Control **
```sql
-- Start transaction
BEGIN TRANSACTION;
-- or START TRANSACTION; (MySQL)

-- Money transfer example
BEGIN TRANSACTION;

UPDATE accounts SET balance = balance - 500 WHERE id = 1;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;

-- Check if everything is OK
-- If yes:
COMMIT;  -- Make permanent

-- If error:
ROLLBACK;  -- Undo all changes

-- Savepoints (partial rollback)
BEGIN TRANSACTION;
INSERT INTO log_table(message) VALUES('Process started');

SAVEPOINT sp1;
UPDATE accounts SET balance = balance - 500 WHERE id = 1;

SAVEPOINT sp2;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;

-- Something went wrong, rollback to sp1
ROLLBACK TO SAVEPOINT sp1;
COMMIT;  -- Commits only the log entry
```

### **Isolation Levels **
| Level | Dirty Read | Non-repeatable Read | Phantom Read |
|-------|------------|---------------------|--------------|
| **READ UNCOMMITTED** | Possible | Possible | Possible |
| **READ COMMITTED** | Not possible | Possible | Possible |
| **REPEATABLE READ** | Not possible | Not possible | Possible |
| **SERIALIZABLE** | Not possible | Not possible | Not possible |

```sql
-- Set isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
-- queries
COMMIT;
```

---

## **23. NORMALIZATION**

> **Concept:** Process of organizing data to reduce redundancy and improve integrity .

### **Normal Forms **

| Normal Form | Rule |
|-------------|------|
| **1NF (First Normal Form)** | Atomic values, no repeating groups |
| **2NF (Second Normal Form)** | 1NF + no partial dependencies |
| **3NF (Third Normal Form)** | 2NF + no transitive dependencies |
| **BCNF (Boyce-Codd)** | 3NF + every determinant is a candidate key |

### **Example: Unnormalized Table**
```sql
-- Denormalized (BAD)
CREATE TABLE orders_denormalized (
    order_id INT,
    customer_name VARCHAR(100),
    customer_phone VARCHAR(20),
    product1_name VARCHAR(50),
    product1_qty INT,
    product2_name VARCHAR(50),
    product2_qty INT
);
```

### **Normalized Design**
```sql
-- 1NF: Separate rows per product
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

---

## **24. DENORMALIZATION**

> **Concept:** Adding redundancy to improve query performance .

### **When to Denormalize**
- **Reporting/analytics** - Complex joins slow down queries
- **Read-heavy systems** - Trading storage for speed
- **Pre-aggregated data** - Store calculated totals

```sql
-- Normalized (query requires joins)
SELECT 
    c.name,
    SUM(oi.quantity * p.price) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
GROUP BY c.name;

-- Denormalized (add customer_name to orders)
ALTER TABLE orders ADD COLUMN customer_name VARCHAR(100);

-- Update once (when customer name changes)
-- Query becomes faster
SELECT 
    customer_name,
    SUM(oi.quantity * p.price) AS total_spent
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
GROUP BY customer_name;
```

---

## **25. QUERY OPTIMIZATION**

> **Concept:** Techniques to make queries run faster .

### **Optimization Tips **

1. **Select only needed columns, not ***
```sql
-- BAD
SELECT * FROM employees;

-- GOOD
SELECT id, first_name, last_name FROM employees;
```

2. **Filter early with WHERE**
```sql
-- BAD (filter after join)
SELECT e.*
FROM employees e
JOIN departments d ON e.dept_id = d.id
WHERE d.name = 'Sales';

-- GOOD (filter before join)
SELECT e.*
FROM employees e
JOIN departments d ON e.dept_id = d.id AND d.name = 'Sales';
```

3. **Use appropriate indexes**
```sql
-- Create index on frequently filtered columns
CREATE INDEX idx_emp_dept ON employees(department_id);
```

4. **Avoid functions in WHERE**
```sql
-- BAD (function prevents index use)
SELECT * FROM employees WHERE YEAR(hire_date) = 2023;

-- GOOD
SELECT * FROM employees 
WHERE hire_date >= '2023-01-01' 
  AND hire_date < '2024-01-01';
```

5. **Use EXISTS instead of IN for subqueries **
```sql
-- IN (can be slower with large result sets)
SELECT * FROM employees 
WHERE department_id IN (
    SELECT id FROM departments WHERE location = 'NYC'
);

-- EXISTS (often faster, stops at first match)
SELECT * FROM employees e
WHERE EXISTS (
    SELECT 1 FROM departments d 
    WHERE d.id = e.department_id AND d.location = 'NYC'
);
```

6. **UNION ALL vs UNION **
```sql
-- UNION removes duplicates (slower)
SELECT city FROM customers
UNION
SELECT city FROM suppliers;

-- UNION ALL keeps duplicates (faster, use if duplicates OK)
SELECT city FROM customers
UNION ALL
SELECT city FROM suppliers;
```

7. **Join order matters** (smaller result sets first)

---

## **26. EXECUTION PLAN**

> **Concept:** Shows how database executes a query - crucial for optimization .

```sql
-- MySQL
EXPLAIN SELECT * FROM employees WHERE salary > 50000;

-- PostgreSQL
EXPLAIN ANALYZE SELECT * FROM employees WHERE salary > 50000;

-- SQL Server
SET SHOWPLAN_XML ON;
SELECT * FROM employees WHERE salary > 50000;

-- SQLite
EXPLAIN QUERY PLAN SELECT * FROM employees WHERE salary > 50000;
```

### **What to Look For**
- **Table scans** vs **Index seeks**
- **Join types** (Nested Loops, Hash Join, Merge Join)
- **Sort operations** (expensive)
- **Estimated vs actual rows** (accuracy of statistics)

---

## **27. COMMON PATTERNS**

> **Concept:** Reusable SQL patterns for interview questions .

### **Pattern 1: Top N per Group **
```sql
-- Top 2 highest-paid employees per department
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn
    FROM employees
) t
WHERE rn <= 2;
```

### **Pattern 2: Deduplication **
```sql
-- Keep the earliest record for each user
DELETE FROM user_activity
WHERE id NOT IN (
    SELECT MIN(id)
    FROM user_activity
    GROUP BY user_id
);

-- Alternative with window function
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY email ORDER BY created_at) AS rn
    FROM users
)
DELETE FROM users WHERE id IN (SELECT id FROM ranked WHERE rn > 1);
```

### **Pattern 3: Running Total **
```sql
SELECT 
    date,
    amount,
    SUM(amount) OVER (ORDER BY date) AS running_total
FROM sales;
```

### **Pattern 4: Latest Record per User **
```sql
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at DESC) AS rn
    FROM user_activity
) t
WHERE rn = 1;
```

### **Pattern 5: Find nth Highest Salary **
```sql
-- Without LIMIT/OFFSET (for databases without LIMIT)
SELECT DISTINCT salary
FROM employees e1
WHERE 3 = (
    SELECT COUNT(DISTINCT salary)
    FROM employees e2
    WHERE e2.salary >= e1.salary
);

-- With window function
SELECT DISTINCT salary
FROM (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employees
) t
WHERE rnk = 3;
```

### **Pattern 6: Find Duplicates **
```sql
SELECT email, COUNT(*)
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
```

### **Pattern 7: Employees Above Department Average **
```sql
SELECT e1.*
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);

-- With window function
SELECT *
FROM (
    SELECT *,
           AVG(salary) OVER (PARTITION BY department_id) AS dept_avg
    FROM employees
) t
WHERE salary > dept_avg;
```

### **Pattern 8: Pivot Data**
```sql
-- Convert rows to columns
SELECT 
    product_id,
    SUM(CASE WHEN month = 'Jan' THEN sales END) AS Jan,
    SUM(CASE WHEN month = 'Feb' THEN sales END) AS Feb,
    SUM(CASE WHEN month = 'Mar' THEN sales END) AS Mar
FROM monthly_sales
GROUP BY product_id;
```

---

## **28. INTERVIEW QUESTIONS**

### **Basic Level **

| Question | Answer |
|----------|--------|
| **What is SQL?** | Structured Query Language for managing relational databases |
| **What's the difference between SQL and MySQL?** | SQL is language, MySQL is database system that implements SQL |
| **What are primary key and foreign key?** | PK: unique identifier; FK: references PK in another table |
| **Difference between DELETE and TRUNCATE?** | DELETE: DML, can rollback, WHERE clause; TRUNCATE: DDL, faster, can't rollback |
| **Difference between CHAR and VARCHAR?** | CHAR: fixed length; VARCHAR: variable length |
| **What is a constraint?** | Rule that limits data in a table |
| **Difference between WHERE and HAVING?** | WHERE: before GROUP BY; HAVING: after GROUP BY |

### **Intermediate Level **

| Question | Answer |
|----------|--------|
| **Explain different JOIN types** | INNER, LEFT, RIGHT, FULL, CROSS, SELF |
| **What is a subquery?** | Query nested inside another query |
| **Difference between UNION and UNION ALL?** | UNION removes duplicates; UNION ALL keeps them |
| **What are aggregate functions?** | COUNT, SUM, AVG, MIN, MAX |
| **What is GROUP BY used for?** | Groups rows with same values for aggregation |
| **What is an index?** | Lookup table to speed up data retrieval |
| **Difference between clustered and non-clustered index?** | Clustered: physical order; Non-clustered: separate structure |

### **Advanced Level **

| Question | Answer |
|----------|--------|
| **What are window functions?** | Functions that perform calculations across rows while keeping individual rows |
| **Explain ROW_NUMBER(), RANK(), DENSE_RANK()** | ROW_NUMBER: unique; RANK: same for ties with gaps; DENSE_RANK: same for ties without gaps |
| **What is a CTE?** | Common Table Expression - temporary result set |
| **What is a recursive CTE?** | CTE that references itself for hierarchical data |
| **How do you find top N per group?** | Use ROW_NUMBER() with PARTITION BY |
| **How do you find duplicates?** | GROUP BY with HAVING COUNT(*) > 1 |
| **What is a correlated subquery?** | Subquery that references outer query |
| **How do you optimize a slow query?** | Add indexes, avoid SELECT *, filter early, use EXISTS, check execution plan |

### **Scenario-Based Questions **

**1. Find employees earning above department average**
```sql
SELECT e1.*
FROM employees e1
WHERE salary > (SELECT AVG(salary) FROM employees e2 WHERE e2.dept_id = e1.dept_id);
```

**2. Find duplicate emails**
```sql
SELECT email, COUNT(*)
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
```

**3. Find nth highest salary**
```sql
SELECT DISTINCT salary
FROM employees e1
WHERE n = (SELECT COUNT(DISTINCT salary) FROM employees e2 WHERE e2.salary >= e1.salary);
```

**4. Get employees who joined in last 6 months**
```sql
SELECT * FROM employees 
WHERE hire_date >= DATE_SUB(CURRENT_DATE, INTERVAL 6 MONTH);
```

**5. Find departments with no employees**
```sql
SELECT d.*
FROM departments d
LEFT JOIN employees e ON d.id = e.dept_id
WHERE e.id IS NULL;
```

---

## **29. QUICK REFERENCE CHEAT SHEET**

```sql
-- ========== BASIC QUERIES ==========
SELECT column1, column2 FROM table WHERE condition;
SELECT DISTINCT column FROM table;
SELECT * FROM table ORDER BY column DESC LIMIT 10;

-- ========== JOINS ==========
SELECT * FROM t1 INNER JOIN t2 ON t1.id = t2.id;
SELECT * FROM t1 LEFT JOIN t2 ON t1.id = t2.id;
SELECT * FROM t1 RIGHT JOIN t2 ON t1.id = t2.id;
SELECT * FROM t1 FULL OUTER JOIN t2 ON t1.id = t2.id;

-- ========== AGGREGATION ==========
SELECT dept, COUNT(*) AS cnt, AVG(sal) AS avg_sal
FROM employees
GROUP BY dept
HAVING AVG(sal) > 50000;

-- ========== SUBQUERIES ==========
SELECT * FROM t1 WHERE col IN (SELECT col FROM t2 WHERE condition);
SELECT * FROM t1 WHERE EXISTS (SELECT 1 FROM t2 WHERE t1.id = t2.id);

-- ========== WINDOW FUNCTIONS ==========
SELECT *, ROW_NUMBER() OVER (PARTITION BY dept ORDER BY sal DESC) AS rn
FROM employees;

-- ========== CTE ==========
WITH cte AS (SELECT * FROM t1 WHERE condition)
SELECT * FROM cte;

-- ========== INSERT/UPDATE/DELETE ==========
INSERT INTO table (col1, col2) VALUES (val1, val2);
UPDATE table SET col1 = val1 WHERE condition;
DELETE FROM table WHERE condition;

-- ========== DDL ==========
CREATE TABLE t (id INT PRIMARY KEY, name VARCHAR(50));
ALTER TABLE t ADD COLUMN age INT;
DROP TABLE t;
TRUNCATE TABLE t;

-- ========== INDEXES ==========
CREATE INDEX idx_name ON table(column);
DROP INDEX idx_name ON table;

-- ========== TRANSACTIONS ==========
BEGIN TRANSACTION;
COMMIT;
ROLLBACK;
SAVEPOINT sp1;
ROLLBACK TO SAVEPOINT sp1;
```

---

## **📝 KEY TAKEAWAYS**

1. **SQL Categories**: DDL, DML, DQL, DCL, TCL
2. **Joins**: INNER, LEFT, RIGHT, FULL, CROSS, SELF
3. **Aggregation**: GROUP BY, HAVING, aggregate functions
4. **Filtering**: WHERE (rows) vs HAVING (groups)
5. **Subqueries**: IN, EXISTS, ANY, ALL, correlated
6. **Window Functions**: ROW_NUMBER, RANK, DENSE_RANK, LEAD, LAG
7. **CTEs**: WITH clause for cleaner, recursive queries
8. **Indexes**: Speed up queries, but have overhead
9. **Transactions**: ACID properties ensure data integrity
10. **Normalization**: Reduce redundancy, improve integrity
11. **Optimization**: SELECT specific columns, filter early, use indexes
12. **Common Patterns**: Top N, deduplication, running totals, latest record

---

*Good luck with your interview! 🎉*