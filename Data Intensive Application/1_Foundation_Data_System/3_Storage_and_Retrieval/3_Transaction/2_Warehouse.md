# Data Warehousing: Concepts and Applications

## Introduction

Data warehousing provides enterprises with dedicated analytical capabilities separate from their operational systems. This document outlines the key concepts, benefits, and applications of data warehouses in modern organizations.

## OLTP vs. Analytics Systems

Organizations typically maintain various transaction processing (OLTP) systems that:
- Power customer-facing websites
- Control point-of-sale systems
- Track inventory
- Manage suppliers and employees
- Operate autonomously from each other

OLTP systems prioritize:
- High availability
- Low latency transactions
- Operational stability

## The Need for Data Warehouses

Database administrators are typically reluctant to run analytical queries directly on OLTP systems because:
- Analytical queries are resource-intensive
- They can scan large portions of datasets
- This degrades performance for critical business transactions

## Data Warehouse Characteristics

A data warehouse is:
- A separate database optimized for analytical queries
- Contains read-only copies of data from various OLTP systems
- Allows analysts to run complex queries without affecting operational systems

## ETL Process

Data moves from OLTP systems to the data warehouse through Extract-Transform-Load (ETL):
1. **Extract**: Data is pulled from OLTP databases (periodic dumps or continuous streams)
2. **Transform**: Data is restructured into analysis-friendly schemas and cleaned
3. **Load**: Processed data is imported into the data warehouse

## Adoption Patterns

- Common in large enterprises with multiple data systems
- Less common in small companies that have:
  - Fewer OLTP systems
  - Smaller data volumes manageable with conventional databases or spreadsheets

## Technical Considerations

- Data warehouses are typically built on relational models using SQL
- Storage engines are specifically optimized for analytical access patterns
- Different indexing algorithms than those used in OLTP systems

## Implementation Options

### Commercial Solutions:
- Teradata
- Vertica
- SAP HANA
- ParAccel
- Amazon RedShift (hosted ParAccel)

### Open Source SQL-on-Hadoop Projects:
- Apache Hive
- Spark SQL
- Cloudera Impala
- Facebook Presto
- Apache Tajo
- Apache Drill

Some databases like Microsoft SQL Server and SAP HANA support both transaction processing and data warehousing, but increasingly through separate engines with a common SQL interface.