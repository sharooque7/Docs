# Complete PostgreSQL Guide - The Ultimate Interview Reference 🐘

*Your comprehensive go-to guide for all PostgreSQL concepts with brief explanations and practical examples*

---

## **📋 TABLE OF CONTENTS**

1. [What is PostgreSQL?](#1-what-is-postgresql)
2. [PostgreSQL vs Other Databases](#2-postgresql-vs-other-databases)
3. [Architecture Overview](#3-architecture-overview)
4. [Data Types](#4-data-types)
5. [Indexing](#5-indexing)
6. [Advanced Index Types](#6-advanced-index-types)
7. [MVCC and Concurrency Control](#7-mvcc-and-concurrency-control)
8. [Transactions and ACID](#8-transactions-and-acid)
9. [Vacuum and Autovacuum](#9-vacuum-and-autovacuum)
10. [Write-Ahead Logging (WAL)](#10-write-ahead-logging-wal)
11. [Replication](#11-replication)
12. [Backup and Recovery](#12-backup-and-recovery)
13. [Partitioning](#13-partitioning)
14. [JSON/JSONB Support](#14-jsonjsonb-support)
15. [Full-Text Search](#15-full-text-search)
16. [Extensions](#16-extensions)
17. [Window Functions](#17-window-functions)
18. [Common Table Expressions (CTEs)](#18-common-table-expressions-ctes)
19. [Recursive Queries](#19-recursive-queries)
20. [Performance Tuning](#20-performance-tuning)
21. [Query Optimization with EXPLAIN](#21-query-optimization-with-explain)
22. [Configuration Parameters](#22-configuration-parameters)
23. [Security](#23-security)
24. [Role and User Management](#24-role-and-user-management)
25. [PostgreSQL vs MySQL](#25-postgresql-vs-mysql)
26. [PostgreSQL vs SQL Server](#26-postgresql-vs-sql-server)
27. [Common Interview Questions](#27-common-interview-questions)
28. [Quick Reference Cheat Sheet](#28-quick-reference-cheat-sheet)

---

## **1. WHAT IS POSTGRESQL?**

> **Concept:** PostgreSQL is a powerful, open-source object-relational database system with over 35 years of active development, known for reliability, feature robustness, and performance .

```sql
-- Check PostgreSQL version
SELECT version();

-- Sample output: "PostgreSQL 17.4 on x86_64-pc-linux-gnu..."
```

### **Key Features :**

| Feature | Description |
|---------|-------------|
| **ACID Compliance** | Full transactional integrity |
| **Extensibility** | Custom data types, functions, operators |
| **MVCC** | Multi-Version Concurrency Control for high concurrency |
| **JSON/JSONB** | Native JSON support with indexing |
| **Advanced Indexing** | B-tree, Hash, GiST, SP-GiST, GIN, BRIN |
| **Replication** | Streaming, logical, synchronous/asynchronous |
| **Security** | Row-level security, SSL, LDAP, SCRAM |

---

## **2. POSTGRESQL VS OTHER DATABASES**

> **Concept:** PostgreSQL is often compared with MySQL and SQL Server due to its enterprise-grade features .

| Feature | PostgreSQL | MySQL | SQL Server |
|---------|------------|-------|------------|
| **License** | Open Source (PostgreSQL License) | GPL/Commercial | Commercial |
| **ACID Compliance** | ✅ Full | ⚠️ With InnoDB | ✅ Full |
| **JSON Support** | ✅ Advanced (JSONB) | ✅ Basic | ✅ Basic |
| **Materialized Views** | ✅ Yes | ❌ No | ✅ Yes (Indexed Views) |
| **Full-Text Search** | ✅ Built-in | ✅ Built-in | ✅ Built-in |
| **Windows Support** | ✅ Yes | ✅ Yes | ✅ Native |
| **Replication** | Streaming, Logical | Master-Slave, Group | Always On, Replication |

---

## **3. ARCHITECTURE OVERVIEW**

> **Concept:** PostgreSQL uses a process-based architecture where each client connection spawns a new server process .

```
┌─────────────────────────────────────────────────┐
│                  PostgreSQL Instance             │
├─────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────┐ │
│  │         Shared Memory                        │ │
│  │  ┌─────────────┐  ┌─────────────┐           │ │
│  │  │ Shared Buffers│  │ WAL Buffers │           │ │
│  │  └─────────────┘  └─────────────┘           │ │
│  └─────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────┤
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ │
│  │ Postmaster ││ Backend ││ Background ││ WAL      │ │
│  │ Process    ││ Processes││ Processes ││ Sender   │ │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘ │
│      │           │           │           │        │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ │
│  │ Client 1 ││ Client 2 ││Autovacuum││Replication│ │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘ │
└─────────────────────────────────────────────────┘
```

### **Core Components :**

| Component | Description |
|-----------|-------------|
| **Postmaster** | Main daemon process managing connections |
| **Backend Processes** | One per client connection |
| **Background Writer** | Writes dirty buffers to disk |
| **WAL Writer** | Writes WAL records to disk |
| **Checkpointer** | Performs checkpoints |
| **Autovacuum Launcher** | Coordinates autovacuum workers |
| **Stats Collector** | Collects statistics for query planner |

---

## **4. DATA TYPES**

> **Concept:** PostgreSQL offers a rich set of built-in data types, including standard SQL types and special PostgreSQL-specific types .

### **Numeric Types**

| Type | Description | Range/Precision |
|------|-------------|-----------------|
| `SMALLINT` | 2-byte integer | -32,768 to 32,767 |
| `INTEGER` | 4-byte integer | -2.1B to 2.1B |
| `BIGINT` | 8-byte integer | -9.2 quintillion to 9.2 quintillion |
| `DECIMAL` | User-specified precision | Up to 131,072 digits |
| `NUMERIC` | Same as DECIMAL | Up to 131,072 digits |
| `REAL` | 4-byte floating point | 6 decimal digits precision |
| `DOUBLE PRECISION` | 8-byte floating point | 15 decimal digits precision |

```sql
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    price NUMERIC(10,2),
    quantity INTEGER,
    rating REAL
);
```

### **String Types **

| Type | Description |
|------|-------------|
| `CHAR(n)` | Fixed-length, blank-padded |
| `VARCHAR(n)` | Variable-length with limit |
| `TEXT` | Variable unlimited length |

```sql
CREATE TABLE users (
    username VARCHAR(50) UNIQUE,
    bio TEXT,
    code CHAR(8)
);
```

**CHAR vs VARCHAR vs TEXT**:
- `VARCHAR(n)` stores strings up to n characters, enforcing a length limit
- `TEXT` stores strings of arbitrary length without a predefined limit
- Functionally, there's little performance difference, but `VARCHAR(n)` adds a length check overhead 

### **Date/Time Types**

| Type | Description | Example |
|------|-------------|---------|
| `DATE` | Calendar date | '2023-12-25' |
| `TIME` | Time of day | '14:30:00' |
| `TIMESTAMP` | Date and time | '2023-12-25 14:30:00' |
| `TIMESTAMPTZ` | With time zone | '2023-12-25 14:30:00+05:30' |
| `INTERVAL` | Time span | '2 days 3 hours' |

### **PostgreSQL-Specific Types**

| Type | Description |
|------|-------------|
| `JSON` | Stores JSON text (preserves formatting) |
| `JSONB` | Stores JSON in binary format (indexable, faster for operations) |
| `UUID` | Universally Unique Identifier |
| `ARRAY` | Multi-dimensional arrays |
| `HSTORE` | Key-value store |
| `POINT`, `LINE`, `LSEG` | Geometric types |
| `INET`, `CIDR` | Network addresses |
| `TSVECTOR`, `TSQUERY` | Full-text search types |

```sql
CREATE TABLE advanced_data (
    id UUID DEFAULT gen_random_uuid(),
    tags TEXT[],
    metadata JSONB,
    location POINT,
    ip_address INET
);
```

---

## **5. INDEXING**

> **Concept:** Indexes are database objects that improve data retrieval speed, essential for query performance on large datasets .

### **Basic Index Operations**

```sql
-- Create B-tree index (default)
CREATE INDEX idx_users_email ON users(email);

-- Create unique index
CREATE UNIQUE INDEX idx_users_username ON users(username);

-- Create composite index
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);

-- Create partial index
CREATE INDEX idx_active_users ON users(email) WHERE status = 'active';

-- Create expression index
CREATE INDEX idx_users_lower_email ON users(LOWER(email));

-- Create index with INCLUDE (covering index)
CREATE INDEX idx_orders_id_total ON orders(id) INCLUDE (total_amount);

-- Drop index
DROP INDEX idx_users_email;

-- Reindex
REINDEX INDEX idx_users_email;
```

### **Index Types Available **

| Index Type | Use Case |
|------------|----------|
| **B-tree** (default) | Equality and range queries, most common |
| **Hash** | Simple equality comparisons |
| **GiST** | Geometric data, full-text, spatial |
| **SP-GiST** | Non-balanced data structures (quad-trees, k-d trees) |
| **GIN** | Composite types (arrays, JSONB, full-text) |
| **BRIN** | Very large tables with natural ordering |

```sql
-- B-tree (default)
CREATE INDEX idx_products_price ON products(price);

-- Hash (equality only)
CREATE INDEX idx_products_sku ON products USING HASH(sku);

-- GIN for JSONB
CREATE INDEX idx_products_metadata ON products USING GIN(metadata);

-- GIN for array
CREATE INDEX idx_products_tags ON products USING GIN(tags);

-- BRIN for large, ordered tables
CREATE INDEX idx_orders_created ON orders USING BRIN(created_at);

-- GiST for geometric data
CREATE INDEX idx_locations_coords ON locations USING GiST(coordinates);
```

### **Indexing Best Practices **

- **WHERE clauses**: Index columns used frequently in WHERE conditions
- **JOIN columns**: Index foreign key columns
- **ORDER BY/GROUP BY**: Can benefit from indexes
- **Selectivity**: High-cardinality columns benefit more
- **Partial indexes**: Index only relevant rows
- **Covering indexes**: Use INCLUDE to avoid table access
- **Avoid over-indexing**: Each index adds INSERT/UPDATE overhead

---

## **6. ADVANCED INDEX TYPES**

### **6.1 GIN (Generalized Inverted Index)**

> **Purpose:** For composite types like arrays, JSONB, full-text search vectors.

```sql
-- Create table with JSONB
CREATE TABLE articles (
    id SERIAL PRIMARY KEY,
    title TEXT,
    tags TEXT[],
    metadata JSONB,
    search_vector TSVECTOR
);

-- GIN on array
CREATE INDEX idx_articles_tags ON articles USING GIN(tags);

-- GIN on JSONB
CREATE INDEX idx_articles_metadata ON articles USING GIN(metadata);

-- Query using GIN index
SELECT * FROM articles WHERE tags @> ARRAY['postgresql'];
SELECT * FROM articles WHERE metadata @> '{"author": "John"}';
SELECT * FROM articles WHERE metadata ? 'draft';

-- GIN for full-text search
CREATE INDEX idx_articles_search ON articles USING GIN(search_vector);
SELECT * FROM articles WHERE search_vector @@ to_tsquery('english', 'database');
```

### **6.2 GiST (Generalized Search Tree)**

> **Purpose:** Geometric data, full-text search, range types.

```sql
-- Geometric data
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    name TEXT,
    coordinates POINT
);

CREATE INDEX idx_locations_coords ON locations USING GiST(coordinates);

-- Range queries
SELECT * FROM locations 
WHERE coordinates <@ circle '((0,0),10)';  -- Points within 10 units

-- Range types
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    name TEXT,
    duration TSRANGE
);

CREATE INDEX idx_events_duration ON events USING GiST(duration);
SELECT * FROM events WHERE duration && '[2023-01-01, 2023-12-31]'::tsrange;
```

### **6.3 BRIN (Block Range Index)**

> **Purpose:** Very large tables where rows have natural ordering. Uses minimal storage.

```sql
-- BRIN index on large time-series table
CREATE TABLE sensor_data (
    sensor_id INTEGER,
    timestamp TIMESTAMPTZ,
    value FLOAT
);

-- BRIN is tiny compared to B-tree
CREATE INDEX idx_sensor_timestamp ON sensor_data USING BRIN(timestamp);

-- Query benefits from ordering
SELECT * FROM sensor_data 
WHERE timestamp BETWEEN '2023-01-01' AND '2023-01-02';
```

| Feature | B-tree | GIN | GiST | BRIN |
|---------|--------|-----|------|------|
| **Size** | Large | Large | Medium | Tiny |
| **Build time** | Fast | Slow | Medium | Very Fast |
| **Suitable for** | General | Composite types | Geometric | Ordered data |
| **Update cost** | Low | High | Medium | Very Low |

---

## **7. MVCC AND CONCURRENCY CONTROL**

> **Concept:** Multi-Version Concurrency Control allows readers and writers to coexist without blocking each other by maintaining multiple versions of rows .

```sql
-- MVCC in action
-- Session 1
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE id = 1;

-- Session 2 (can still read old value - not blocked!)
SELECT balance FROM accounts WHERE id = 1;  -- Returns old value

-- Session 1
COMMIT;

-- Session 2 (now sees new value)
SELECT balance FROM accounts WHERE id = 1;  -- Returns new value
```

### **Transaction Isolation Levels**

| Level | Dirty Read | Non-repeatable Read | Phantom Read |
|-------|------------|---------------------|--------------|
| **READ UNCOMMITTED** | Possible | Possible | Possible |
| **READ COMMITTED** (default) | Not possible | Possible | Possible |
| **REPEATABLE READ** | Not possible | Not possible | Possible |
| **SERIALIZABLE** | Not possible | Not possible | Not possible |

```sql
-- Set isolation level
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
-- queries
COMMIT;
```

### **MVCC Implementation**

PostgreSQL stores multiple row versions using:
- **xmin**: Transaction ID that created this version
- **xmax**: Transaction ID that deleted/updated this version
- Dead rows are cleaned up by VACUUM

```sql
-- View transaction IDs
SELECT xmin, xmax, * FROM accounts;
```

---

## **8. TRANSACTIONS AND ACID**

> **Concept:** PostgreSQL ensures ACID properties for all transactions, guaranteeing data integrity even during system failures .

### **ACID Properties in PostgreSQL**

| Property | PostgreSQL Implementation |
|----------|---------------------------|
| **Atomicity** | Transaction commits all operations or rolls back completely |
| **Consistency** | Constraints prevent invalid data entry |
| **Isolation** | MVCC provides transaction isolation |
| **Durability** | WAL ensures committed changes survive crashes |

### **Transaction Control **

```sql
-- Start transaction
BEGIN;
-- or START TRANSACTION;

-- Savepoint
BEGIN;
INSERT INTO logs(message) VALUES('Process started');
SAVEPOINT sp1;

UPDATE accounts SET balance = balance - 500 WHERE id = 1;
SAVEPOINT sp2;
UPDATE accounts SET balance = balance + 500 WHERE id = 2;

-- Rollback to savepoint if needed
ROLLBACK TO SAVEPOINT sp1;

COMMIT;  -- Commits only changes before sp1

-- Rollback entire transaction
ROLLBACK;
```

### **Transaction Monitoring**

```sql
-- View current transactions
SELECT pid, state, query, backend_xid, backend_xmin
FROM pg_stat_activity
WHERE backend_xid IS NOT NULL OR backend_xmin IS NOT NULL;

-- View locks
SELECT locktype, relation, mode, granted
FROM pg_locks
WHERE pid = 12345;
```

---

## **9. VACUUM AND AUTOVACUUM**

> **Concept:** Vacuum reclaims storage occupied by dead tuples (old row versions) and updates statistics .

### **VACUUM vs VACUUM FULL**

| Command | Description | Locks | Space Recovery |
|---------|-------------|-------|----------------|
| **VACUUM** | Reclaims space for reuse, updates stats | Minimal (shared) | Only to OS? No, just marks free |
| **VACUUM FULL** | Rewrites entire table, compacts | Exclusive lock | Returns space to OS |

```sql
-- Standard vacuum (can run concurrently)
VACUUM accounts;
VACUUM VERBOSE accounts;  -- Show details

-- Vacuum specific columns only
VACUUM accounts (balance, status);

-- Analyze (update statistics)
ANALYZE accounts;

-- Vacuum and analyze together
VACUUM ANALYZE accounts;

-- Vacuum FULL (exclusive lock, slower)
VACUUM FULL accounts;

-- Vacuum all databases in cluster
VACUUM;
```

### **Autovacuum **

> **Concept:** Background process that automatically performs VACUUM and ANALYZE operations, preventing transaction ID wraparound and table bloat.

**Autovacuum Process**:
- **Autovacuum Launcher**: Coordinates work, always present
- **Autovacuum Workers**: Perform actual vacuum tasks

```sql
-- Check autovacuum settings
SHOW autovacuum;
SHOW autovacuum_vacuum_threshold;
SHOW autovacuum_vacuum_scale_factor;

-- Monitor autovacuum activity
SELECT schemaname, tablename, last_autovacuum, last_autoanalyze
FROM pg_stat_user_tables;

-- Table-specific autovacuum configuration
ALTER TABLE large_table SET (autovacuum_vacuum_scale_factor = 0.05);
```

### **Common VACUUM-Related Issues**

| Issue | Symptom | Solution |
|-------|---------|----------|
| **Table bloat** | Slow queries, large table size | VACUUM FULL or pg_repack |
| **Transaction ID wraparound** | Warnings in logs | Aggressive vacuum |
| **Dead tuples** | pg_stat_user_tables shows high n_dead_tup | Tune autovacuum |

---

## **10. WRITE-AHEAD LOGGING (WAL)**

> **Concept:** Before any changes are written to data files, they are first written to WAL logs, ensuring durability and enabling crash recovery .

```sql
-- Check WAL settings
SHOW wal_level;
SHOW wal_buffers;
SHOW wal_sync_method;
SHOW wal_keep_size;

-- WAL directory
-- $PGDATA/pg_wal/ contains WAL segments (typically 16MB each)
```

### **WAL Architecture**

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│ Transaction │─────▶│  WAL Buffer │─────▶│  WAL File   │
│   Changes   │      │  (Memory)   │      │   (Disk)    │
└─────────────┘      └─────────────┘      └──────┬──────┘
                                                   │
                                                   ▼
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   Recovery  │◀─────│   WAL       │◀─────│  Replication│
│   Process   │      │  Archive    │      │    Slave    │
└─────────────┘      └─────────────┘      └─────────────┘
```

### **WAL Configuration**

```sql
-- postgresql.conf settings
wal_level = replica                   -- minimal, replica, logical
synchronous_commit = on               -- on, off, remote_write
wal_sync_method = fdatasync           -- open_datasync, fdatasync, fsync
wal_buffers = 16MB                    -- WAL buffer size
wal_writer_delay = 200ms               -- WAL writer frequency
wal_keep_size = 1GB                    -- WAL segments to keep for replicas
```

### **WAL Usage**

- **Crash Recovery**: Replays WAL after crash
- **Point-in-Time Recovery (PITR)**: Restore to any point using WAL archives
- **Replication**: Streaming replication sends WAL to standbys
- **Read Replicas**: Apply WAL to keep replicas current

---

## **11. REPLICATION**

> **Concept:** PostgreSQL supports multiple replication methods for high availability, load balancing, and data distribution .

### **11.1 Streaming Replication**

> **Concept:** Primary sends WAL to standby(s) in real-time.

```sql
-- Primary configuration (postgresql.conf)
wal_level = replica
max_wal_senders = 10
wal_keep_size = 1GB

-- Standby configuration
primary_conninfo = 'host=primary port=5432 user=replica'
standby_mode = on
recovery_target_timeline = 'latest'

-- Create replication user
CREATE USER replica REPLICATION LOGIN PASSWORD 'secret';
```

### **11.2 Logical Replication**

> **Concept:** Replicates changes based on replication identity (primary key) rather than physical location .

```sql
-- Publisher (source)
CREATE PUBLICATION orders_pub FOR TABLE orders;

-- Subscriber (target)
CREATE SUBSCRIPTION orders_sub 
CONNECTION 'host=source dbname=prod user=replication' 
PUBLICATION orders_pub;

-- Selective replication
CREATE PUBLICATION active_users_pub 
FOR TABLE users WHERE (status = 'active');
```

### **11.3 Synchronous vs Asynchronous Replication**

| Type | Behavior | Use Case |
|------|----------|----------|
| **Synchronous** | Primary waits for standby confirm | Zero data loss, higher latency |
| **Asynchronous** | Primary doesn't wait | Lower latency, potential data loss |

```sql
-- Synchronous replication
ALTER SYSTEM SET synchronous_standby_names = 'standby1, standby2';
-- Creates a quorum of standbys that must confirm

-- Check replication status
SELECT application_name, state, sync_state, write_lag, flush_lag, replay_lag
FROM pg_stat_replication;
```

### **11.4 Replication Tools**

| Tool | Purpose |
|------|---------|
| **repmgr** | Replication management, failover |
| **Patroni** | Automatic failover, HA management |
| **pglogical** | Advanced logical replication |
| **BDR** | Multi-master replication |

---

## **12. BACKUP AND RECOVERY**

> **Concept:** PostgreSQL offers multiple backup methods: logical (pg_dump) and physical (base backup + WAL) .

### **12.1 Logical Backup (pg_dump)**

```sql
-- Backup single database
pg_dump -h localhost -U postgres mydb > mydb.sql

-- Backup in custom format (compressed, flexible restore)
pg_dump -Fc -h localhost -U postgres mydb > mydb.dump

-- Backup specific tables only
pg_dump -t users -t orders mydb > users_orders.sql

-- Exclude tables
pg_dump -T temp_logs mydb > mydb.sql

-- Restore from SQL backup
psql -U postgres mydb < mydb.sql

-- Restore from custom format
pg_restore -d mydb mydb.dump

-- Restore specific table from custom dump
pg_restore -d mydb -t users mydb.dump
```

### **12.2 Physical Backup (Base Backup)**

```sql
-- Take base backup using pg_basebackup
pg_basebackup -h primary -U replication -D /backup/dir -P -X stream

-- With WAL archiving for PITR
pg_basebackup -h primary -U replication -D /backup/dir -X fetch

-- Create backup label
SELECT pg_backup_start('full_backup_20250220');
-- Perform filesystem backup
SELECT pg_backup_stop();
```

### **12.3 Point-in-Time Recovery (PITR)**

> **Concept:** Restore to any point using base backup + archived WAL .

```sql
-- 1. Set up WAL archiving
-- postgresql.conf
archive_mode = on
archive_command = 'cp %p /archive/%f'

-- 2. Take base backup
pg_basebackup -D /backup/base

-- 3. Configure recovery (postgresql.conf or recovery.conf)
restore_command = 'cp /archive/%f %p'
recovery_target_time = '2024-02-20 15:30:00 EST'
recovery_target_timeline = 'latest'

-- 4. Create recovery signal file
touch /var/lib/postgresql/data/recovery.signal

-- 5. Start PostgreSQL - it will recover to target time
```

### **12.4 Backup Comparison**

| Feature | Logical Backup | Physical Backup |
|---------|----------------|-----------------|
| **Size** | Smaller | Larger |
| **Speed** | Slower for large DB | Faster |
| **Point-in-time** | No | Yes (with WAL) |
| **Cross-version** | Yes | No |
| **Selective restore** | Yes | No (except file level) |

---

## **13. PARTITIONING**

> **Concept:** Splits large tables into smaller, more manageable pieces called partitions for improved query performance and maintenance .

### **13.1 Range Partitioning**

```sql
-- Create parent table
CREATE TABLE orders (
    id SERIAL,
    order_date DATE NOT NULL,
    customer_id INTEGER,
    total NUMERIC
) PARTITION BY RANGE (order_date);

-- Create partitions for different time periods
CREATE TABLE orders_2023_q1 PARTITION OF orders
FOR VALUES FROM ('2023-01-01') TO ('2023-04-01');

CREATE TABLE orders_2023_q2 PARTITION OF orders
FOR VALUES FROM ('2023-04-01') TO ('2023-07-01');

CREATE TABLE orders_2023_q3 PARTITION OF orders
FOR VALUES FROM ('2023-07-01') TO ('2023-10-01');

CREATE TABLE orders_2023_q4 PARTITION OF orders
FOR VALUES FROM ('2023-10-01') TO ('2024-01-01');

-- Default partition for others
CREATE TABLE orders_default PARTITION OF orders DEFAULT;
```

### **13.2 List Partitioning**

```sql
CREATE TABLE customers (
    id SERIAL,
    name TEXT,
    country VARCHAR(2)
) PARTITION BY LIST (country);

CREATE TABLE customers_usa PARTITION OF customers
FOR VALUES IN ('US', 'CA', 'MX');

CREATE TABLE customers_eu PARTITION OF customers
FOR VALUES IN ('GB', 'DE', 'FR', 'IT', 'ES');

CREATE TABLE customers_asia PARTITION OF customers
FOR VALUES IN ('JP', 'KR', 'CN', 'IN');

CREATE TABLE customers_other PARTITION OF customers DEFAULT;
```

### **13.3 Hash Partitioning**

```sql
CREATE TABLE logs (
    id SERIAL,
    log_time TIMESTAMP,
    message TEXT
) PARTITION BY HASH (id);

CREATE TABLE logs_p0 PARTITION OF logs
FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE logs_p1 PARTITION OF logs
FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE logs_p2 PARTITION OF logs
FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE logs_p3 PARTITION OF logs
FOR VALUES WITH (MODULUS 4, REMAINDER 3);
```

### **13.4 Partition Management**

```sql
-- Create indexes on partitions (automatically inherited if on parent)
CREATE INDEX idx_orders_date ON orders(order_date);

-- Detach partition (for archiving)
ALTER TABLE orders DETACH PARTITION orders_2023_q1;

-- Attach existing table as partition
CREATE TABLE orders_2024_q1 (LIKE orders INCLUDING INDEXES);
ALTER TABLE orders ATTACH PARTITION orders_2024_q1
FOR VALUES FROM ('2024-01-01') TO ('2024-04-01');

-- Drop partition
DROP TABLE orders_2023_q1;

-- Truncate partition
TRUNCATE orders_2023_q1;

-- Partition-wise join (enable for better performance)
ALTER TABLE orders SET (partition_wise_join = on);
```

### **13.5 Partitioning Benefits**

| Benefit | Description |
|---------|-------------|
| **Performance** | Queries scan only relevant partitions |
| **Maintenance** | VACUUM, reindex on single partitions |
| **Archiving** | Detach and drop old partitions easily |
| **Parallelism** | Can scan partitions in parallel |

---

## **14. JSON/JSONB SUPPORT**

> **Concept:** PostgreSQL offers robust JSON support with two data types: JSON (text storage) and JSONB (binary storage, indexable) .

```sql
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name TEXT,
    attributes JSONB
);

INSERT INTO products (name, attributes) VALUES
('Laptop', '{"brand": "Dell", "ram": 16, "ssd": 512}'),
('Phone', '{"brand": "Apple", "model": "iPhone 15", "color": "black"}');
```

### **JSONB vs JSON**

| Feature | JSON | JSONB |
|---------|------|-------|
| **Storage** | Text as entered | Binary parsed format |
| **Indexing** | No | Yes (GIN indexes) |
| **Speed** | Slow for operations | Fast for operations |
| **Preserves whitespace** | Yes | No |
| **Duplicate keys** | Keeps last | Keeps last |

### **JSONB Operators and Functions**

```sql
-- Access fields
SELECT attributes->'brand' AS brand FROM products;
SELECT attributes->>'model' AS model FROM products;

-- Check existence (key or value)
SELECT * FROM products WHERE attributes ? 'ram';
SELECT * FROM products WHERE attributes ?& ARRAY['brand', 'ram'];

-- JSON containment
SELECT * FROM products WHERE attributes @> '{"brand": "Dell"}';
SELECT * FROM products WHERE attributes <@ '{"brand": "Dell", "ram": 16}';

-- Path operations
SELECT jsonb_path_query(attributes, '$.brand') FROM products;

-- Update JSONB
UPDATE products 
SET attributes = attributes || '{"warranty": 2}'::jsonb
WHERE id = 1;

-- Remove key
UPDATE products 
SET attributes = attributes - 'ssd'
WHERE id = 1;
```

### **JSONB Indexes**

```sql
-- GIN index on whole JSONB
CREATE INDEX idx_products_attrs ON products USING GIN(attributes);

-- GIN index with specific path
CREATE INDEX idx_products_brand ON products USING GIN((attributes->'brand'));

-- Partial index
CREATE INDEX idx_products_dell ON products USING GIN(attributes)
WHERE attributes @> '{"brand": "Dell"}';

-- Query using index
SELECT * FROM products WHERE attributes @> '{"brand": "Dell", "ram": 16}';
```

### **JSONB Aggregation**

```sql
-- Aggregate rows to JSON
SELECT jsonb_agg(name) FROM products;

-- Build JSON object
SELECT jsonb_build_object('id', id, 'name', name) FROM products;

-- Row to JSON
SELECT row_to_json(p) FROM products p WHERE id = 1;
```

---

## **15. FULL-TEXT SEARCH**

> **Concept:** PostgreSQL includes built-in full-text search capabilities with support for multiple languages, stemming, and ranking .

### **Basic Full-Text Search**

```sql
-- Create tsvector column (pre-processed text)
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    title TEXT,
    body TEXT,
    search_vector TSVECTOR
);

-- Populate tsvector
UPDATE documents SET search_vector = 
    setweight(to_tsvector('english', title), 'A') ||
    setweight(to_tsvector('english', body), 'B');

-- Create GIN index
CREATE INDEX idx_documents_search ON documents USING GIN(search_vector);

-- Search queries
SELECT id, title, 
       ts_rank(search_vector, query) AS rank
FROM documents, to_tsquery('english', 'database & performance') query
WHERE search_vector @@ query
ORDER BY rank DESC;

-- Highlight matches
SELECT ts_headline('english', body, query)
FROM documents, to_tsquery('english', 'database') query
WHERE search_vector @@ query;
```

### **Search Configuration**

```sql
-- Show available configurations
\dF

-- Create custom configuration
CREATE TEXT SEARCH CONFIGURATION my_config (COPY = english);

-- Add mapping
ALTER TEXT SEARCH CONFIGURATION my_config
ALTER MAPPING FOR word WITH simple;

-- Set language for a query
SELECT * FROM documents 
WHERE search_vector @@ to_tsquery('french', 'base de données');
```

### **Search Operators**

```sql
-- Basic operators
SELECT * FROM documents WHERE search_vector @@ to_tsquery('database');
SELECT * FROM documents WHERE search_vector @@ to_tsquery('database & performance');
SELECT * FROM documents WHERE search_vector @@ to_tsquery('database | sql');
SELECT * FROM documents WHERE search_vector @@ to_tsquery('!nosql');

-- Phrase search
SELECT * FROM documents 
WHERE search_vector @@ to_tsquery('database <-> performance');

-- Proximity search (within 3 words)
SELECT * FROM documents 
WHERE search_vector @@ to_tsquery('database <3> performance');
```

### **pg_trgm Extension for Fuzzy Search**

```sql
-- Enable extension
CREATE EXTENSION pg_trgm;

-- Create trigram index
CREATE INDEX idx_documents_title_trgm ON documents USING GIN(title gin_trgm_ops);

-- Fuzzy matching
SELECT * FROM documents WHERE title % 'databas';  -- Similarity
SELECT similarity('database', 'databas') AS sim;

-- Word similarity
SELECT * FROM documents 
WHERE title %> 'performence';  -- Word similarity
```

---

## **16. EXTENSIONS**

> **Concept:** PostgreSQL's extensibility allows custom functions, data types, and operators through extensions .

```sql
-- List available extensions
SELECT * FROM pg_available_extensions;

-- Install extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION postgis;
CREATE EXTENSION pg_stat_statements;

-- View installed extensions
SELECT * FROM pg_extension;
```

### **Essential PostgreSQL Extensions**

| Extension | Purpose | Common Commands |
|-----------|---------|-----------------|
| **uuid-ossp** | UUID generation | `uuid_generate_v4()` |
| **pgcrypto** | Cryptographic functions | `crypt()`, `gen_random_bytes()` |
| **pg_stat_statements** | Query statistics | Tracks execution stats |
| **postgis** | Geographic objects | Spatial queries, GIS |
| **pg_trgm** | Text similarity | Trigram matching |
| **btree_gin** | GIN on scalar types | Composite indexes |
| **hstore** | Key-value store | `hstore` data type |
| **pg_repack** | Online table reorganization | Remove bloat without locks |
| **pg_partman** | Partition management | Automated partitioning |
| **pgAudit** | Detailed audit logging | Session/object audit |

### **Extension Examples**

```sql
-- uuid-ossp
CREATE EXTENSION "uuid-ossp";
SELECT uuid_generate_v4();  -- Random UUID

-- pgcrypto
CREATE EXTENSION pgcrypto;
UPDATE users SET password = crypt('newpass', gen_salt('bf', 8));
SELECT * FROM users WHERE password = crypt('entered', password);

-- pg_stat_statements
CREATE EXTENSION pg_stat_statements;
SELECT query, calls, total_exec_time, rows 
FROM pg_stat_statements 
ORDER BY total_exec_time DESC 
LIMIT 5;

-- pg_trgm
CREATE EXTENSION pg_trgm;
CREATE INDEX trgm_idx ON products USING GIN(name gin_trgm_ops);
SELECT * FROM products WHERE name % 'laptp';  -- Fuzzy match
```

---

## **17. WINDOW FUNCTIONS**

> **Concept:** Perform calculations across rows related to current row without collapsing results .

### **Window Function Syntax**

```sql
function_name([columns]) OVER (
    [PARTITION BY partition_columns]
    [ORDER BY order_columns]
    [frame_clause]
)
```

### **Ranking Functions**

```sql
-- ROW_NUMBER: unique sequential number
SELECT 
    product_id,
    category,
    price,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS overall_rank,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS category_rank
FROM products;

-- RANK vs DENSE_RANK
SELECT 
    department,
    salary,
    RANK() OVER (ORDER BY salary DESC) AS rank_with_gaps,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS rank_no_gaps
FROM employees;
```

### **Aggregate Window Functions**

```sql
-- Running totals
SELECT 
    order_date,
    amount,
    SUM(amount) OVER (ORDER BY order_date) AS running_total,
    AVG(amount) OVER (ORDER BY order_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) 
        AS moving_avg_3
FROM orders;

-- Per-group aggregates
SELECT 
    department,
    employee_name,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg,
    salary - AVG(salary) OVER (PARTITION BY department) AS diff_from_avg
FROM employees;
```

### **LAG and LEAD**

```sql
-- Compare with previous/next
SELECT 
    order_date,
    amount,
    LAG(amount, 1) OVER (ORDER BY order_date) AS prev_amount,
    LEAD(amount, 1) OVER (ORDER BY order_date) AS next_amount,
    amount - LAG(amount, 1) OVER (ORDER BY order_date) AS diff_from_prev
FROM orders;

-- Year-over-year comparison
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    SUM(amount) AS yearly_total,
    LAG(SUM(amount)) OVER (ORDER BY EXTRACT(YEAR FROM order_date)) AS prev_year,
    SUM(amount) - LAG(SUM(amount)) OVER (ORDER BY EXTRACT(YEAR FROM order_date)) AS yoy_change
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date);
```

### **NTILE and Percent Rank**

```sql
-- Divide into quartiles
SELECT 
    employee_name,
    salary,
    NTILE(4) OVER (ORDER BY salary) AS salary_quartile,
    PERCENT_RANK() OVER (ORDER BY salary) AS percent_rank
FROM employees;

-- Top 3 per group
WITH ranked AS (
    SELECT 
        department,
        employee_name,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn
    FROM employees
)
SELECT * FROM ranked WHERE rn <= 3;
```

---

## **18. COMMON TABLE EXPRESSIONS (CTEs)**

> **Concept:** Temporary named result sets that improve query readability and enable recursion .

### **Basic CTE**

```sql
WITH high_earners AS (
    SELECT employee_name, salary, department_id
    FROM employees
    WHERE salary > 70000
)
SELECT d.department_name, he.employee_name, he.salary
FROM high_earners he
JOIN departments d ON he.department_id = d.id
ORDER BY d.department_name, he.salary DESC;
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
    SELECT AVG(salary) AS company_avg FROM employees
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

### **Data Modification CTEs**

```sql
-- Update with CTE
WITH deleted_orders AS (
    DELETE FROM orders
    WHERE order_date < '2020-01-01'
    RETURNING *
)
INSERT INTO orders_archive SELECT * FROM deleted_orders;

-- Multiple modifications
WITH 
updated AS (
    UPDATE products SET price = price * 1.1
    WHERE category = 'electronics'
    RETURNING *
),
inserted AS (
    INSERT INTO price_changes (product_id, old_price, new_price)
    SELECT id, price / 1.1, price
    FROM updated
    RETURNING *
)
SELECT COUNT(*) FROM inserted;
```

---

## **19. RECURSIVE QUERIES**

> **Concept:** CTEs that reference themselves, perfect for hierarchical or graph data .

### **Employee Hierarchy**

```sql
WITH RECURSIVE emp_hierarchy AS (
    -- Anchor: top-level managers
    SELECT 
        id, 
        name, 
        manager_id, 
        1 AS level,
        name AS path
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive: direct reports
    SELECT 
        e.id, 
        e.name, 
        e.manager_id, 
        h.level + 1,
        h.path || ' → ' || e.name
    FROM employees e
    JOIN emp_hierarchy h ON e.manager_id = h.id
)
SELECT 
    level,
    path
FROM emp_hierarchy
ORDER BY level, name;
```

### **Tree Structure**

```sql
-- Categories tree
WITH RECURSIVE category_tree AS (
    SELECT 
        id, 
        name, 
        parent_id,
        1 AS depth,
        name AS full_path
    FROM categories
    WHERE parent_id IS NULL
    
    UNION ALL
    
    SELECT 
        c.id, 
        c.name, 
        c.parent_id,
        ct.depth + 1,
        ct.full_path || ' > ' || c.name
    FROM categories c
    JOIN category_tree ct ON c.parent_id = ct.id
)
SELECT 
    depth,
    full_path,
    (SELECT COUNT(*) FROM products WHERE category_id = ct.id) AS product_count
FROM category_tree ct
ORDER BY full_path;
```

### **Generate Series (Alternative to generate_series)**

```sql
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;

-- Fibonacci sequence
WITH RECURSIVE fibonacci(a, b) AS (
    SELECT 0::BIGINT, 1::BIGINT
    UNION ALL
    SELECT b, a + b FROM fibonacci WHERE b < 1000
)
SELECT a FROM fibonacci;
```

---

## **20. PERFORMANCE TUNING**

> **Concept:** Systematic approach to identifying and resolving performance bottlenecks .

### **Identifying Slow Queries**

```sql
-- Using pg_stat_statements
SELECT 
    query,
    calls,
    total_exec_time / calls AS avg_time,
    rows / calls AS avg_rows,
    (100 * total_exec_time / SUM(total_exec_time) OVER()) AS percentage
FROM pg_stat_statements
WHERE total_exec_time > 0
ORDER BY total_exec_time DESC
LIMIT 10;

-- Current running queries
SELECT 
    pid,
    query,
    state,
    age(clock_timestamp(), query_start) AS runtime
FROM pg_stat_activity
WHERE state = 'active' 
  AND query NOT LIKE '%pg_stat_activity%'
ORDER BY runtime DESC;
```

### **Index Tuning**

```sql
-- Find unused indexes
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan
FROM pg_stat_user_indexes
WHERE idx_scan = 0
ORDER BY schemaname, tablename;

-- Find missing indexes
SELECT 
    schemaname,
    tablename,
    attname,
    n_distinct,
    correlation
FROM pg_stats
WHERE n_distinct BETWEEN 100 AND 1000
  AND correlation < 0.1
  AND tablename IN (SELECT tablename FROM pg_stat_user_tables WHERE seq_scan > 1000);
```

### **Configuration Tuning **

```sql
-- Memory settings
SHOW shared_buffers;        -- 25% of RAM for dedicated server
SHOW work_mem;              -- For sorts, joins (per operation)
SHOW maintenance_work_mem;  -- For VACUUM, CREATE INDEX
SHOW effective_cache_size;   -- OS cache estimate

-- Checkpoint settings
SHOW checkpoint_timeout;    -- Usually 5-15 minutes
SHOW max_wal_size;          -- Max WAL before checkpoint
SHOW min_wal_size;          -- Minimum WAL to retain

-- Autovacuum settings
SHOW autovacuum_max_workers;
SHOW autovacuum_vacuum_threshold;
SHOW autovacuum_vacuum_scale_factor;
```

### **Table and Database Size**

```sql
-- Database size
SELECT pg_database_size('mydb')/1024/1024/1024 AS size_gb;

-- Table size
SELECT 
    pg_size_pretty(pg_total_relation_size('orders')) AS total,
    pg_size_pretty(pg_relation_size('orders')) AS table,
    pg_size_pretty(pg_indexes_size('orders')) AS indexes;

-- Largest tables
SELECT 
    relname,
    pg_size_pretty(pg_total_relation_size(relid)) AS total_size
FROM pg_catalog.pg_statio_user_tables
ORDER BY pg_total_relation_size(relid) DESC
LIMIT 10;
```

### **Performance Tuning Tips **

1. **Index columns** used in WHERE, JOIN, ORDER BY
2. **Use EXPLAIN ANALYZE** to find bottlenecks
3. **Increase work_mem** for sorts/hashes (per operation)
4. **Tune autovacuum** to prevent bloat
5. **Consider partitioning** for very large tables
6. **Use connection pooling** (PgBouncer) for many connections
7. **Monitor** with pg_stat_statements and pg_stat_activity
8. **Regular VACUUM ANALYZE** for updated tables
9. **Avoid functions** in WHERE clauses (prevents index use)
10. **Use prepared statements** to avoid parse overhead

---

## **21. QUERY OPTIMIZATION WITH EXPLAIN**

> **Concept:** EXPLAIN shows PostgreSQL's query execution plan, crucial for identifying performance bottlenecks .

```sql
-- Basic EXPLAIN
EXPLAIN SELECT * FROM orders WHERE customer_id = 123;

-- EXPLAIN ANALYZE (actually executes the query)
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 123;

-- Verbose output
EXPLAIN (ANALYZE, VERBOSE, BUFFERS) 
SELECT * FROM orders WHERE customer_id = 123;

-- JSON format for programmatic analysis
EXPLAIN (FORMAT JSON) SELECT * FROM orders WHERE customer_id = 123;
```

### **Reading EXPLAIN Output**

```sql
EXPLAIN (ANALYZE, BUFFERS) 
SELECT o.id, c.name, o.total
FROM orders o
JOIN customers c ON o.customer_id = c.id
WHERE o.order_date >= '2024-01-01'
ORDER BY o.total DESC
LIMIT 10;
```

**Output Interpretation:**

| Term | Meaning | Good/Bad |
|------|---------|----------|
| **Seq Scan** | Sequential table scan | Bad on large tables |
| **Index Scan** | Index lookup | Good |
| **Index Only Scan** | Index covers query | Excellent |
| **Bitmap Heap Scan** | Bitmap index scan | Good for multiple conditions |
| **Nested Loop** | Join method | Good for small result sets |
| **Hash Join** | Build hash table | Good for large tables |
| **Merge Join** | Sorted inputs join | Good for sorted data |
| **cost=0.00..100.00** | Startup..total cost in arbitrary units | Lower is better |
| **rows=1000** | Estimated rows | Should be close to actual |
| **actual rows=950** | Actual rows (with ANALYZE) | Compare to estimate |
| **Buffers: shared hit=50** | Cache hits | High hit ratio good |

### **Common Optimization Patterns**

```sql
-- 1. Missing index
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 123;
-- Add index if you see Seq Scan on large table

-- 2. Function in WHERE (prevents index use)
-- BAD
EXPLAIN SELECT * FROM users WHERE LOWER(email) = 'john@example.com';
-- GOOD
CREATE INDEX idx_users_lower_email ON users(LOWER(email));
EXPLAIN SELECT * FROM users WHERE LOWER(email) = 'john@example.com';

-- 3. Data type mismatch
-- BAD (implicit cast)
EXPLAIN SELECT * FROM orders WHERE order_id = '123';  -- order_id is integer
-- GOOD
EXPLAIN SELECT * FROM orders WHERE order_id = 123;

-- 4. OR conditions
EXPLAIN SELECT * FROM orders 
WHERE status = 'pending' OR status = 'processing';
-- Consider UNION or array operator

-- 5. Poor statistics
ANALYZE orders;
```

---

## **22. CONFIGURATION PARAMETERS**

> **Concept:** PostgreSQL behavior is controlled through configuration parameters in postgresql.conf .

### **Key Configuration Categories**

### **Memory Settings**

| Parameter | Description | Recommended Value |
|-----------|-------------|-------------------|
| **shared_buffers** | Data cache memory | 15-25% of RAM |
| **work_mem** | Memory for sorts/joins (per operation) | 4-32MB (tune based on queries) |
| **maintenance_work_mem** | For VACUUM, CREATE INDEX | 10-20% of RAM |
| **effective_cache_size** | OS cache estimate | 50-75% of RAM |
| **wal_buffers** | WAL buffer size | 16-64MB |

### **Checkpoint Settings**

| Parameter | Description | Recommended |
|-----------|-------------|-------------|
| **checkpoint_timeout** | Max time between checkpoints | 5-15 minutes |
| **max_wal_size** | Max WAL size before checkpoint | 1-10GB |
| **min_wal_size** | Minimum WAL to keep | 80% of max_wal_size |

### **Autovacuum Settings**

| Parameter | Description | Typical |
|-----------|-------------|---------|
| **autovacuum** | Enable autovacuum | on |
| **autovacuum_max_workers** | Max worker processes | 3 |
| **autovacuum_vacuum_threshold** | Minimum dead tuples | 50 |
| **autovacuum_vacuum_scale_factor** | % of table dead tuples | 0.2 |

### **Connection Settings**

| Parameter | Description | Notes |
|-----------|-------------|-------|
| **max_connections** | Max client connections | Depends on RAM |
| **superuser_reserved_connections** | Reserved for admin | 3 |
| **listen_addresses** | Interfaces to listen | '*' for all |
| **port** | TCP port | 5432 default |

### **WAL Settings**

| Parameter | Description | Use |
|-----------|-------------|-----|
| **wal_level** | WAL detail level | minimal, replica, logical |
| **synchronous_commit** | Wait for WAL flush | on, off, remote_write |
| **archive_mode** | WAL archiving | on/off |
| **archive_command** | Archive command | cp to archive |

### **Viewing/Setting Configuration**

```sql
-- Show current value
SHOW shared_buffers;
SHOW work_mem;

-- Show all settings
SELECT name, setting, unit, context
FROM pg_settings
WHERE category LIKE '%Memory%';

-- Change at session level
SET work_mem = '32MB';

-- Change at database level
ALTER DATABASE mydb SET work_mem = '32MB';

-- Change in postgresql.conf (requires restart for some)
-- shared_buffers = 4GB
-- effective_cache_size = 12GB
```

---

## **23. SECURITY**

> **Concept:** PostgreSQL offers comprehensive security features including authentication, authorization, encryption, and access controls .

### **Authentication Methods**

| Method | Description | Use Case |
|--------|-------------|----------|
| **trust** | No authentication | Local development only |
| **md5** | MD5 password | Legacy, avoid |
| **scram-sha-256** | Modern password auth | Recommended |
| **peer** | OS user authentication | Local connections |
| **ldap** | LDAP authentication | Enterprise |
| **cert** | SSL certificate | High security |
| **gss** | Kerberos | Enterprise |

### **pg_hba.conf Configuration**

```conf
# TYPE  DATABASE  USER  ADDRESS       METHOD
# Local connections
local   all       all                 scram-sha-256

# IPv4 local connections
host    all       all   127.0.0.1/32  scram-sha-256

# IPv6 local connections
host    all       all   ::1/128       scram-sha-256

# Replication connections
host    replication all  192.168.1.0/24  scram-sha-256

# Encrypted remote connections
hostssl all       all   0.0.0.0/0     cert
```

### **SSL Configuration**

```sql
-- postgresql.conf
ssl = on
ssl_cert_file = 'server.crt'
ssl_key_file = 'server.key'
ssl_ca_file = 'ca.crt'

-- Require SSL for specific users
ALTER USER app_user SET ssl = 'on';
```

### **Row-Level Security**

```sql
-- Enable RLS on table
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Create policy
CREATE POLICY user_orders ON orders
    USING (customer_id = current_user_id());

-- Policy for different operations
CREATE POLICY sales_orders ON orders
    FOR SELECT
    USING (sales_rep = current_user);

CREATE POLICY sales_update ON orders
    FOR UPDATE
    USING (sales_rep = current_user)
    WITH CHECK (status IN ('pending', 'processing'));

-- Admin can bypass
ALTER TABLE orders FORCE ROW LEVEL SECURITY;
```

### **Column-Level Encryption**

```sql
-- Using pgcrypto
CREATE EXTENSION pgcrypto;

-- Encrypt data
INSERT INTO users (email, encrypted_ssn) 
VALUES ('john@example.com', pgp_sym_encrypt('123-45-6789', 'encryption_key'));

-- Decrypt
SELECT 
    email,
    pgp_sym_decrypt(encrypted_ssn, 'encryption_key') AS ssn
FROM users;
```

### **Audit Logging**

```sql
-- Using pgAudit extension
CREATE EXTENSION pgaudit;

-- Set audit level
ALTER SYSTEM SET pgaudit.log = 'write, ddl';
ALTER SYSTEM SET pgaudit.log_relation = on;

-- Query audit log
SELECT * FROM pg_audit_log 
WHERE user_id = current_user 
ORDER BY event_time DESC;
```

---

## **24. ROLE AND USER MANAGEMENT**

> **Concept:** PostgreSQL uses roles for authentication and authorization, with flexible permission systems .

### **Creating Roles and Users**

```sql
-- Create user (role with login)
CREATE USER app_user WITH PASSWORD 'secure_password';

-- Create role (no login by default)
CREATE ROLE read_only;

-- Create role with specific attributes
CREATE ROLE admin WITH 
    SUPERUSER 
    CREATEDB 
    CREATEROLE 
    INHERIT 
    LOGIN 
    REPLICATION 
    BYPASSRLS 
    PASSWORD 'admin_password';
```

### **Role Attributes**

| Attribute | Description |
|-----------|-------------|
| **SUPERUSER** | Bypasses all permissions |
| **CREATEDB** | Can create databases |
| **CREATEROLE** | Can create/modify roles |
| **INHERIT** | Inherits permissions from group roles |
| **LOGIN** | Can connect to database |
| **REPLICATION** | Can initiate replication |
| **BYPASSRLS** | Bypasses row-level security |
| **CONNECTION LIMIT** | Max concurrent connections |

### **Granting Privileges**

```sql
-- Grant on database
GRANT CONNECT ON DATABASE mydb TO app_user;

-- Grant on schema
GRANT USAGE ON SCHEMA public TO read_only;

-- Grant on tables
GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_only;

-- Grant on future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
    GRANT SELECT ON TABLES TO read_only;

-- Grant specific columns
GRANT SELECT (id, name) ON users TO reporting;

-- Grant execute on functions
GRANT EXECUTE ON FUNCTION calculate_tax() TO app_user;
```

### **Group Roles**

```sql
-- Create group roles
CREATE ROLE developers;
CREATE ROLE analysts;
CREATE ROLE admins;

-- Grant permissions to groups
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO developers;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analysts;
GRANT ALL PRIVILEGES ON DATABASE mydb TO admins;

-- Add users to groups
GRANT developers TO alice, bob;
GRANT analysts TO charlie;
GRANT admins TO dave;

-- Set default role
SET ROLE developers;

-- View role membership
SELECT rolname, member::regrole 
FROM pg_auth_members 
JOIN pg_roles ON pg_auth_members.roleid = pg_roles.oid;
```

### **Role Information**

```sql
-- Current user
SELECT current_user, session_user;

-- List roles
\du
-- or
SELECT rolname, rolsuper, rolcreatedb, rolcanlogin
FROM pg_roles;

-- Role privileges
SELECT 
    grantee,
    table_schema,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'app_user';
```

---

## **25. POSTGRESQL VS MYSQL**

> **Concept:** Key differences between two popular open-source databases .

### **Feature Comparison**

| Feature | PostgreSQL | MySQL |
|---------|------------|-------|
| **ACID Compliance** | ✅ Full | ⚠️ With InnoDB |
| **MVCC** | ✅ Yes | ✅ Yes (InnoDB) |
| **JSON Support** | ✅ Advanced (JSONB) | ✅ Basic |
| **Full-Text Search** | ✅ Built-in | ✅ Built-in |
| **Materialized Views** | ✅ Yes | ❌ No |
| **Window Functions** | ✅ Yes | ❌ (8.0+) |
| **CTEs** | ✅ Yes | ✅ (8.0+) |
| **Recursive Queries** | ✅ Yes | ✅ (8.0+) |
| **GIS Support** | ✅ PostGIS | ⚠️ Basic |
| **Replication** | Streaming, Logical | Master-Slave, Group |
| **Storage Engines** | Single engine | Multiple (InnoDB, MyISAM) |

### **When to Choose PostgreSQL **

| Use Case | Reason |
|----------|--------|
| **Complex queries** | Advanced optimizer, window functions |
| **Data integrity** | Strict ACID compliance |
| **Geospatial data** | PostGIS is industry standard |
| **JSON/NoSQL features** | JSONB with indexing |
| **Enterprise features** | Materialized views, partial indexes |
| **Concurrent write-heavy** | MVCC handles well |

### **When to Choose MySQL**

| Use Case | Reason |
|----------|--------|
| **Simple read-heavy** | Fast simple queries |
| **Web applications** | Popular with PHP |
| **Replication** | Simple master-slave setup |
| **Ease of use** | Simpler to configure |
| **Ecosystem** | Widely hosted, many tools |

---

## **26. POSTGRESQL VS SQL SERVER**

> **Concept:** Comparing open-source PostgreSQL with Microsoft's commercial database .

### **Core Differences**

| Feature | PostgreSQL | SQL Server |
|---------|------------|------------|
| **License** | Open Source (free) | Commercial (paid) |
| **Platform** | Cross-platform | Windows (primary), Linux |
| **Language** | PL/pgSQL, PL/Python, etc. | T-SQL, CLR languages |
| **Indexes** | B-tree, Hash, GiST, GIN, BRIN | Clustered, Nonclustered, Columnstore |
| **Replication** | Streaming, Logical | Always On, Replication, Log Shipping |
| **JSON Support** | ✅ Excellent (JSONB) | ✅ Good |
| **Materialized Views** | ✅ Yes | ✅ Yes (Indexed Views) |
| **Partitioning** | Declarative | Table/Index partitioning |

### **SQL Server Features Not in PostgreSQL**

- **Columnstore indexes** – Column-oriented storage for analytics 
- **In-Memory OLTP** – Memory-optimized tables
- **Temporal Tables** – Built-in historical data tracking
- **PolyBase** – Query external data sources
- **Graph database** – Node/edge tables

### **PostgreSQL Advantages Over SQL Server **

| Advantage | Explanation |
|-----------|-------------|
| **Cost** | Free, no licensing fees |
| **Extensibility** | Custom data types, operators |
| **Cross-platform** | Linux, macOS, Windows |
| **Community** | Large open-source community |
| **JSONB** | Superior JSON handling |
| **GIN/GiST indexes** | Advanced indexing for complex data |

### **Licensing Cost Comparison **

| Edition | PostgreSQL | SQL Server |
|---------|------------|------------|
| **Free** | Full features | Express (limited) |
| **Developer** | Free | Free (Developer Edition) |
| **Standard** | Free | $3,945 per 2-core pack |
| **Enterprise** | Free | $15,123 per 2-core pack |

---

## **27. COMMON INTERVIEW QUESTIONS**

### **Basic Level **

| Question | Answer |
|----------|--------|
| **What is PostgreSQL?** | Open-source object-relational database with ACID compliance, extensibility, and advanced features |
| **What are the key features?** | ACID, MVCC, JSONB support, advanced indexing, replication, extensibility |
| **Difference between CHAR and VARCHAR?** | CHAR fixed length (blank-padded), VARCHAR variable length with limit |
| **What is PRIMARY KEY?** | Uniquely identifies each record; ensures no duplicates or NULLs |
| **What is FOREIGN KEY?** | Links tables, ensures referential integrity |
| **What is an index?** | Database object that speeds up data retrieval |
| **What are ACID properties?** | Atomicity, Consistency, Isolation, Durability |

### **Intermediate Level **

| Question | Answer |
|----------|--------|
| **What is MVCC?** | Multi-Version Concurrency Control allows readers/writers without blocking |
| **Difference between DELETE, TRUNCATE, DROP?** | DELETE: DML, can rollback; TRUNCATE: DDL, fast; DROP: removes structure |
| **What is VACUUM?** | Reclaims storage from dead tuples, updates statistics |
| **What is WAL?** | Write-Ahead Logging for durability and crash recovery |
| **What is autovacuum?** | Background process automating VACUUM and ANALYZE |
| **Explain JOIN types** | INNER, LEFT, RIGHT, FULL, CROSS |
| **What are window functions?** | Calculations across rows without collapsing |
| **What is a CTE?** | Common Table Expression - temporary named result set |

### **Advanced Level **

| Question | Answer |
|----------|--------|
| **How does MVCC work internally?** | Uses xmin/xmax transaction IDs for row versions |
| **What is the difference between JSON and JSONB?** | JSON: text storage; JSONB: binary, indexable, faster operations |
| **How do you optimize a slow query?** | Use EXPLAIN ANALYZE, add indexes, rewrite queries, tune parameters |
| **What are GIN indexes?** | Generalized Inverted Index for composite types (arrays, JSONB) |
| **What is pg_stat_statements?** | Extension for tracking query statistics |
| **How do you set up replication?** | Configure WAL, create replication user, set up standby |
| **What is partitioning?** | Splitting large tables into smaller pieces |
| **What are the isolation levels?** | READ COMMITTED, REPEATABLE READ, SERIALIZABLE |
| **How do you perform PITR?** | Base backup + archived WAL + recovery.conf |

### **Practical Scenario Questions**

**Q: Find duplicate emails in users table**
```sql
SELECT email, COUNT(*)
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
```

**Q: Find top 3 highest-paid employees per department**
```sql
WITH ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) AS rn
    FROM employees
)
SELECT * FROM ranked WHERE rn <= 3;
```

**Q: Recover space from a bloated table**
```sql
VACUUM FULL verbose bloated_table;
-- or
VACUUM bloated_table;
```

**Q: Find tables with most dead tuples**
```sql
SELECT 
    schemaname,
    tablename,
    n_dead_tup,
    last_autovacuum,
    last_autoanalyze
FROM pg_stat_user_tables
ORDER BY n_dead_tup DESC
LIMIT 10;
```

---

## **28. QUICK REFERENCE CHEAT SHEET**

```sql
-- ========== DATABASE OPERATIONS ==========
CREATE DATABASE mydb;
\c mydb  -- Connect
DROP DATABASE mydb;

-- ========== TABLE OPERATIONS ==========
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE users ADD COLUMN age INT;
ALTER TABLE users DROP COLUMN age;
ALTER TABLE users RENAME TO customers;

DROP TABLE users;

-- ========== DATA MANIPULATION ==========
INSERT INTO users (name, email) VALUES ('John', 'john@example.com');
INSERT INTO users (name, email) VALUES ('Jane', 'jane@example.com') RETURNING id;

UPDATE users SET name = 'Johnny' WHERE id = 1;
DELETE FROM users WHERE id = 1;

-- ========== QUERYING ==========
SELECT * FROM users WHERE email LIKE '%@example.com' ORDER BY name LIMIT 10;

-- ========== INDEXES ==========
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_name_lower ON users(LOWER(name));
CREATE UNIQUE INDEX idx_users_email_unique ON users(email);

-- ========== VIEWS ==========
CREATE VIEW active_users AS SELECT * FROM users WHERE status = 'active';
CREATE MATERIALIZED VIEW monthly_stats AS SELECT ...;

-- ========== JSONB ==========
SELECT data->>'name' FROM products WHERE data @> '{"brand": "Apple"}';
CREATE INDEX idx_products_data ON products USING GIN(data);

-- ========== WINDOW FUNCTIONS ==========
SELECT *, ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary DESC) 
FROM employees;

-- ========== CTE ==========
WITH t AS (SELECT * FROM users WHERE status = 'active')
SELECT * FROM t;

-- ========== PARTITIONING ==========
CREATE TABLE orders (id INT, order_date DATE) PARTITION BY RANGE (order_date);

-- ========== ADMIN ==========
VACUUM ANALYZE;
REINDEX TABLE users;
SELECT pg_database_size('mydb');
SELECT pg_relation_size('users');

-- ========== MONITORING ==========
SELECT * FROM pg_stat_activity;
SELECT * FROM pg_stat_user_tables;
SELECT * FROM pg_stat_statements;

-- ========== BACKUP/RESTORE ==========
-- pg_dump mydb > mydb.sql
-- psql mydb < mydb.sql
-- pg_basebackup -D /backup/dir
```

---

## **📝 KEY TAKEAWAYS**

1. **Architecture**: Process-based with shared memory, background processes 
2. **MVCC**: Readers never block writers, writers never block readers 
3. **Indexing**: Multiple index types for different data (B-tree, GIN, GiST, BRIN) 
4. **JSONB**: Superior JSON support with indexing and operators 
5. **WAL**: Write-Ahead Logging for durability and replication 
6. **Vacuum**: Essential for reclaiming space and preventing transaction ID wraparound 
7. **Extensions**: Rich ecosystem (PostGIS, pg_stat_statements, pgcrypto) 
8. **Partitioning**: Declarative partitioning for large tables 
9. **Replication**: Streaming and logical replication options 
10. **Performance Tuning**: Use EXPLAIN ANALYZE, pg_stat_statements, proper indexing

---

*Good luck with your interview! 🎉*